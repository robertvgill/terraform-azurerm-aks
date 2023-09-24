data "azurerm_container_registry" "cr" {
  count               = var.aks_enable_attach_acr ? 1 : 0

  name                = format("%s", var.cr_registry_name)
  resource_group_name = var.rg_resource_group_name
}

resource "azurerm_role_assignment" "aks_acr" {
  count      = var.aks_enable_attach_acr ? 1 : 0

  scope                            = data.azurerm_container_registry.cr[0].id
  role_definition_name             = "AcrPull"
  principal_id                     = var.aks_service_principal.object_id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "dns" {
  count                = var.aks_cluster_create && var.aks_private_cluster_enabled ? 1 : 0

  scope                = azurerm_private_dns_zone.dz[0].id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = var.aks_service_principal.object_id
}

resource "azurerm_role_assignment" "aks" {
  count = var.aks_enable_log_analytics_workspace ? 1 : 0

  scope                = azurerm_kubernetes_cluster.aks[0].id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = var.aks_service_principal.object_id
}
