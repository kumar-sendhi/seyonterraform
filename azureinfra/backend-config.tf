terraform {
  backend "azurerm" {
    resource_group_name   = "tstate"
    storage_account_name  = "tstateseyon"
    container_name        = "tstate"
    key                   = "terraform.tfstate"
  }
}

# Configure the Azure provider
provider "azurerm" { 
  # The "feature" block is required for AzureRM provider 2.x. 
  # If you are using version 1.x, the "features" block is not allowed.
  version = "~>2.0"
  features {}
}

resource "azurerm_resource_group" "state-demo-secure" {
  name     = "state-demo"
  location = "southindia"
}


resource "azurerm_app_service_plan" "slotDemo" {
    name                = "seyonslotAppServicePlan"
    location            = azurerm_resource_group.state-demo-secure.location
    resource_group_name = azurerm_resource_group.state-demo-secure.name
    sku {
        tier = "Standard"
        size = "S1"
    }
}

resource "azurerm_app_service" "slotDemo" {
    name                = "seyonslotAppService"
    location            = azurerm_resource_group.state-demo-secure.location
    resource_group_name = azurerm_resource_group.state-demo-secure.name
    app_service_plan_id = azurerm_app_service_plan.slotDemo.id
}

resource "azurerm_app_service_slot" "slotDemo" {
    name                = "seyonslotAppServiceSlotOne"
    location            = azurerm_resource_group.state-demo-secure.location
    resource_group_name = azurerm_resource_group.state-demo-secure.name
    app_service_plan_id = azurerm_app_service_plan.slotDemo.id
    app_service_name    = azurerm_app_service.slotDemo.name
}