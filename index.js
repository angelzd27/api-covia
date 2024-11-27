import express from 'express'
import cors from 'cors'
import { createServer } from 'net';
import process from 'ruptela';
import { router_hikvision } from './routes/hikvision.js'
import { router_ruptela } from './routes/ruptela.js'

const app = express()
const PORT = 5000 || 1500
const TCP_PORT = 6000 // Puerto para recibir los datos del GPS

const server = createServer();

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

// Servidor TCP para recibir datos del GPS
// const tcpServer = net.createServer((socket) => {
//     console.log('Conexión TCP establecida con el GPS.')

//     socket.on('data', (data) => {
//         // Aquí debes procesar los datos recibidos del GPS
//         // Puedes decodificar los datos y extraer la latitud y longitud
//         // como sea necesario dependiendo del formato de los datos.

//         console.log('::::::::::::::::::::::::::::::::::::::')
//         // console.log('Datos de GPS recibidos:', data)
//         console.log('Datos de GPS recibidos:', data.toString('hex'))
//         console.log('::::::::::::::::::::::::::::::::::::::')

//         // const parsedData = parseGPSData(data) // Implementa esta función según el protocolo del GPS
//         // if (parsedData) {
//         //     coordinates = {
//         //         latitude: parsedData.latitude,
//         //         longitude: parsedData.longitude
//         //     }
//         //     console.log('Datos de GPS recibidos:', coordinates)
//         // }
//     })

//     socket.on('end', () => {
//         console.log('Conexión TCP finalizada.')
//     })
// })

server.on('connection', (conn) => {
    const addr = conn.remoteAddress + ':' + conn.remotePort;
    console.log('New connection from %s', addr);

    conn.on('data', (data) => {
        console.log('New data from connection %s: %j', addr, data);
        const res = process(data);
        console.log('Response of process:', res);
        if (!res.error) {
            //do something with res.data

            //return acknowledgement
            conn.write(res.ack);
            console.log('Acknowledgement:', res.ack);
        } else {
            //do something with res.error
        }
    });
    conn.once('close', () => {
        console.log('Connection from %s closed', addr);
    });
    conn.on('error', (error) => {
        console.log('Error from connection %s: %s', addr, error.message);
    });
});

server.listen(TCP_PORT, () => {
    console.log('Server started on port %s at %s', server.address().port, server.address().address);
});

// tcpServer.listen(TCP_PORT, () => {
//     console.log(`Servidor TCP escuchando en el puerto ${TCP_PORT} para datos de GPS`)
// })

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