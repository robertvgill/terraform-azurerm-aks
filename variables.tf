## naming
variable "department" {
  description = "Specifies the name of the department."
  type        = list(string)
  default     = []
}

variable "projectname" {
  description = "Specifies the name of the project."
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "Specifies the name of the environment."
  type        = list(string)
  default     = []
}

variable "region_mapping" {
  description = "Specifies the name of the region."
  type        = list(string)
  default     = []
}

## resource group
variable "rg_resource_group_name" {
  description = "The name of the resource group in which to create the storage account."
  type        = string
  default     = null
}

variable "rg_location" {
  description = "Specifies the supported Azure location where the resource should be created."
  type        = string
  default     = null
}

## key vault
variable "kv_key_vault_name" {
  description = "The name of the Key Vault for PostgreSQL."
  type        = string
}

## virtual network
variable "aks_vnet_subnet_name" {
  description = "The name of the Virtual Network for AKS."
  type        = string
}

variable "aks_virtual_network_name" {
  description = "The name of the Subnet for AKS."
  type        = string
}

## kubernetes cluster
variable "aks_cluster_create" {
  description = "Controls if Azure Kubernetes cluster should be created."
  type        = bool
}

variable "aks_cluster_name" {
  description = "(Required) The name of the Managed Kubernetes Cluster to create. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "aks_linux_ssh_key_name" {
  description = "(Required) Specifies the name of the Key Vault Key."
  type        = string
  default     = null
}

variable "aks_dns_prefix" {
  description = "(Optional) DNS prefix specified when creating the managed cluster. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "aks_version_prefix" {
  description = "(Optional) A prefix filter for the versions of Kubernetes which should be returned."
  type        = string
  default     = null
}

variable "aks_sku_tier" {
  description = "(Optional) The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid (which includes the Uptime SLA). Defaults to Free."
  type        = string
  default     = null
}

variable "aks_kubernetes_version" {
  description = "(Optional) Version of Kubernetes specified when creating the AKS managed cluster. If not specified, the latest recommended version will be used at provisioning time (but won't auto-upgrade)."
  type        = string
  default     = null
}

variable "aks_enable_auto_scaling" {
  type        = bool
}

variable "aks_node_resource_group" {
  description = "(Optional) The name of the Resource Group where the Kubernetes Nodes should exist. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "aks_private_cluster_enabled" {
  description = "This provides a Private IP Address for the Kubernetes API on the Virtual Network where the Kubernetes Cluster is located. Defaults to false. Changing this forces a new resource to be created."
  type        = bool
}

variable "aks_private_dns_zone_id" {
  description = "(Optional) Either the ID of Private DNS Zone which should be delegated to this Cluster, System to have AKS manage this or None. In case of None you will need to bring your own DNS server and set up resolving, otherwise cluster will have issues after provisioning."
  type        = string
  default     = null
}

variable "aks_automatic_channel_upgrade" {
  description = "(Optional) The upgrade channel for this Kubernetes Cluster. Possible values are patch, rapid, node-image and stable."
  type        = string
  default     = "stable"
}

variable "aks_default_node_pool" {
  type = object({
    name                           = string
    node_count                     = number
    vm_size                        = string
    type                           = string
    availability_zones             = list(string)
    max_pods                       = number
    os_disk_size_gb                = number
    ultra_ssd_enabled              = bool
    node_labels                    = map(string)
    node_taints                    = list(string)
    cluster_auto_scaling           = bool
    cluster_auto_scaling_min_count = number
    cluster_auto_scaling_max_count = number
    enable_host_encryption         = bool
    enable_node_public_ip          = bool
  })
  default     = null
}

variable "aks_service_principal" {
  description = "Service principal to connect to cluster."
  type = object({
    object_id     = string
    client_id     = string
    client_secret = string
  })
  default     = null
}

variable "aks_identity_type" {
  description = "(Optional) The type of identity used for the managed cluster. Conflict with `client_id` and `client_secret`. Possible values are `SystemAssigned` and `UserAssigned`. If `UserAssigned` is set, a `user_assigned_identity_id` must be set as well."
  type        = string
  default     = "SystemAssigned"
}

variable "aks_user_assigned_identity_id" {
  description = "(Optional) The ID of a user assigned identity."
  type        = string
  default     = null
}

variable "aks_enable_http_application_routing" {
  description = "(Required) Is HTTP Application Routing Enabled?"
  type        = bool
  default     = null
}

variable "aks_enable_kube_dashboard" {
  description = "(Required) Is the Kubernetes Dashboard enabled?"
  type        = bool
  default     = null
}

variable "aks_enable_azure_policy" {
  description = "(Required) Is the Azure Policy for Kubernetes Add On enabled?"
  type        = bool
  default     = null
}

variable "aks_enable_log_analytics_workspace" {
  type        = bool
  description = "Enable the creation of azurerm_log_analytics_workspace and azurerm_log_analytics_solution or not."
  default     = true
}

variable "aks_enable_role_based_access_control" {
  description = "Enable Role Based Access Control."
  type        = bool
  default     = false
}

variable "aks_rbac_aad_managed" {
  description = "Is the Azure Active Directory integration Managed, meaning that Azure will create/manage the Service Principal used for integration."
  type        = bool
  default     = false
}

variable "aks_rbac_aad_admin_group_object_ids" {
  description = "Object ID of groups with admin access."
  type        = list(string)
  default     = null
}

variable "aks_rbac_aad_client_app_id" {
  description = "The Client ID of an Azure Active Directory Application."
  type        = string
  default     = null
}

variable "aks_rbac_aad_server_app_id" {
  description = "The Server ID of an Azure Active Directory Application."
  type        = string
  default     = null
}

variable "aks_rbac_aad_server_app_secret" {
  description = "The Server Secret of an Azure Active Directory Application."
  type        = string
  default     = null
}

variable "aks_network_profile" {
  type = object({
    load_balancer_sku  = string
    outbound_type      = string
    network_plugin     = string
    network_policy     = string
    dns_service_ip     = string
    docker_bridge_cidr = string
    service_cidr       = string
    pod_cidr           = string
  })
}

variable "aks_user_node_pool_create" {
  description = "Controls if user mode node pool should be created."
  type        = bool
}

variable "aks_user_node_pool" {
  type = object({
    node_count                     = number
    vm_size                        = string
    type                           = string
    availability_zones             = list(string)
    max_pods                       = number
    os_disk_size_gb                = number
    os_type                        = string
    ultra_ssd_enabled              = bool
    node_labels                    = map(string)
    node_taints                    = list(string)
    cluster_auto_scaling           = bool
    cluster_auto_scaling_min_count = number
    cluster_auto_scaling_max_count = number
    enable_node_public_ip          = bool
  })
  default     = null
}

variable "aks_log_analytics_workspace_name" {
  description = "The name of the Analytics workspace."
  type        = string
  default     = null
}

variable "aks_log_analytics_workspace_sku" {
  description = "The SKU (pricing level) of the Log Analytics workspace. For new subscriptions the SKU should be set to PerGB2018"
  type        = string
  default     = "PerGB2018"
}

variable "aks_log_retention_in_days" {
  description = "The retention period for the logs in days"
  type        = number
  default     = 30
}

variable "aks_outbound_pip_create" {
  description = "Controls if an outbound public IP address should be created."
  type        = bool
}

variable "aks_outbound_pip_name" {
  description = "Specifies the name of the outbound public IP resource."
  type        = string
  default     = null
}

variable "aks_nginxlb_pip_create" {
  description = "Controls if an NGINX Ingress public IP address should be created."
  type        = bool
}

variable "aks_nginxlb_pip_name" {
  description = "Specifies the name of the NGINX Ingress public IP resource."
  type        = string
  default     = null
}

variable "aks_enable_attach_acr" {
  type        = bool
  default     = null
}

variable "aks_private_dns_zone_name" {
  description = "The name of the Private DNS zone."
  default     = null
}

variable "cr_registry_name" {
  description = "Name of the container registry resource created in the specified Azure Resource Group."
  type        = string
  default     = null
}

variable "nw_virtual_network_name" {
  description = "The name of the Virtual Network."
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}
