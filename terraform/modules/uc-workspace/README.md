# UC Workspace Module
This module is intended to create an Azure Databricks Workspace which has
been enabled with Unity Catalog.

## Variables

1. prefix - the prefix for artifacts, Default "data.databricks_current_user.me.alphanumeric", trimmed to 8 characters
2. region - the Azure Region to create artifacts, Default "Australia East"
3. owner-username - the Owner for the Databricks Workspace

## Build Artifacts

1. An Azure Resource Group titled "${prefix}-nlp-audio"

## Prerequisites
You will need to ensure that you have run "az login" with an account which
is a Unity Catalog "Account Admin".