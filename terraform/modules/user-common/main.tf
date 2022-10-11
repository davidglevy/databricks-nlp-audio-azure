terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 3.16"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = ">= 2.29.0"
    }
  }
}

provider "azurerm" {
   features {}
}

data "azurerm_client_config" "current" {}

data azuread_user current_user {
  object_id = data.azurerm_client_config.current.object_id
}

locals {
  username = data.azuread_user.current_user.user_principal_name
  safe-username = substr(replace(regex("^[^@]+","${local.username}"),"/\\W/", "-"), 0, 8)
  prefix = var.prefix == "" ? format("%s%s", local.safe-username, "-nlp-audio") : var.prefix
}