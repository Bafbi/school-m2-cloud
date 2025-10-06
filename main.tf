terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "ef8409c2-0ac2-4662-98c6-dacf434af502"
}

resource "azurerm_resource_group" "cours-cloud" {
  name     = "cours-cloud"
  location = " uksouth"
}

resource "azurerm_storage_account" "cours-cloud" {
  name                     = "courscloudsa"
  resource_group_name      = azurerm_resource_group.cours-cloud.name
  location                 = azurerm_resource_group.cours-cloud.location
  account_kind             = "BlobStorage"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
}

resource "azurerm_storage_container" "cours-cloud" {
  name                  = "courscloudcontainer"
  storage_account_id    = azurerm_storage_account.cours-cloud.id
  container_access_type = "private"
}

resource "azurerm_resource_group_cost_management_export" "cours-cloud" {
  name                = "cours-cloud-export"
  resource_group_id   = azurerm_resource_group.cours-cloud.id
  recurrence_type     = "Monthly"
  recurrence_period_start_date = "2025-01-01T00:00:00Z"
  recurrence_period_end_date   = "2025-12-31T00:00:00Z"

  export_data_storage_location {
    container_id     = azurerm_storage_container.cours-cloud.id
    root_folder_path = "/root/updated"
  }

  export_data_options {
    type       = "Usage"
    time_frame = "WeekToDate"
  }
  
}