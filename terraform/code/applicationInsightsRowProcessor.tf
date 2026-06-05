resource "azurerm_application_insights" "vcatsm-ai-rp" {
  name                = "ai-vca-app-tsm-rp-${var.environment}-01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  workspace_id        = data.azurerm_log_analytics_workspace.law.id
  application_type    = "web"
  tags                = module.tags.keyvalues
}

output "instrumentation_key_rp" {
  value     = azurerm_application_insights.vcatsm-ai-rp.instrumentation_key
  sensitive = true
}