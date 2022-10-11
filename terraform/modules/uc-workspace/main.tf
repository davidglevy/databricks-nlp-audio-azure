terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 3.16"
    }
    azapi = {
      source = "azure/azapi"
    }
    databricks = {
      source = "databricks/databricks"
      version = ">= 1.5.0"
    }
    time = {
      source = "hashicorp/time"
    }

  }
}

locals {
  storage-prefix = replace(var.prefix, "-", "0")
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "base" {
  name     = var.prefix
  location = var.region
}

resource "azapi_resource" "access_connector" {
  type      = "Microsoft.Databricks/accessConnectors@2022-04-01-preview"
  name      = var.prefix
  location  = azurerm_resource_group.base.location
  parent_id = azurerm_resource_group.base.id
  identity {
    type = "SystemAssigned"
  }
  body = jsonencode({
    properties = {}
  })
}

resource "azurerm_storage_account" "unity_catalog" {
  name                     = "${local.storage-prefix}0storage"
  resource_group_name      = azurerm_resource_group.base.name
  location                 = azurerm_resource_group.base.location
  tags                     = azurerm_resource_group.base.tags
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
}

resource "azurerm_storage_container" "unity_catalog" {
  name                  = "metastore"
  storage_account_name  = azurerm_storage_account.unity_catalog.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "landing" {
  name                  = "landing"
  storage_account_name  = azurerm_storage_account.unity_catalog.name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "uc-role-storage" {
  scope                = azurerm_storage_account.unity_catalog.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azapi_resource.access_connector.identity[0].principal_id
}

resource "azurerm_databricks_workspace" "workspace" {
  name                = var.prefix
  resource_group_name = azurerm_resource_group.base.name
  location            = azurerm_resource_group.base.location
  sku                 = "premium"
  custom_parameters {
    storage_account_sku_name = "Standard_LRS"
  }


  tags = {
    Owner = var.owner-username
  }
}

provider "databricks" {
  host = "https://${azurerm_databricks_workspace.workspace.workspace_url}/"
}

resource "databricks_metastore" "this" {
  name = var.prefix
  storage_root = format("abfss://%s@%s.dfs.core.windows.net/",
    azurerm_storage_container.unity_catalog.name,
  azurerm_storage_account.unity_catalog.name)
  force_destroy = true
}

resource "databricks_metastore_data_access" "first" {
  metastore_id = databricks_metastore.this.id
  name         = "${var.prefix}-mi-meta"
  azure_managed_identity {
    access_connector_id = azapi_resource.access_connector.id
  }
  is_default = true
}

resource "databricks_metastore_assignment" "this" {
  workspace_id         = azurerm_databricks_workspace.workspace.workspace_id
  metastore_id         = databricks_metastore.this.id
  default_catalog_name = "hive_metastore"
}




