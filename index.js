import express from 'express';
import cors from 'cors';
import net from 'net';
import http from 'http';
import { router_hikvision } from './routes/hikvision.js';
import { router_ruptela } from './routes/ruptela.js';
import { router_auth } from './routes/auth.js';
import { router_devices } from './routes/devices.js';
import { router_geofences } from './routes/geofences.js';
import { parseRuptelaPacketWithExtensions } from './controller/ruptela.js';
import { Server as SocketIOServer } from 'socket.io';
import { router_drones } from './routes/drones.js';

const app = express();
const PORT = 5000;
const TCP_PORT = 6000;

// Configuración de CORS
const corsOptions = {
    origin: 'http://localhost:5173',
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    credentials: true,
};

app.use(cors(corsOptions));
app.use(express.json());
app.use('/api/hikvision', router_hikvision);
app.use('/api/ruptela', router_ruptela);
app.use('/api/auth', router_auth);
app.use('/api/devices', router_devices);
app.use('/api/geofences', router_geofences);
app.use('/api/drones', router_drones);

// Crear servidor HTTP unificado
const httpServer = http.createServer(app);

// Configuración de Socket.IO en el mismo servidor HTTP
const io = new SocketIOServer(httpServer, {
    cors: {
        origin: 'http://localhost:5173',
    },
    reconnection: true, // Habilita la reconexión automática en el cliente
    reconnectionAttempts: Infinity, // Número ilimitado de intentos de reconexión
    reconnectionDelay: 1000, // Tiempo entre intentos de reconexión (en ms)
});

httpServer.listen(PORT, () => {
    console.log(`Servidor HTTP y Socket.IO escuchando en el puerto ${PORT}`);
});

// Configuración del servidor TCP
const tcpServer = net.createServer((socket) => {
    console.log('GPS connected via TCP');

    socket.on('data', (data) => {
        try {
            const hexData = data.toString('hex');
            const decodedData = parseRuptelaPacketWithExtensions(hexData);

            // Emitir datos decodificados al cliente conectado vía Socket.IO
            io.emit('gps-data', decodedData);
            console.log('Data received and emitted:', hexData);
        } catch (error) {
            console.error('Error decoding GPS data:', error.message);
        }
    });

    socket.on('end', () => {
        console.log('GPS disconnected');
    });

    socket.on('error', (error) => {
        console.error('TCP socket error:', error.message);
    });
});

tcpServer.listen(TCP_PORT, () => {
    console.log(`Servidor TCP escuchando en el puerto ${TCP_PORT}`);
});

// Manejo de eventos de Socket.IO
io.on('connection', (socket) => {
    console.log('Cliente conectado vía Socket.IO');

    // Mensaje personalizado al cliente después de la conexión
    socket.emit('welcome', { message: 'Conexión establecida con éxito' });

    // Manejar eventos personalizados
    socket.on('custom-event', (data) => {
        console.log('Custom event recibido:', data);
        // Puedes manejar lógica personalizada aquí
    });

    // Manejar errores del socket
    socket.on('error', (err) => {
        console.error('Error en Socket.IO:', err.message);
    });

    // Manejo de desconexión del cliente
    socket.on('disconnect', (reason) => {
        console.log(`Cliente desconectado: ${reason}`);
        if (reason === 'io server disconnect') {
            // El servidor forzó la desconexión, intentamos reconectar manualmente
            socket.connect();
        }
    });
});

// Manejo global de errores para garantizar disponibilidad
process.on('uncaughtException', (err) => {
    console.error('Excepción no capturada:', err.message);
});

process.on('unhandledRejection', (reason, promise) => {
    console.error('Promesa rechazada sin manejar:', promise, 'Razón:', reason);
});
