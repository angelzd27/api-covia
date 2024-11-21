# APIRest COVIA

API de integración de servicios Back-End para la plataforma COVIA. Este sistema proporciona acceso a diversas funcionalidades clave para soportar la operación de la plataforma, incluyendo la gestión de usuarios, datos y comunicación entre módulos.
# Requisitos Previos

Para poder ejecutar el proyecto es necesario contar con los siguientes requisitos:

- Node.js (Version 14 o superior).
- Base de datos
- Variables de entorno: `POSTGRES_URL` `POSTGRES_USER` `POSTGRES_DB` `POSTGRES_PASSWORD`
# Instalación

## Clonar proyecto

```
git clone https://github.com/angelzd27/api-covia.git
```

```
cd api-covia
```

## Instalar dependencias

```
npm install
```

## Ejecutar los siguientes comandos para la base de datos

Para levantar la imagen de la Base de Datos hecha en PostgreSQL.

```
docker compose up -d
```

Ejecutar el siguiente comando para iniciar las migraciones.
Las migraciones se encuentran en la carpeta "prima" y la base de datos PostgreSQL, la cual se genera después de correr la imagen de Docker del puerto 3.

```
npx prisma migrate dev --name init
```

## Ejecutar el projecto usando Nodemon

```
npx nodemon index.js
```
# Authors

- [@Jesus Eduardo Ramirez Navarro](https://github.com/decidesuici)
- [@Angel Antonio Zapatero Díaz](https://github.com/angelzd27)
- [@Maximiliano Vigueras Tovar](https://github.com/max-vigtov)
