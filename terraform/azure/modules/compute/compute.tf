#Load Balancer

resource "azurerm_public_ip" "lb-renan" {
    name                = "lb-renan"
    location            = var.rglocation
    resource_group_name = var.rgname
    allocation_method   = "Static"
    domain_name_label   = "lb-renan"
}

resource "azurerm_lb" "lb" {
    name                = "lb"
    location            = var.rglocation
    resource_group_name = var.rgname
    frontend_ip_configuration {
        name                 = "lb"
        public_ip_address_id = azurerm_public_ip.lb-renan.id
    }
}

resource "azurerm_lb_backend_address_pool" "lb" {
    name            = "lb"
    loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_lb_rule" "lb" {
    name                           = "HTTP"
    loadbalancer_id                = azurerm_lb.lb.id
    protocol                       = "Tcp"
    frontend_port                  = 80
    backend_port                   = 80
    frontend_ip_configuration_name = "lb"
    backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb.id]
}

#vm1 publica

resource "azurerm_public_ip" "vm01_pip_public" {
    name                = "vm01-pip-public"
    location            = var.rglocation
  resource_group_name = var.rgname
    allocation_method   = "Static"
    domain_name_label   = "vm01-pip-public1a"
}

resource "azurerm_network_interface" "vm01_nic_public1a" {
    name                = "vm01-nic-public"
    location            = var.rglocation
  resource_group_name = var.rgname
    ip_configuration {
        name                          = "vm01-ipconfig-public1a"
        subnet_id                     = var.snvnetapub1a
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.vm01_pip_public.id
    }
}

resource "azurerm_virtual_machine" "vm01_public" {
    name                          = "vm01-public"
    location            = var.rglocation
  resource_group_name = var.rgname
    network_interface_ids         = [azurerm_network_interface.vm01_nic_public1a.id]
    vm_size                       = "Standard_E2s_v3"
    delete_os_disk_on_termination = true
    storage_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
    }
    storage_os_disk {
        name              = "vm01-os-disk-public"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name  = "vm01-public"
        admin_username = "azureuser"
        admin_password = "Password1234!" 
        custom_data    = <<-EOF
         #!/bin/bash
            sudo apt-get update
            sudo apt-get install -y python3 python3-pip
            pip3 install flask
             cat << 'EOF2' > /home/ubuntu/app.py
            from flask import Flask
             app = Flask(__name__)
             @app.route('/')
             def home():
            return "Hello, Azure from Flask!"
             if __name__ == '__main__':
          app.run(host='0.0.0.0', port=5000)
          EOF2
          nohup python3 /home/ubuntu/app.py &
        EOF 
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
}

#vm2 publica

resource "azurerm_public_ip" "vm02_pip_public" {
    name                = "vm02-pip-public"
    location            = var.rglocation
  resource_group_name = var.rgname
    allocation_method   = "Static"
    domain_name_label   = "vm02-pip-public"
}

resource "azurerm_network_interface" "vm02_nic_public" {
    name                = "vm02-nic-public"
    location            = var.rglocation
  resource_group_name = var.rgname
    ip_configuration {
        name                          = "vm02-ipconfig-public"
        subnet_id                     = var.snvnetapub1a
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.vm02_pip_public.id
    }
}

resource "azurerm_virtual_machine" "vm02_public" {
    name                          = "vm02-public"
    location            = var.rglocation
  resource_group_name = var.rgname
    network_interface_ids         = [azurerm_network_interface.vm02_nic_public.id]
    vm_size                       = "Standard_E2s_v3"
    delete_os_disk_on_termination = true
    storage_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
    }
    storage_os_disk {
        name              = "vm02-os-disk-public"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name  = "vm02-public"
        admin_username = "azureuser"
        admin_password = "Password1234!"
        custom_data    = <<-EOF
         #!/bin/bash
            sudo apt-get update
            sudo apt-get install -y python3 python3-pip
            pip3 install flask
             cat << 'EOF2' > /home/ubuntu/app.py
            from flask import Flask
             app = Flask(__name__)
             @app.route('/')
             def home():
            return "Hello, Azure from Flask!"
             if __name__ == '__main__':
          app.run(host='0.0.0.0', port=5000)
          EOF2
          nohup python3 /home/ubuntu/app.py &
        EOF
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
}

#vm03 publica

resource "azurerm_public_ip" "vm03_pip_public" {
    name                = "vm03-pip-public"
    location            = var.rglocation
  resource_group_name = var.rgname
    allocation_method   = "Static"
    domain_name_label   = "vm03-pip-public1a"
}

resource "azurerm_network_interface" "vm03_nic_public1a" {
    name                = "vm03-nic-public"
    location            = var.rglocation
  resource_group_name = var.rgname
    ip_configuration {
        name                          = "vm03-ipconfig-public1a"
        subnet_id                     = var.snvnetapub1b
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.vm03_pip_public.id
    }
}

resource "azurerm_virtual_machine" "vm03_public" {
    name                          = "vm03-public"
    location            = var.rglocation
  resource_group_name = var.rgname
    network_interface_ids         = [azurerm_network_interface.vm03_nic_public1a.id]
    vm_size                       = "Standard_E2s_v3"
    delete_os_disk_on_termination = true
    storage_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
    }
    storage_os_disk {
        name              = "vm03-os-disk-public"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name  = "vm03-public"
        admin_username = "azureuser"
        admin_password = "Password1234!" 
        custom_data    = <<-EOF
         #!/bin/bash
            sudo apt-get update
            sudo apt-get install -y python3 python3-pip
            pip3 install flask
             cat << 'EOF2' > /home/ubuntu/app.py
            from flask import Flask
             app = Flask(__name__)
             @app.route('/')
             def home():
            return "Hello, Azure from Flask!"
             if __name__ == '__main__':
          app.run(host='0.0.0.0', port=5000)
          EOF2
          nohup python3 /home/ubuntu/app.py &
        EOF 
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
}

#vm04 publica

resource "azurerm_public_ip" "vm04_pip_public" {
    name                = "vm04-pip-public"
    location            = var.rglocation
  resource_group_name = var.rgname
    allocation_method   = "Static"
    domain_name_label   = "vm03-pip-public1a"
}

resource "azurerm_network_interface" "vm04_nic_public1a" {
    name                = "vm04-nic-public"
    location            = var.rglocation
  resource_group_name = var.rgname
    ip_configuration {
        name                          = "vm04-ipconfig-public1a"
        subnet_id                     = var.snvnetapub1b
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.vm04_pip_public.id
    }
}

resource "azurerm_virtual_machine" "vm04_public" {
    name                          = "vm04-public"
    location            = var.rglocation
  resource_group_name = var.rgname
    network_interface_ids         = [azurerm_network_interface.vm04_nic_public1a.id]
    vm_size                       = "Standard_E2s_v3"
    delete_os_disk_on_termination = true
    storage_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
    }
    storage_os_disk {
        name              = "vm04-os-disk-public"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name  = "vm04-public"
        admin_username = "azureuser"
        admin_password = "Password1234!" 
        custom_data    = <<-EOF
         #!/bin/bash
            sudo apt-get update
            sudo apt-get install -y python3 python3-pip
            pip3 install flask
             cat << 'EOF2' > /home/ubuntu/app.py
            from flask import Flask
             app = Flask(__name__)
             @app.route('/')
             def home():
            return "Hello, Azure from Flask!"
             if __name__ == '__main__':
          app.run(host='0.0.0.0', port=5000)
          EOF2
          nohup python3 /home/ubuntu/app.py &
        EOF 
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
}

#lb association

resource "azurerm_network_interface_backend_address_pool_association" "vm01" {
    ip_configuration_name   = "vm01-pip-public"
    network_interface_id    = azurerm_network_interface.vm01_nic_public1a.id
    backend_address_pool_id = azurerm_lb_backend_address_pool.lb.id
}

resource "azurerm_network_interface_backend_address_pool_association" "vm02" {
    ip_configuration_name   = "vm02-pip-public"
    network_interface_id    = azurerm_network_interface.vm02_nic_public.id
    backend_address_pool_id = azurerm_lb_backend_address_pool.lb.id
}

resource "azurerm_network_interface_backend_address_pool_association" "vm03" {
    ip_configuration_name   = "vm03_pip_public"
    network_interface_id    = azurerm_network_interface.vm03_nic_public1a.id
    backend_address_pool_id = azurerm_lb_backend_address_pool.lb.id
}

resource "azurerm_network_interface_backend_address_pool_association" "vm04" {
    ip_configuration_name   = "vm04_pip_public"
    network_interface_id    = azurerm_network_interface.vm04_nic_public1a.id
    backend_address_pool_id = azurerm_lb_backend_address_pool.lb.id
}








