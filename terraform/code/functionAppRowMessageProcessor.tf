resource "azurerm_linux_function_app" "vcatsm-func-mp" {
  name                          = "fa-vca-app-tsm-mp-${var.environment}-01"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  service_plan_id               = data.azurerm_app_service_plan.shared_asp.id
  storage_account_name          = data.azurerm_storage_account.fadependency_sa.name
  storage_account_access_key    = data.azurerm_storage_account.fadependency_sa.primary_access_key
  virtual_network_subnet_id     = data.azurerm_subnet.asp_shrd_vnetint_subnet.id
  public_network_access_enabled = false
  functions_extension_version   = "~4"
  https_only                    = true
  tags                          = module.tags.keyvalues
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.vcatsm-ai-mp.instrumentation_key
    "CmsBaseUri"                     = "${var.cms_uri}/CMS.24.0.01"
    "CmsModernBaseUri"               = var.cms_uri
    "FUNCTIONS_EXTENSION_VERSION"    = "~4"
    "FUNCTIONS_WORKER_RUNTIME"       = "dotnet-isolated"
    "CronExpression"                 = var.schedule
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "false"
    "CmsUsername"                    = "@Microsoft.KeyVault(SecretUri=https://kv-cmd-${var.subscription}-01.vault.azure.net/secrets/cms-username/)"
    "CmsPassword"                    = "@Microsoft.KeyVault(SecretUri=https://kv-cmd-${var.subscription}-01.vault.azure.net/secrets/cms-password/)"
  }
  connection_string {
    name  = "DpDatabase"
    type  = "PostgreSQL"
    value = "Host=psql-cmd-${var.environment}-01.postgres.database.azure.com;Database=case_management_datastore_temp;Username=fa-vca-app-tsm-${var.environment}-01"
  }

  site_config {

    application_stack {
      dotnet_version              = "8.0"
      use_dotnet_isolated_runtime = true
    }

    cors {
      allowed_origins = [
        "https://portal.azure.com",
      ]
      support_credentials = false
    }

    scm_use_main_ip_restriction = true

  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}

resource "azurerm_private_endpoint" "func-pe-mp" {
  name                = "pe-fa-vca-app-tsm-mp-${var.environment}-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.asp_shrd_pe_subnet.id
  tags                = module.tags.keyvalues

  private_service_connection {
    name                           = "psc-fa-vca-app-tsm-mp-${var.environment}-01"
    private_connection_resource_id = azurerm_linux_function_app.vcatsm-func-mp.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }

  custom_network_interface_name = "nic-pe-fa-vca-app-tsm-mp-${var.environment}-01"

  depends_on = [azurerm_linux_function_app.vcatsm-func-mp]
}
