import express from 'express'
import cors from 'cors'
import net from 'net'

const app = express()
const PORT = 5000 || 1500
const TCP_PORT = 6000 // Puerto para recibir los datos del GPS

// Cnfiguración de CORS
const corsOptions = {
    origin: 'http://127.0.0.1:5173', // Reemplaza con el dominio de tu frontend
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    credentials: true // Permitir envío de cookies (si es necesario)
}

app.use(cors(corsOptions))
app.use(express.json())

let coordinates = { latitude: null, longitude: null }
let datos = null

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

app.get('/api/gps-data', (req, res) => {
    if (datos) {
        res.json({ data: datos.toString('hex') }) // Devuelve los datos en formato hexadecimal
    } else {
        res.status(404).json({ error: 'No se han recibido datos de GPS.' })
    }
})

tcpServer.listen(TCP_PORT, () => {
    console.log(`Servidor TCP escuchando en el puerto ${TCP_PORT} para datos de GPS`)
})

// Endpoint para establecer coordenadas manualmente
app.post('/api/set-coordinates', (req, res) => {
    const { latitude, longitude } = req.body
    coordinates = { latitude, longitude }
    res.json({ message: 'Coordenadas guardadas correctamente', coordinates })
})

// Endpoint para obtener coordenadas
app.get('/api/get-coordinates', (req, res) => {
    res.json(coordinates)
})

app.listen(PORT, () => {
    console.log(`Servidor HTTP escuchando en el puerto ${PORT}`)
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