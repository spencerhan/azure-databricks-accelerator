resource "azurerm_public_ip" "nat_pip" {
  name                    = var.pip_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  allocation_method       = "Static"
  sku                     = "Standard"
  idle_timeout_in_minutes = var.nat_idle_timeout_in_minutes
  tags                    = var.tags
}

resource "azurerm_nat_gateway" "nat" {
  name                    = var.nat_gateway_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = var.nat_idle_timeout_in_minutes
  tags                    = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "nat_pip_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.nat_pip.id
}

# Attach NAT to BOTH Databricks subnets (host + container) for stable egress
resource "azurerm_subnet_nat_gateway_association" "adb_public_nat" {
  subnet_id      = var.dbx_public_subnet_id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}

resource "azurerm_subnet_nat_gateway_association" "adb_private_nat" {
  subnet_id      = var.dbx_private_subnet_id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}