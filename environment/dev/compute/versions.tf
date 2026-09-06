terraform {
  required_version = ">= 1.8.0"

  # Remote backend example:
  # terraform init -backend-config=../../../backend/dev.hcl -backend-config="key=dev/compute/terraform.tfstate"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {
    virtual_machine {
      delete_os_disk_on_deletion = true
    }
  }
}
