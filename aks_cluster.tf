## subnet
data "azurerm_subnet" "aks" {
  count      = var.aks_cluster_create ? 1 : 0

  name                 = var.aks_vnet_subnet_name
  virtual_network_name = var.aks_virtual_network_name
  resource_group_name  = var.rg_resource_group_name
}

## kubernetes cluster
locals {
  outbound_pip = element(coalescelist(data.azurerm_public_ip.outbound.*.id, azurerm_public_ip.outbound.*.id, [""]), 0)
}

resource "azurerm_kubernetes_cluster" "aks" {
  count      = var.aks_cluster_create ? 1 : 0

  name                      = format("%s", var.aks_cluster_name)
  location                  = var.rg_location
  resource_group_name       = var.rg_resource_group_name

  dns_prefix                          = var.aks_dns_prefix
  sku_tier                            = var.aks_sku_tier
  kubernetes_version                  = data.azurerm_kubernetes_service_versions.current[0].latest_version
  node_resource_group                 = var.aks_node_resource_group
  private_cluster_enabled             = var.aks_private_cluster_enabled
  private_cluster_public_fqdn_enabled = var.aks_private_cluster_enabled ? true : false
  private_dns_zone_id                 = var.aks_private_cluster_enabled ? azurerm_private_dns_zone.dz[0].id : null
  automatic_channel_upgrade           = var.aks_automatic_channel_upgrade
/**
  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
        key_data = data.azurerm_key_vault_secret.pub_key[count.index].value
    }
  }
**/
  dynamic "default_node_pool" {
    for_each = var.aks_enable_auto_scaling == true ? [] : ["default_node_pool_manually_scaled"]

    content {
      name                   = substr(var.aks_default_node_pool.name, 0, 12)
      orchestrator_version   = data.azurerm_kubernetes_service_versions.current[0].latest_version
      node_count             = var.aks_default_node_pool.node_count
      vm_size                = var.aks_default_node_pool.vm_size
      type                   = var.aks_default_node_pool.type
      availability_zones     = var.aks_default_node_pool.availability_zones
      max_pods               = var.aks_default_node_pool.max_pods
      os_disk_size_gb        = var.aks_default_node_pool.os_disk_size_gb
      ultra_ssd_enabled      = var.aks_default_node_pool.ultra_ssd_enabled
      vnet_subnet_id         = data.azurerm_subnet.aks[count.index].id
      node_labels            = var.aks_default_node_pool.node_labels
      node_taints            = var.aks_default_node_pool.node_taints
      enable_auto_scaling    = var.aks_default_node_pool.cluster_auto_scaling
      min_count              = null
      max_count              = null
      enable_host_encryption = var.aks_default_node_pool.enable_host_encryption
      enable_node_public_ip  = var.aks_default_node_pool.enable_node_public_ip
    }
  }

  dynamic "default_node_pool" {
    for_each = var.aks_enable_auto_scaling == true ? ["default_node_pool_auto_scaled"] : []

    content {
      name                   = substr(var.aks_default_node_pool.name, 0, 12)
      orchestrator_version   = data.azurerm_kubernetes_service_versions.current[0].latest_version
      node_count             = var.aks_default_node_pool.node_count
      vm_size                = var.aks_default_node_pool.vm_size
      type                   = var.aks_default_node_pool.type
      availability_zones     = var.aks_default_node_pool.availability_zones
      max_pods               = var.aks_default_node_pool.max_pods
      os_disk_size_gb        = var.aks_default_node_pool.os_disk_size_gb
      ultra_ssd_enabled      = var.aks_default_node_pool.ultra_ssd_enabled
      vnet_subnet_id         = data.azurerm_subnet.aks[count.index].id
      node_labels            = var.aks_default_node_pool.node_labels
      node_taints            = var.aks_default_node_pool.node_taints
      enable_auto_scaling    = var.aks_default_node_pool.cluster_auto_scaling
      min_count              = var.aks_default_node_pool.cluster_auto_scaling_min_count
      max_count              = var.aks_default_node_pool.cluster_auto_scaling_max_count
      enable_host_encryption = var.aks_default_node_pool.enable_host_encryption
      enable_node_public_ip  = var.aks_default_node_pool.enable_node_public_ip
    }
  }

  dynamic "service_principal" {
    for_each = var.aks_service_principal.client_id != "" && var.aks_service_principal.client_secret != "" ? ["service_principal"] : []

    content {
      client_id     = var.aks_service_principal.client_id
      client_secret = var.aks_service_principal.client_secret
    }
  }

  dynamic "identity" {
    for_each = var.aks_service_principal.client_id == "" || var.aks_service_principal.client_secret == "" ? ["identity"] : []

    content {
      type                      = var.aks_identity_type != null ? "SystemAssigned, UserAssigned" : "SystemAssigned"
      user_assigned_identity_id = var.aks_user_assigned_identity_id
    }
  }

  addon_profile {
    http_application_routing {
      enabled = var.aks_enable_http_application_routing
    }

    kube_dashboard {
      enabled = var.aks_enable_kube_dashboard
    }

    azure_policy {
      enabled = var.aks_enable_azure_policy
    }

    oms_agent {
      enabled                    = var.aks_enable_log_analytics_workspace
      log_analytics_workspace_id = var.aks_enable_log_analytics_workspace ? azurerm_log_analytics_workspace.aks[0].id : null
    }
}

  role_based_access_control {
    enabled = var.aks_enable_role_based_access_control

    dynamic "azure_active_directory" {
      for_each = var.aks_enable_role_based_access_control && var.aks_rbac_aad_managed ? ["rbac"] : []
      content {
        managed                = true
        admin_group_object_ids = var.aks_rbac_aad_admin_group_object_ids
      }
    }

    dynamic "azure_active_directory" {
      for_each = var.aks_enable_role_based_access_control && !var.aks_rbac_aad_managed ? ["rbac"] : []
      content {
        managed           = false
        client_app_id     = var.aks_rbac_aad_client_app_id
        server_app_id     = var.aks_rbac_aad_server_app_id
        server_app_secret = var.aks_rbac_aad_server_app_secret
      }
    }
  }

    network_profile {
      load_balancer_sku  = var.aks_network_profile.load_balancer_sku
//      load_balancer_profile {
//        outbound_ip_address_ids = []
//      }
      outbound_type      = var.aks_network_profile.outbound_type
      network_plugin     = var.aks_network_profile.network_plugin
      network_policy     = var.aks_network_profile.network_policy
      dns_service_ip     = var.aks_network_profile.dns_service_ip
      docker_bridge_cidr = var.aks_network_profile.docker_bridge_cidr
      service_cidr       = var.aks_network_profile.service_cidr
      pod_cidr           = var.aks_network_profile.pod_cidr
    }

    lifecycle {
      ignore_changes = [
        default_node_pool[0].node_count,
        default_node_pool[0].tags
      ]
    }

    tags     = merge({ "ResourceName" = format("%s", var.aks_cluster_name) }, var.tags, )
}
