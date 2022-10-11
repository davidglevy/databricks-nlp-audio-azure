terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 3.16"
    }
    databricks = {
      source = "databricks/databricks"
      version = ">= 1.5.0"
    }
  }
}
provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

provider "databricks" {
  host = "${var.workspace_url}/"

}

resource databricks_dbfs_file audio_init_script {
  source = "${path.module}/audio_init_script.sh"
  path   = "/scripts/audio_init_script.sh"
}

data databricks_spark_version latest_lts {
  //long_term_support = true
  depends_on = [data.azurerm_client_config.current]
}

resource "databricks_cluster" "shared_autoscaling" {
  cluster_name = "Audio Cluster"
  spark_version = data.databricks_spark_version.latest_lts.id
  node_type_id = "Standard_D8ds_v4"
  data_security_mode = "SINGLE_USER"
  single_user_name = var.main_username
  autotermination_minutes = 60
  depends_on = [ databricks_dbfs_file.audio_init_script ]

  // Add libraries
  // TODO Make Wheel from deps
  library {
    pypi {
      package = "pydub"
    }

  }
  library {
    pypi {
      package = "azure-cognitiveservices-speech"

    }
  }


  // Add init script
  init_scripts {
    dbfs {
      destination = "dbfs:/scripts/audio_init_script.sh"
    }
  }

  // Set number of workers (2)
  num_workers = 2

}

resource "databricks_repo" "nlp-audio-azure" {
  url = "https://github.com/davidglevy/databricks-nlp-audio-azure"
}







