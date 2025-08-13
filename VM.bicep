param virtualMachines_BBB01_name string = 'BBB01'
param tenantID string = 'Fill in tenant ID'
param disks_BBB01_OsDisk_1_670762cccecc45d18280da407744ac17_externalid string = '/subscriptions/${tenantID}/resourceGroups/jops-speeltuin-rg/providers/Microsoft.Compute/disks/BBB01_OsDisk_1_670762cccecc45d18280da407744ac17'
param networkInterfaces_bbb01782_z1_externalid string = '/subscriptions/${tenantID}/resourceGroups/jops-speeltuin-rg/providers/Microsoft.Network/networkInterfaces/bbb01782_z1'

resource vm 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: virtualMachines_BBB01_name
  location: 'northeurope'
  zones: [
    '1'
  ]
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_F8as_v6'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachines_BBB01_name}_OsDisk_1_670762cccecc45d18280da407744ac17'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          id: resourceId('Microsoft.Compute/disks', osDiskName)
        }
        deleteOption: 'Delete'
      }
      dataDisks: []
      diskControllerType: 'NVMe'
    }
    osProfile: {
      computerName: virtualMachines_BBB01_name
      adminUsername: 'BBBadmin'
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_bbb01782_z1_externalid
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}
