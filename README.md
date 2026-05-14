# Prueba de integración Multicines

Aplicación web desarrollada como prueba técnica, orientada a la gestión de clientes, con control de acceso basado en roles.

## Funcionalidades principales

### Gestión de usuarios y roles

Autenticación de usuarios
Autorización basada en roles
Control de acceso a funcionalidades

### Gestión del servicio

Crear, editar y eliminar clientes
Crear,  Consultar Venta
Consulta de información detallada

El acceso a endpoints del backend está protegido mediante roles definidos en Spring Security.

## Tecnologías utilizadas

### Backend
Java 17+
Spring Boot
Spring Security
Spring Data JPA
Base de datos
Relacional PostgreSQL

## Instalación

Clonar repositorio
git clone https://github.com/marcelopaal/prueba-integracion-MarceloAlbuja.git
cd Multicines

### Para Windows con Docker Desktop se puede ejecutar los scripts en PowerShell

.\deploy.ps1  -- Para generar el entorno local
                . Creará imagen de la base de datos, deploy y servicio 

.\destroy.ps1 -- Para borrar tanto la bases de datos como las imagenes, pods

### O si se desea ejecutar manualmente

Backend (Spring Boot)
cd backend
mvn spring-boot:run
Frontend (Angular)
cd frontend
npm install
ng serve

Configurar endpoint en environment:

apiUrl: 'http://localhost:8080/api'

Endpoints principales

Ejemplo de endpoints:

POST   /api/auth/login
POST   /api/auth/register
GET    /api/venta
POST   /api/venta

## Notas finales

Este proyecto fue desarrollado como parte de un proceso de evaluación técnica, enfocado en demostrar:

Capacidad de estructurar un sistema real
Implementación de seguridad por roles
Integración backend
Buenas prácticas en desarrollo full stack