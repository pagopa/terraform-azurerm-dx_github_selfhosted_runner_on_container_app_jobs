terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.86.0, <= 3.100.0"
    }
  }
}

module "container_app_job_selfhosted_runner" {
  source = "github.com/pagopa/terraform-azurerm-v3//container_app_job_gh_runner?ref=v8.4.0"

  location  = data.azurerm_container_app_environment.runner.location
  prefix    = var.prefix
  env_short = var.env_short

  key_vault = {
    resource_group_name = data.azurerm_key_vault.kv.resource_group_name
    name                = data.azurerm_key_vault.kv.name
    secret_name         = var.key_vault_secret_name
  }

  environment = {
    name                = data.azurerm_container_app_environment.runner.name
    resource_group_name = data.azurerm_container_app_environment.runner.resource_group_name
  }

  job = {
    name = replace(replace(var.repo_name, "${var.prefix}-", ""), "${var.env_short}-", "")
    repo = var.repo_name
  }

  tags = var.tags
}