import express from 'express'
import cors from 'cors'
import net from 'net'
import axios from 'axios'

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

// Get Token Hik Vision
app.post('/api/hikvision/get-token', async (request, response) => {
    const { appKey, secretKey } = request.body
    const url = 'https://ius.hikcentralconnect.com/api/hccgw/platform/v1/token/get'

    const requestOptions = {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        data: {
            appKey: appKey,
            secretKey: secretKey
        }
    }

    const requestData = await axios(url, requestOptions)

    response.json(requestData.data)
})

// Get Info Cameras Hik Vision
app.post('/api/hikvision/get-cameras', async (request, response) => {
    const { token } = request.body
    const url = 'https://ius.hikcentralconnect.com/api/hccgw/resource/v1/areas/cameras/get'

    const requestOptions = {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Token': token
        },
        data: {
            pageIndex: '1',
            pageSize: '150',
            filter: {
                areaID: '-1',
                includeSubArea: '1'
            }
        }
    }

    const requestData = await axios(url, requestOptions)

    response.json(requestData.data)
})

// Get Streaming Token by Hik Vision
app.post('/api/hikvision/get-streaming-token', async (request, response) => {
    const { token } = request.body
    const url = 'https://ius.hikcentralconnect.com/api/hccgw/platform/v1/streamtoken/get'

    const requestOptions = {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'Token': token
        }
    }

    const requestData = await axios(url, requestOptions)

    response.json(requestData.data)
})

// Get Streaming by Hik Vision
app.post('/api/hikvision/get-streaming', async (request, response) => {
    const { token, type, code, deviceSerial, resourceId } = request.body
    const url = `https://ius.hikcentralconnect.com/api/hccgw/video/v1/live/address/get`

    const requestOptions = {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Token': token
        },
        data: {
            type: type,
            code: code,
            deviceSerial: deviceSerial,
            resourceId: resourceId
        }
    }

    const requestData = await axios(url, requestOptions)

    response.json(requestData.data)
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