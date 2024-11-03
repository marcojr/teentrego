param (
    [string]$subscriptionId,
    [string]$subscriptionName,
    [string]$organizationName
)

# Set the subscription
az account set --subscription $subscriptionId

# Define naming conventions following Cloud Adoption Framework Naming Conventions
$selfHostAgentName = "vm-teentrego-shared-agent-001"
$poolName = "Default"
$spName = "sp-teentrego-devops"
$organizationName = "teentrego"
$projectName = "teentrego-azure"

# Create the shared resource group
$resourceGroupName = "rg-teentrego-devops"
$location = "brazilsouth"

Write-Host "Creating resource group $resourceGroupName in $location"
az group create --name $resourceGroupName --location $location

# Create storage account for Terraform backend
$storageAccountName = "stteentregotfstate"
Write-Host "Creating storage account $storageAccountName for backend in resource group $resourceGroupName"
az storage account create --name $storageAccountName --resource-group $resourceGroupName --location $location --sku Standard_LRS --kind StorageV2 --allow-blob-public-access false --encryption-services blob --access-tier Hot

# Create container for Terraform backend
$containerName = "tfstate"
Write-Host "Creating container '$containerName-dev' in storage account $storageAccountName"
az storage container create --name $containerName-dev --account-name $storageAccountName
Write-Host "Creating container '$containerName-sit' in storage account $storageAccountName"
az storage container create --name $containerName-sit --account-name $storageAccountName
Write-Host "Creating container '$containerName-prod' in storage account $storageAccountName"
az storage container create --name $containerName-prod --account-name $storageAccountName


# Check if the Service Principal already exists and delete it if it does
$spExists = az ad sp list --display-name $spName | ConvertFrom-Json

if ($spExists.Count -gt 0) {
    Write-Host "Service Principal already exists. Deleting the existing SP: $spName"
    az ad sp delete --id $spExists[0].appId
    Start-Sleep -Seconds 15  # Give some time for the deletion to propagate
}

# Now, create the Service Principal again
Write-Host "Creating new Service Principal for ARM connection"
$sp = az ad sp create-for-rbac --name $spName --role contributor --scopes "/subscriptions/$subscriptionId" --sdk-auth | ConvertFrom-Json
$spClientId = $sp.clientId
$spClientSecret = $sp.clientSecret  # The secret is generated automatically when SP is created
$spTenantId = $sp.tenantId
Write-Host "Service Principal created with clientId: $spClientId"

Write-Host "spClientId: $spClientId"
Write-Host "subscriptionId: $subscriptionId"
Write-Host "subscriptionName: $subscriptionName"
Write-Host "spTenantId: $spTenantId"
Write-Host "spClientSecret: $spClientSecret"
Write-Host "organizationName: $organizationName"
Write-Host "poolName: $poolName"

# Create ARM connection in Azure DevOps
Write-Host "Creating ARM connection in Azure DevOps"
$pat = Read-Host -Prompt "Enter your Azure DevOps Personal Access Token"
az devops configure --defaults organization=https://dev.azure.com/$organizationName project=$projectName
#az devops service-endpoint azurerm create --name "Azure ARM Connection" --azure-rm-service-principal-id $spClientId --azure-rm-subscription-id $subscriptionId --azure-rm-subscription-name "$subscriptionName" --azure-rm-tenant-id  $spTenantId --azure-rm-service-principal-key "$spClientSecret" --organization "https://dev.azure.com/$organizationName" --project $projectName
az devops service-endpoint azurerm create --name "Azure ARM Connection" --azure-rm-service-principal-id $spClientId --azure-rm-subscription-id $subscriptionId --azure-rm-subscription-name "$subscriptionName" --azure-rm-tenant-id  $spTenantId --organization "https://dev.azure.com/$organizationName" --project $projectName

# Create VM for Self-Hosted Agent
Write-Host "Creating VM $selfHostAgentName"
az vm create --resource-group $resourceGroupName --name $selfHostAgentName --image Ubuntu2204 --admin-username azureuser --generate-ssh-keys

# Get the public IP of the created VM
Write-Host "Fetching public IP of the VM $selfHostAgentName"
$publicIp = az vm show --resource-group $resourceGroupName --name $selfHostAgentName --show-details --query publicIps -o tsv

# Verifique se $publicIp contém um valor válido antes de continuar
if (-not $publicIp) {
    Write-Host "Error: Could not retrieve public IP address for the VM."
    exit 1
}

# Certifique-se de que o valor da variável $publicIp foi capturado corretamente
Write-Host "Public IP of the VM is $publicIp"

# Comandos que serão enviados para a VM
$sshCommand = @"
sudo apt-get update &&
sudo apt-get install -y libssl-dev &&
mkdir -p myagent && cd myagent &&
curl -O https://vstsagentpackage.azureedge.net/agent/4.246.1/vsts-agent-linux-x64-4.246.1.tar.gz &&
tar zxvf vsts-agent-linux-x64-4.246.1.tar.gz &&
./config.sh --unattended --url https://dev.azure.com/$organizationName --auth pat --token $pat --pool $poolName &&
sudo ./svc.sh install && sudo ./svc.sh start
"@

# Crie o script para enviar para a VM, garantindo que ele está no formato Unix (LF)
$sshCommand | Set-Content -Path command_to_run.sh -NoNewline -Encoding UTF8

# Envie o script para a VM usando concatenação correta da variável $publicIp
Write-Host "Uploading the script to the VM $selfHostAgentName with IP $publicIp"
scp -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa command_to_run.sh azureuser@$($publicIp):/tmp/

# Execute o script na VM usando concatenação correta da variável $publicIp
Write-Host "Executing the script on the VM"
ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa azureuser@$($publicIp) "bash /tmp/command_to_run.sh"
Write-Host "Bootstrap Environment created sucessfully"

# ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa azureuser@$($publicIp)


