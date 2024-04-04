
# Datasource to get Latest Azure AKS latest Version
data "azurerm_kubernetes_service_versions" "current" {
  location = var.location
  include_preview = false  
}
 

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                  = "shashikiran-aks-cluster"
  location              = var.location
  resource_group_name   = var.resource_group_name
  dns_prefix            = "${var.resource_group_name}-cluster"           
  kubernetes_version    =  data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${var.resource_group_name}-node-grp"
  
  default_node_pool {
    name       = "defaultpool"
    vm_size    = "Standard_DS2_v2"
    zones   = [1, 2, 3]
    enable_auto_scaling  = true
    max_count            = 3
    min_count            = 1
    os_disk_size_gb      = 30
    type                 = "VirtualMachineScaleSets"
    node_labels = {
      "nodepool-type"    = "system"
      "environment"      = "prod"
      "nodepoolos"       = "linux"
     } 
   tags = {
      "nodepool-type"    = "system"
      "environment"      = "prod"
      "nodepoolos"       = "linux"
   } 
  }

  service_principal  {
    client_id = var.client_id
    client_secret = var.client_secret
  }



  linux_profile {
    admin_username = "ubuntu"
    ssh_key {
        key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9r5NtBrLjfKjihpBejt6iusln8fLzxjV+W7yw8Sju1boJaE9MI9ooOHxifIk3StQNL3UJc0ONSQS9NbDxjzIRpmnwRToV9r7nB2aAU9nxS25RCKhhXbziZhnjMiQsKz5mty6OHC4CrtExWN+hGSNUQt9k6ImhVMO6GGwvBUiLqKXJMlbU7u9BLF21dPsLtu2oK906Ml81JNancluxqXhXn7AJtNkQqDOkfsQ9hkSE6cTLvsOJoKPtDmeAOiJtoYcq1NkNiAhaLCs+f91RVxYbe2r8Fkay8+MvUNkbavyNkjWYWEusfqKDiFMk0Qo+WDaR6CZzBKHgBWshaLRqAaHDeqE146rz8YkQ9lU5ah6nBRnr1QMUOoJg7aFeOSUOGVJ7zWx+qE9dPXJBLA/j6sFTdJXx0Zyt6LdTluXx6u3AJcuZItNGCpOx4tjms+XhR+JXlZF8mjDiq0gvPEJ128xH2UAYlifjZRtj0ufh4BLV3IXLvLsJW1XFS3Oc1eXuaogwXYJVmBnDS+JxowQR1GcJZ+1kf3lSVbuoq1h85PT11fPTIilT+dU6csFIhaWJ2KLq7+zY+no2TjAvH4L+L2SFbWWhzuxbU29+oGPtVKko1ap6+IFbz0q5eQVqFWHIt5XP7gCW28i3v9CyH6hQgQx3o7P7DuPFJowdB8mJBQNXYw== shashikiranaws18@gmail.com"
    }
  }

  network_profile {
      network_plugin = "azure"
      load_balancer_sku = "standard"
  }

    
  }
