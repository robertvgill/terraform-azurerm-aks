resource "azurerm_private_endpoint" "akspep" {
  count               = var.aks_cluster_create && var.aks_private_cluster_enabled ? 1 : 0

  resource_group_name = var.rg_resource_group_name
  location            = var.rg_location

  name                = format("%s-private-endpoint", var.aks_cluster_name)
  subnet_id           = data.azurerm_subnet.aks[0].id

  private_service_connection {
    name                           = format("%s-private-endpoint", var.aks_cluster_name)
    is_manual_connection           = false
    private_connection_resource_id = azurerm_kubernetes_cluster.aks[0].id
    subresource_names              = ["management"]
  }

  private_dns_zone_group {
    name                 = azurerm_kubernetes_cluster.aks[0].name
    private_dns_zone_ids = [azurerm_private_dns_zone.dz[0].id]
  }

  tags     = merge({ "ResourceName" = format("%s-private-endpoint", var.aks_cluster_name) }, var.tags, )
}
