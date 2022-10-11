# Common User and Prefixes

This module creates common username elements which are used both for Azure services
as well as Databricks artifacts within the workspace.

## Prerequisites
Run "az login" and ensure you have selected the appropriate Directory.

## Variables

prefix
: If this is specified, it overrides any username generated prefixes created 
for artifacts within Azure and Databricks.

## Outputs
This task produces the following outputs which are used by other portions of the
Terraform.

* **username** - the users username e.g. dave.levy@databricks.com
* **safe-username** - the username which has been truncated and non-alphanumeric characters converted to hyphens e.g. dave-l
* **prefix** - A safe prefix used to create Azure and Databricks resources e.g. dave-l-nlp-audio




