# API Covia

Api del sistema Covia

# dev
1. Configurar las variables de entorno en caso de ser necesario
2. Ejecutar el comando ```npm install```
3. Ejecutar ```docker compose up -d``` para levantar la imagen de la bd
4. Ejecutar ```npx prisma migrate dev --name init``` para inicializar las migraciones
5. Las migraciones se encuentran en la carpeta "prima" y la base de datos postgres en la carpeta postgres,
   la cual se generará depues de correr la imagen de docker del punto 3

