data "azurerm_public_ip" "outbound" {
  count               = var.aks_enable_http_application_routing ? 1 : 0

  name                = format("%s", var.aks_outbound_pip_name)
  resource_group_name = var.rg_resource_group_name
}

resource "azurerm_public_ip" "outbound" {
  count               = var.aks_enable_http_application_routing && var.aks_outbound_pip_create ? 1 : 0

  name                = format("%s", var.aks_outbound_pip_name)
  location            = var.rg_location
  resource_group_name = var.rg_resource_group_name
  allocation_method   = "Static"
  ip_version          = "IPv4"
  sku                 = "standard"
//  domain_name_label   =

  tags     = merge({ "ResourceName" = format("%s", var.aks_outbound_pip_name) }, var.tags, )
}
/**
data "azurerm_public_ip" "nginx_ingress" {
  count               = var.aks_nginxlb_pip_create ? 0 : 1

  name                = var.aks_nginxlb_pip_name
  resource_group_name = var.rg_resource_group_name
}
**/
resource "azurerm_public_ip" "nginx_ingress" {
  count               = var.aks_enable_http_application_routing && var.aks_nginxlb_pip_create ? 1 : 0

  name                = format("%s", var.aks_nginxlb_pip_name)
  location            = var.rg_location
  resource_group_name = var.rg_resource_group_name
  allocation_method   = "Static"
  ip_version          = "IPv4"
  sku                 = "standard"
//  domain_name_label   =

  tags     = merge({ "ResourceName" = format("%s", var.aks_nginxlb_pip_name) }, var.tags, )
}
