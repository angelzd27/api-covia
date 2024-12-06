import express from 'express'
import cors from 'cors'
import net from 'net'
import { router_hikvision } from './routes/hikvision.js'
import { router_ruptela } from './routes/ruptela.js'
import { router_auth } from './routes/auth.js'
import { router_devices } from './routes/devices.js'
import { router_geofences } from './routes/geofences.js'
import { router_drones } from './routes/drones.js'

const app = express()
const PORT = 5000 || 1500
const TCP_PORT = 6000 // Puerto para recibir los datos del GPS

// Cnfiguración de CORS
const corsOptions = {
    origin: 'http://localhost:5173', // Reemplaza con el dominio de tu frontend
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    credentials: true
}

app.use(cors(corsOptions))
app.use(express.json())
app.use('/api/hikvision', router_hikvision)
app.use('/api/ruptela', router_ruptela)
app.use('/api/auth', router_auth)
app.use('/api/devices', router_devices)
app.use('/api/geofences', router_geofences)
app.use('/api/drones', router_drones)

// Servidor TCP para recibir datos del GPS
const tcpServer = net.createServer((socket) => {
    console.log('Conexión TCP establecida con el GPS.')

    socket.on('data', (data) => {
        // Aquí debes procesar los datos recibidos del GPS
        // Puedes decodificar los datos y extraer la latitud y longitud
        // como sea necesario dependiendo del formato de los datos.

        console.log('::::::::::::::::::::::::::::::::::::::')
        // console.log('Datos de GPS recibidos:', data)
        console.log('Datos de GPS recibidos:', data.toString('hex'))
        console.log('::::::::::::::::::::::::::::::::::::::')

        // const parsedData = parseGPSData(data) // Implementa esta función según el protocolo del GPS
        // if (parsedData) {
        //     coordinates = {
        //         latitude: parsedData.latitude,
        //         longitude: parsedData.longitude
        //     }
        //     console.log('Datos de GPS recibidos:', coordinates)
        // }
    })

    socket.on('end', () => {
        console.log('Conexión TCP finalizada.')
    })
})

tcpServer.listen(TCP_PORT, () => {
    console.log(`La marrana TCP esta viva en el puerto ${TCP_PORT} para datos de GPS`)
})

app.listen(PORT, () => {
    console.log(`La marrana HTTP esta viva en el puerto ${PORT}`)
})

// Función para procesar los datos recibidos del GPS en formato binario hexadecimal
export const parseGPSData = (data) => {
    try {
        // Convertir los datos binarios a una cadena hexadecimal
        const hexString = data.toString('hex')

        // Convertir cada par de caracteres hexadecimales a texto legible (ASCII)
        let message = ''
        for (let i = 0; i < hexString.length; i += 2) {
            const hexByte = hexString.slice(i, i + 2)
            const char = String.fromCharCode(parseInt(hexByte, 16))
            message += char
        }

        // Suponiendo que los datos vienen en un formato de texto delimitado como "latitude:12.345,longitude:67.890"
        const dataParts = message.split(',')
        let latitude = null
        let longitude = null

        dataParts.forEach(part => {
            const [key, value] = part.split(':')
            if (key && value) {
                if (key.trim() === 'latitude') {
                    latitude = parseFloat(value)
                } else if (key.trim() === 'longitude') {
                    longitude = parseFloat(value)
                }
            }
        })

        if (latitude !== null && longitude !== null) {
            return { latitude, longitude }
        } else {
            console.error("Datos GPS incompletos o en formato no reconocido.")
            return null
        }
    } catch (error) {
        console.error("Error al procesar los datos del GPS:", error)
        return null
    }
}