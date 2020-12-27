variable ID {}
variable PASSWORD {}


provider "azurerm" {
    features {}
  subscription_id = var.ID ### DO NOT PUSH
}

##################
# Windows VM #
##################

resource "azurerm_resource_group" "windows-resource-group" {
  name     = "windows-resources"
  location = "centralus"
}

output "id" {
  value = "${azurerm_resource_group.windows-resource-group.id}"
}

resource "azurerm_virtual_network" "windows-virtual-network" {
  name                = "virtual-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.windows-resource-group.location}"
  resource_group_name = "${azurerm_resource_group.windows-resource-group.name}"
}

resource "azurerm_subnet" "subnet" {
  name                 = "internal_subnet"
  resource_group_name  = "${azurerm_resource_group.windows-resource-group.name}"
  virtual_network_name = "${azurerm_virtual_network.windows-virtual-network.name}"
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "network-interface" {
  name                = "example-nic"
  location            = "${azurerm_resource_group.windows-resource-group.location}"
  resource_group_name = "${azurerm_resource_group.windows-resource-group.name}"

  ip_configuration {
    name                          = "internal_subnet"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.public_ip.id}"
  }
}

resource "azurerm_public_ip" "public_ip" {
  name                    = "test-pip"
  location                = "${azurerm_resource_group.windows-resource-group.location}"
  resource_group_name     = "${azurerm_resource_group.windows-resource-group.name}"
  allocation_method       = "Dynamic"
  #idle_timeout_in_minutes = 30
}

resource "azurerm_windows_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = "${azurerm_resource_group.windows-resource-group.name}"
  location            = "${azurerm_resource_group.windows-resource-group.location}"
  size                = "Standard_B1s"
  admin_username      = "mhuang"
  admin_password      = var.PASSWORD
  network_interface_ids = [
    "${azurerm_network_interface.network-interface.id}",
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    #disk_size_gb         = "64"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
