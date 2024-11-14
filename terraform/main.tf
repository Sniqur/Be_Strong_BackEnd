# Configure the Azure provider
provider "azurerm" {
  features {}
    subscription_id = var.subID #Use your Subscription ID
    
}

variable "subID" {
  type = string
}
# Variables (you can also define these in a variables.tf file)
variable "resource_group_name" {
  default = "BeStrong-RG"
}

variable "location" {
  default = "Sweden Central"
}

variable "acr_name" {
  default = "bestrongregistry"
}

variable "app_service_plan_name" {
  default = "myAppServicePlan"
}

variable "web_app_name" {
  default = "bestorngWebApp"
}

# Create a Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true


  tags = {
    environment = "dev"
  }
}

# Create App Service Plan (Linux)
resource "azurerm_app_service_plan" "asp" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Basic"
    size = "B1"
  }
}

# Create Web App with Container
resource "azurerm_app_service" "web_app" {
  name                = var.web_app_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.asp.id

  site_config {
    linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/my-image:latest"
  }


  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL"      = "https://${var.acr_name}.azurecr.io"
    "DOCKER_REGISTRY_SERVER_USERNAME" = azurerm_container_registry.acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = azurerm_container_registry.acr.admin_password
  }
  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "dev"
  }
}

# Assign ACR Pull Role to the Web App
resource "azurerm_role_assignment" "acr_pull" {
  principal_id         = azurerm_app_service.web_app.identity[0].principal_id
  role_definition_name = "AcrPull"
  scope          = azurerm_container_registry.acr.id
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "web_app_url" {
  value = azurerm_app_service.web_app.default_site_hostname
}
