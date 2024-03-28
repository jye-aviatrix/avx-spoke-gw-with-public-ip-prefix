# Create Resource Group
resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.region
}

# Create Public IP Prefix
resource "azurerm_public_ip_prefix" "this" {
  name                = "${var.public_ip_name}-prefix"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  prefix_length = 30
}


# Create Public IP using the existing Public IP Prefix pool
resource "azurerm_public_ip" "pip1" {
  name                = "${var.public_ip_name}-1"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = "Static"
  public_ip_prefix_id = azurerm_public_ip_prefix.this.id  # Comment this line out to have an individual Public IP created that's not part of the Public IP Prefix pool.
  sku                 = "Standard"
  sku_tier            = "Regional"
}

module "mc-spoke" {
  source                        = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version                       = "1.6.8"
  cloud                         = "Azure"
  name                          = var.avx_spoke_name
  region                        = var.region
  cidr                          = var.avx_spoke_cidr
  account                       = var.avx_account_name
  attached                      = false
  azure_eip_name_resource_group = "${azurerm_public_ip.pip1.name}:${azurerm_public_ip.pip1.resource_group_name}"
  eip                           = azurerm_public_ip.pip1.ip_address
  resource_group                = azurerm_resource_group.this.name
  ha_gw                         = false
  allocate_new_eip              = false
}
