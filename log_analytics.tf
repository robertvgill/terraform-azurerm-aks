## log analytics
resource "azurerm_log_analytics_workspace" "aks" {
  count               = var.aks_enable_log_analytics_workspace ? 1 : 0

  resource_group_name = var.rg_resource_group_name
  location            = var.rg_location

  name                = var.aks_log_analytics_workspace_name == null ? "${var.aks_dns_prefix}-workspace" : var.aks_log_analytics_workspace_name
  sku                 = var.aks_log_analytics_workspace_sku
  retention_in_days   = var.aks_log_retention_in_days

  tags     = merge({ "ResourceName" = format("%s", var.aks_log_analytics_workspace_name == null ? "${var.aks_dns_prefix}-workspace" : var.aks_log_analytics_workspace_name) }, var.tags, )
}

resource "azurerm_log_analytics_solution" "aks" {
  count               = var.aks_enable_log_analytics_workspace ? 1 : 0

  resource_group_name = var.rg_resource_group_name
  location            = var.rg_location

  solution_name         = "ContainerInsights"
  workspace_resource_id = azurerm_log_analytics_workspace.aks[0].id
  workspace_name        = azurerm_log_analytics_workspace.aks[0].name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}
