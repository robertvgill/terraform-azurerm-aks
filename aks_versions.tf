data "azurerm_kubernetes_service_versions" "current" {
  count               = var.aks_cluster_create ? 1 : 0

  location            = var.rg_location
  version_prefix      = var.aks_version_prefix
  include_preview     = false
}
