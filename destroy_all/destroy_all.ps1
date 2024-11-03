param (
    [string]$subscriptionId
)
$poolName = "Default"
$spName = "sp-teentrego-devops"
$organizationName = "teentrego"
$projectName = "teentrego-azure"

# Check if the required parameters are provided
if (-not $subscriptionId -or -not $organizationName -or -not $projectName -or -not $poolName) {
    Write-Host "All parameters 'subscriptionId', 'organizationName', 'projectName', and 'poolName' are required." -ForegroundColor Red
    exit 1
}

# Set the Azure subscription
Write-Host "Setting the Azure subscription..." -ForegroundColor Cyan
az account set --subscription $subscriptionId

# Define Resource Group, VM, and Service Principal names based on conventions
$resourceGroupNameDevOps = "rg-teentrego-devops"
$spName = "sp-teentrego-devops"

# Step 1: Remove the Self-Hosted Agent from the Azure DevOps Pool - Removed
Write-Host "Skipping the removal of the self-hosted agent from the pool $poolName. Please perform this action manually." -ForegroundColor Yellow

# Step 2: Delete the Service Principal (SP)
Write-Host "Deleting the Service Principal $spName if it exists..." -ForegroundColor Cyan
$spExists = az ad sp list --display-name $spName | ConvertFrom-Json
if ($spExists.Count -gt 0) {
    Write-Host "Service Principal found. Deleting the existing SP: $spName"
    az ad sp delete --id $spExists[0].appId
    Start-Sleep -Seconds 15  # Wait for deletion to propagate
}
else {
    Write-Host "Service Principal not found." -ForegroundColor Yellow
}


# Step 4: Delete the Resource Group DevOps
Write-Host "Deleting the Resource Group $resourceGroupNameDevOps" -ForegroundColor Cyan
az group delete --name $resourceGroupNameDevOps --subscription $subscriptionId --yes --no-wait

Write-Host "Deletion initiated for Resource Group $resourceGroupName." -ForegroundColor Green

# Step 3: Delete Resource Groups for Different Environments (dev, sit, prod)
$environments = @("dev", "sit", "prod")
foreach ($env in $environments) {
    $resourceGroupName = "rg-teentrego-$env"
    Write-Host "Deleting the Resource Group $resourceGroupName" -ForegroundColor Cyan
    az group delete --name $resourceGroupName --subscription $subscriptionId --yes --no-wait
}

# Step 4: Delete the Resource Group DevOps
Write-Host "Deleting the Resource Group $resourceGroupNameDevOps" -ForegroundColor Cyan
az group delete --name $resourceGroupNameDevOps --subscription $subscriptionId --yes --no-wait

# Final message
Write-Host "Deletion initiated for all specified Resource Groups." -ForegroundColor Green