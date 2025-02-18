terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.52.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.2"
    }
  }
}