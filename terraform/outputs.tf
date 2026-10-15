output "primary_web_endpoint" {
  description = "URL pública del sitio web estático"
  value       = azurerm_storage_account.sa.primary_web_endpoint
}