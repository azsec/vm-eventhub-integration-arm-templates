$resourceGroupName = "azsec-rg"
$location = "westus"

$eventHubNameSpaceName = "azsec-eventhub"
$windowsEventHubName = "windows_vm"
$linuxEventHubName = "linux_vm"
$windowsAuthorizationRuleName = "windows-policy"
$linuxAuthorizationRuleName = "linux-policy"


# Create Event Hub Namespace
New-AzureRmEventHubNamespace -ResourceGroupName $resourceGroupName `
                              -NamespaceName $eventHubNameSpaceName `
                              -SkuName "Standard"
                              -Location $location

# Create Windows Event Hub                             
New-AzureRmEventHub -ResourceGroupName $resourceGroupName `
                    -NamespaceName $eventHubNameSpaceName 
                    -EventHubName $windowsEventHubName `
                    -MessageRetentionInDays 3

# Create Linux Event Hub                             
New-AzureRmEventHub -ResourceGroupName $resourceGroupName `
                    -NamespaceName $eventHubNameSpaceName 
                    -EventHubName $linuxEventHubName `
                    -MessageRetentionInDays 3

# Create Windows Authorization Rule (Policy)
New-AzureRmEventHubAuthorizationRule -ResourceGroupName $resourceGroupName `
                                     -NamespaceName $eventHubNameSpaceName `
                                     -EventHubName $windowsEventHubName `
                                     -AuthorizationRuleName $windowsAuthorizationRuleName `
                                     -Rights @("Listen","Send")

# Create Linux Authorization Rule (Policy)
New-AzureRmEventHubAuthorizationRule -ResourceGroupName $resourceGroupName `
                                     -NamespaceName $eventHubNameSpaceName `
                                     -EventHubName $linuxEventHubName `
                                     -AuthorizationRuleName $linuxAuthorizationRuleName `
                                     -Rights @("Listen","Send")

# Get Windows Event Hub Shared Access Key
Get-AzureRmEventHubKey -ResourceGroupName $resourceGroupName ` 
                       -NamespaceName $eventHubNameSpaceName `
                       -EventHubName $windowsEventHubName `
                       -AuthorizationRuleName $windowsAuthorizationRuleName

# Get Windows Event Hub Shared Access Key
$linuxSharedAccessKey = Get-AzureRmEventHubKey -ResourceGroupName $resourceGroupName `
                       -NamespaceName $eventHubNameSpaceName `
                       -EventHubName $linuxEventHubName `
                       -AuthorizationRuleName $linuxAuthorizationRuleName

# Get Linux Event Hub SAS URL
[Reflection.Assembly]::LoadWithPartialName("System.Web")| out-null
$uri = "https//" + $eventHubNameSpaceName + ".servicebus.windows.net/" + $linuxEventHubName
$linuxSharedAccessKey = $linuxSharedAccessKey
$expires = ([DateTimeOffset]::Now.ToUnixTimeSeconds())+180
$signatureString=[System.Web.HttpUtility]::UrlEncode($uri)+ "`n" + [string]$expires
$HMAC = New-Object System.Security.Cryptography.HMACSHA256
$HMAC.key = [Text.Encoding]::ASCII.GetBytes($linuxSharedAccessKey)
$signature = $HMAC.ComputeHash([Text.Encoding]::ASCII.GetBytes($signatureString))
$signature = [Convert]::ToBase64String($Signature)
$sasUrl = "SharedAccessSignature sr=" + [System.Web.HttpUtility]::UrlEncode($uri) + "&sig=" + [System.Web.HttpUtility]::UrlEncode($signature) + "&se=" + $Expires + "&skn=" + $linuxEventHubName
Write-Host -ForegroundColor Yellow "Your Linux Event Hub SAS URL is:" $sasUrl