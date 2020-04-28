provider "azurerm" {
  version = "1.41.0"
}

resource "azurerm_resource_group" "aksdemo" {
  name     = "rg-demo-${var.environment}"
  location = var.location
    
  tags = {
    Environment = "${var.environment}"
    Product = "demo-${var.environment}"
  }
}

resource "azurerm_kubernetes_cluster" "aksdemo" {
  name                = "aks-demo-${var.environment}"
  location            = azurerm_resource_group.aksdemo.location
  resource_group_name = azurerm_resource_group.aksdemo.name
  dns_prefix          = "aks-demo-dns-${var.environment}"

  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_DS11_v2"
  }

  service_principal {
    client_id     = var.kubernetes_client_id
    client_secret = var.kubernetes_client_secret
  }

  tags = {
    Environment = "${var.environment}"
    Product = "demo-${var.environment}"
  }

}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.aksdemo.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aksdemo.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aksdemo.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aksdemo.kube_config.0.cluster_ca_certificate)
}

