resource "azurerm_resource_group" "rg" {
  name     = "rg-vca-app-tsm-${var.environment}-01"
  location = var.location
  tags     = module.tags.keyvalues
}
