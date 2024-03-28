variable "resource_group_name" {
  default = "public-ip"
}

variable "region" {
  default = "East US"
}

variable "public_ip_name" {
  default = "public-ip"
}

variable "avx_account_name" {
  description = "Provide Aviatrix Access Account name"
}

variable "avx_spoke_name" {
  default = "eu1spoke1"
}

variable "avx_spoke_cidr" {
  default = "10.100.0.0/24"
}