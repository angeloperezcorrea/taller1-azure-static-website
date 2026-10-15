variable "location" {
  type        = string
  default     = "eastus"
  description = "Región de Azure donde se desplegarán los recursos"
}

variable "resource_group_name" {
  type        = string
  default     = "rg-sitio-estatico-prod"
  description = "Nombre del grupo de recursos"
}

variable "storage_account_name" {
  type        = string
  default     = "mystaticwebstorage2026" # Debe ser un nombre único globalmente en Azure
  description = "Nombre de la cuenta de almacenamiento (letras minúsculas y números)"
}