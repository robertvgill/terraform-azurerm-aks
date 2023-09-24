
resource "azurerm_kubernetes_cluster_node_pool" "aks" {
  count                  = var.aks_cluster_create && var.aks_user_node_pool_create ? 1 : 0

  name                   = lower(join("", var.projectname))
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.aks[0].id
  orchestrator_version   = data.azurerm_kubernetes_service_versions.current[0].latest_version
  node_count             = var.aks_user_node_pool.node_count
  vm_size                = var.aks_user_node_pool.vm_size
  availability_zones     = var.aks_user_node_pool.availability_zones
  max_pods               = var.aks_user_node_pool.max_pods
  os_disk_size_gb        = var.aks_user_node_pool.os_disk_size_gb
  os_type                = var.aks_user_node_pool.os_type
  ultra_ssd_enabled      = var.aks_user_node_pool.ultra_ssd_enabled
  vnet_subnet_id         = data.azurerm_subnet.aks[0].id
  node_labels            = var.aks_user_node_pool.node_labels
  node_taints            = var.aks_user_node_pool.node_taints
  enable_auto_scaling    = var.aks_user_node_pool.cluster_auto_scaling
  min_count              = var.aks_user_node_pool.cluster_auto_scaling_min_count
  max_count              = var.aks_user_node_pool.cluster_auto_scaling_max_count
  enable_node_public_ip  = var.aks_user_node_pool.enable_node_public_ip

  lifecycle {
    ignore_changes = [
      node_count
    ]
  }
}
