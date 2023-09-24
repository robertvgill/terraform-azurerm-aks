## aks
output "aks_name" {
  description = "The URL that can be used to log into the container registry."
  value       = var.aks_cluster_create ? element(concat(azurerm_kubernetes_cluster.aks[*].name, [""]), 0) : null
}

output "aks_client_certificate" {
  value       = var.aks_cluster_create ? element(concat(azurerm_kubernetes_cluster.aks[*].kube_config.0.client_certificate, [""]), 0) : null
}

output "aks_kube_config" {
  value       = var.aks_cluster_create ? element(concat(azurerm_kubernetes_cluster.aks[*].kube_config_raw, [""]), 0) : null
}

output "aks_outbound_pip" {
  value       = var.aks_cluster_create ? element(concat(azurerm_public_ip.outbound.*.ip_address, [""]), 0) : null
}

output "aks_ingress_pip" {
  value       = var.aks_cluster_create ? element(concat(azurerm_public_ip.nginx_ingress.*.ip_address, [""]), 0) : null
}
