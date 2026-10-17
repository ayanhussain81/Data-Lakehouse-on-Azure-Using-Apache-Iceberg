# -------------------------
# RESOURCE GROUP
# -------------------------
data "azurerm_resource_group" "rg" {
  name = "<Resource-group-name>"
}


#####################################
# Azure Blob Storage Account
#####################################
resource "azurerm_storage_account" "blob" {
  name                     = "blobicebergstorage"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Blob storage type
  account_kind              = "StorageV2"

  blob_properties {
    delete_retention_policy {
      days = 1
    }
    container_delete_retention_policy {
      days = 1
    }
  }
}

#####################################
# Azure Blob Storage Container
#####################################
resource "azurerm_storage_container" "blob_container" {
  name                 = "icebergblobcontainer"
  storage_account_id   = azurerm_storage_account.blob.id
  container_access_type = "private"
}


#####################################
#Azure ADLS Gen2 Storage Account
#####################################
resource "azurerm_storage_account" "adls" {
  name                     = "icebergstorageaccountnew"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  # Enable Data Lake Gen2 (Data Lake namespace)
  is_hns_enabled = true 

  blob_properties {
    versioning_enabled = false
  }

  share_properties {}
}

#####################################
# Azure Data Lake Storage Container 
#####################################
resource "azurerm_storage_container" "input" {
  name                 = "icebergdatalakecontainer"
  storage_account_id   = azurerm_storage_account.adls.id
  container_access_type = "private"
}


#########################################################
# DATABRICKS WORKSPACE
#########################################################
resource "azurerm_databricks_workspace" "databricks" {
  name                = "iceberg-databricks-new"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  sku = "standard"     # UI default (used for jobs, clusters, ML, notebooks)
  managed_resource_group_name = "${data.azurerm_resource_group.rg.name}-dbworkspace-rg"
}

