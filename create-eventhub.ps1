$resourceGroupName = "azsec-rg"
$location = "westus"

$eventHubNameSpaceName = "azsec-eventhub"
$windowsEventHubName = "windows_vm"
$linuxEventHubName = "linux_vm"
$windowsAuthorizationRuleName = "windows-policy"
$linuxAuthorizationRuleName = "linux-policy"


# Create Event Hub Namespace
New-AzEventHubNamespace -ResourceGroupName $resourceGroupName -NamespaceName $eventHubNameSpaceName -SkuName "Basic" -Location $location

# Create Windows Event Hub                             
New-AzEventHub -ResourceGroupName $resourceGroupName -NamespaceName $eventHubNameSpaceName -Name $windowsEventHubName -MessageRetentionInDays 1

# Create Linux Event Hub                             
New-AzEventHub -ResourceGroupName $resourceGroupName -NamespaceName $eventHubNameSpaceName -Name $linuxEventHubName -MessageRetentionInDays 1

# Create Windows Authorization Rule (Policy)
New-AzEventHubAuthorizationRule -ResourceGroupName $resourceGroupName `
                                     -NamespaceName $eventHubNameSpaceName `
                                     -EventHubName $windowsEventHubName `
                                     -AuthorizationRuleName $windowsAuthorizationRuleName `
                                     -Rights @("Listen","Send")

# Create Linux Authorization Rule (Policy)
New-AzEventHubAuthorizationRule -ResourceGroupName $resourceGroupName `
                                     -NamespaceName $eventHubNameSpaceName `
                                     -EventHubName $linuxEventHubName `
                                     -AuthorizationRuleName $linuxAuthorizationRuleName `
                                     -Rights @("Listen","Send")

# Get Windows Event Hub Shared Access Key

Get-AzEventHubKey -ResourceGroupName $resourceGroupName  `
                    -NamespaceName $eventHubNameSpaceName  `
                    -EventHubName $windowsEventHubName `
                    -AuthorizationRuleName $windowsAuthorizationRuleName

# Get Linux Event Hub Shared Access Key
$linuxSharedAccessKey = Get-AzEventHubKey -ResourceGroupName $resourceGroupName `
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
