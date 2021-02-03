variable "region" {
  type    = string
  default = "us-east-1"
}

variable "ec2_image_id" {
  type = string
  # Ubuntu 18.04 LTS amd64 bionic | us-east-1
  default = "ami-007e8beb808004fdc"
}

variable "ec2_key_name" {
  type    = string
  default = "draks@loki.local"
}

variable "ec2_key_filename" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "my_ip_addresses" {
  description = "My allowed IP addresses"
  type        = list(string)
  default     = ["0.0.0.0/0"] # example: 198.51.1.1/32
}

variable "zabbix_access_allowed_ip_addresses" {
  description = "The IP addressess that are allowed to access my Zabbix service interface"
  type        = list(string)
  default     = ["0.0.0.0/0"] # example: 0.0.0.0/0
}

variable "zabbix_service_allowed_ip_addresses" {
  description = "The IP addressess that are allowed to send data to my Zabbix service"
  type        = list(string)
  default     = ["0.0.0.0/0"] # example: 0.0.0.0/0
}
