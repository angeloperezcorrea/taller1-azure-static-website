# Informe de Parcial: Despliegue Automatizado de Sitio Web Estático en Azure con Terraform
- **Equipo de Trabajo:** RompeCodigo
---

## 1. Enlaces del Proyecto
- **URL del Repositorio en GitHub:** [https://github.com/angeloperezcorrea/taller1-azure-static-website](https://github.com/angeloperezcorrea/taller1-azure-static-website)
- **URL Pública de la Aplicación :** `https://mystaticwebstorage2026.z13.web.core.windows.net/`

---

## 2. Resumen y Enfoque del Parcial
Para resolver este parcial, nuestro objetivo principal fue aplicar los principios de **Infraestructura como Código (IaC)** utilizando **Terraform** para aprovisionar un entorno web altamente disponible y seguro en Microsoft Azure, respaldado por una estructura de control de versiones y automatización en **GitHub Actions**. 

A lo largo del desarrollo nos enfrentamos a retos reales de privilegios en la nube institucional que resolvimos mediante una estrategia híbrida y robusta, la cual documentamos a continuación.

---

## 3. Arquitectura de la Solución
Diseñamos una arquitectura limpia basada en servicios nativos de Azure bajo una suscripción *Azure for Students*:
* **Grupo de Recursos (`rg-sitio-estatico-prod`):** Contenedor lógico etiquetado bajo buenas prácticas de gobernanza (`environment = production`, `project = Taller1-AzureStatic`, `team = RompeCodigo`).
* **Cuenta de Almacenamiento (`mystaticwebstorage2026`):** Configurada como `StorageV2` con nivel Standard y redundancia local (`LRS`). Habilitamos explícitamente la propiedad nativa `static_website` para servir el contenido del sitio web directamente desde el almacenamiento de blobs sin necesidad de servidores web tradicionales (ahorrando costos y complejidad).

---

## 4. Código de Infraestructura (Terraform)
Definimos nuestros recursos de manera declarativa en el archivo `main.tf` ubicado en la carpeta del proyecto, garantizando que el despliegue sea totalmente reproducible e idempotente:

```
hcl
resource "azurerm_resource_group" "rg" {
  name     = "rg-sitio-estatico-prod"
  location = "eastus"
  tags = {
    environment = "production"
    project     = "Taller1-AzureStatic"
    team        = "RompeCodigo"
  }
}

resource "azurerm_storage_account" "sa" {
  name                     = "mystaticwebstorage2026"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }
}
```
## 5. Automatización y Workflows (GitHub Actions)
Estructuramos nuestro repositorio con un pipeline de CI/CD ubicado en .github/workflows/deploy.yml. Este flujo se encarga de validar la sintaxis, inicializar el proveedor y asegurar la calidad del código de Terraform ante cada cambio:
```
name: CI/CD Azure Static Website

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  terraform-validate:
    name: Terraform Validate & Plan
    runs-on: ubuntu-latest

    steps:
    - name: Checkout Repository
      uses: actions/checkout@v4

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v3

    - name: Terraform Init
      run: terraform init
      working-directory: ./terraform

    - name: Terraform Validate
      run: terraform validate
      working-directory: ./terraform
 ```

## 6. Paso a Paso de la Ejecución del Parcial

## Paso 1 Inicialización del directorio de Terraform

* Nos ubicamos en la carpeta del proyecto y cargamos los plugins del proveedor de Azure
 ```
terraform init
 ```

 ## Paso 2 Autenticación Interactiva Segura

* Debido a las políticas de seguridad del directorio institucional en la cuenta Azure for Students de la Universidad Tecnológica de Bolívar, realizamos una autenticación por dispositivo en la CLI:
  
```
  az login --use-device-code
  Seleccionamos la suscripción activa Azure for Students (ID: 11d7bb03-aa71-47c1-b8d4-34bd877fb3a2).
 ```

 ## Paso 3: Validación y Planificación

 * Corrimos el plan para verificar que Terraform interpretara correctamente la creación de los 2 recursos principales:
```
  terraform plan
  Resultados Plan: 2 to add, 0 to change, 0 to destroy
  ```
  ## Paso 4: Despliegue de la Infraestructura

  * Aprobamos la ejecución escribiendo yes en la terminal para aprovisionar los recursos en Azure:
  
  ```
  terraform apply
  
azurerm_resource_group.rg: Creating...
azurerm_resource_group.rg: Creation complete after 14s
azurerm_storage_account.sa: Creating...
azurerm_storage_account.sa: Creation complete after 1m10s

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:
primary_web_endpoint = "[https://mystaticwebstorage2026.z13.web.core.windows.net/](https://mystaticwebstorage2026.z13.web.core.windows.net/)"

```

## Cargar el Contenido WEB

  * Una vez creada la cuenta de almacenamiento, subimos el archivo index.html institucional directamente al contenedor $web habilitado por Terraform en Azure, logrando que el sitio web respondiera de inmediato de forma pública.


## Evidencia:

Terraform apply

<img width="1151" height="680" alt="image" src="https://github.com/user-attachments/assets/d9d50b3a-bf46-4a79-9817-ba087cb42a7a" />
<img width="1151" height="680" alt="image" src="https://github.com/user-attachments/assets/52d70b2f-1e4f-45b7-a1f7-f9de86a0619e" />
<img width="745" height="695" alt="image" src="https://github.com/user-attachments/assets/0272b1df-74ec-4195-af63-e77e13c25ea4" />
<img width="1341" height="668" alt="image" src="https://github.com/user-attachments/assets/af3fb4f8-870c-4a86-8f11-46815c859424" />



* Evidencia del portal de Azure
<img width="1359" height="651" alt="image" src="https://github.com/user-attachments/assets/e54673c7-84e3-490f-a584-158d23673293" />
<img width="1353" height="639" alt="image" src="https://github.com/user-attachments/assets/c93cc130-1d52-44f0-a5b6-73f1ab04216a" />


* Evidencia del Contenedor Web en el portal AZURE
  
<img width="1365" height="640" alt="image" src="https://github.com/user-attachments/assets/fa215f2d-27e4-4298-bc9b-4e1bec6d3393" />


* Evidencia del Sitio Web en Vivo

<img width="1351" height="671" alt="image" src="https://github.com/user-attachments/assets/77a74fde-00a4-4175-a2e4-a5512a090062" />

