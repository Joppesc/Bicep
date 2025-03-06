module deployStorageAccount '../../modules/avm/res/storage/storage-account/main.bicep' = {
  scope: basicInfraResourceGroup
  name: 'deploy-${parStorageAccountName}'
  params: {
    name: parStorageAccountName
    skuName: 'Standard_LRS'
    kind: 'StorageV2'
    publicNetworkAccess: 'Disabled'
    allowBlobPublicAccess: false
    enableHierarchicalNamespace: false
    minimumTlsVersion: 'TLS1_2'
    allowedCopyScope: 'AAD'
    requireInfrastructureEncryption: true
    networkAcls: {
      bypass: 'Logging, Metrics'
      defaultAction: 'Deny'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        deployManagedIdentity.outputs.resourceId
      ]
    }
    customerManagedKey: {
      keyName: deployKeys[0].outputs.name
      keyVaultResourceId: deployKeyVault.outputs.resourceId
      userAssignedIdentityResourceId: deployManagedIdentity.outputs.resourceId
    }
    privateEndpoints: [
      {
        name: '${parStorageAccountName}-endpoint001'
        subnetResourceId: parPrivateEndpointSubnetId
        privateLinkServiceConnectionName: 'filesharenelink'
        customNetworkInterfaceName: '${parStorageAccountName}-endpoint001-nic'
        service: 'blob'
        tags: parTags
      }
    ]
    tags: parTags
  }
} 
