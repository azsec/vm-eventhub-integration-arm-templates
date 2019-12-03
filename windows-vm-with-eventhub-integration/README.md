# Simple deployment of Windows VM that supports sending security event to Event Hub

This template allows you to deploy a Windows VM that supports sending security event to Event Hub so you can connect your SIEM to that Event Hub. or more details on specific configuration, refer to the following references:
- [Streaming Azure Diagnostics data in the hot path by using Event Hubs](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/diagnostics-extension-stream-event-hubs)
- [VM Security Log to Event Hub for SIEM integration](https://azsec.azurewebsites.net/2019/12/03/vm-security-log-to-event-hub-for-siem-integration/)

> This is a sample template to showcase Event Hub integration. All secrets in the template should be protected in Key Vault if you go production.

If you are new to Azure virtual machines, see:

- [Azure Virtual Machines](https://azure.microsoft.com/services/virtual-machines/).
- [Azure Linux Virtual Machines documentation](https://docs.microsoft.com/azure/virtual-machines/linux/)
- [Azure Windows Virtual Machines documentation](https://docs.microsoft.com/azure/virtual-machines/windows/)
- [Template reference](https://docs.microsoft.com/azure/templates/microsoft.compute/allversions)
- [Quickstart templates](https://azure.microsoft.com/resources/templates/?resourceType=Microsoft.Compute&pageNumber=1&sort=Popular)
