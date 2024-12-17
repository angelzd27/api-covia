import express from 'express';
import cors from 'cors';
import net from 'net';
import http from 'http';
import jwt from 'jsonwebtoken';
import { Server as SocketIOServer } from 'socket.io';
import ioClient from 'socket.io-client';
import { router_hikvision } from './routes/hikvision.js';
import { router_ruptela } from './routes/ruptela.js';
import { router_auth } from './routes/auth.js';
import { router_devices } from './routes/devices.js';
import { router_geofences } from './routes/geofences.js';
import { parseRuptelaPacketWithExtensions } from './controller/ruptela.js';
import { router_drones } from './routes/drones.js';
import { router_users } from './routes/users.js';
import { router_admin } from './routes/admin.js';
import { verifyAdmin } from './middleware/verifyAdmin.js'

const app = express();
const PORT = 5000;
const TCP_PORT = 6000;
const EXTERNAL_SOCKET_URL = 'http://74.208.169.184:12056'; // Cambiar por la URL del socket externo

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
app.use('/api/users', router_users);
app.use('/api/admin', verifyAdmin, router_admin)

// Crear servidor HTTP unificado
const httpServer = http.createServer(app);

// Configuración de Socket.IO en el mismo servidor HTTP
const io = new SocketIOServer(httpServer, {
    cors: {
        origin: 'http://localhost:5173',
    },
    reconnection: true,
    reconnectionAttempts: Infinity,
    reconnectionDelay: 1000,
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

    socket.on('connect-to-external', async ({ token, didArray }) => {
        try {
            // Validar y decodificar el JWT
            const decoded = jwt.verify(token, process.env.SECRET_KEY);
            const { key } = decoded;

            // Conectar al socket externo con cliente compatible con v2
            const externalSocket = ioClient(EXTERNAL_SOCKET_URL, {
                transports: ['websocket'], // Forzar el uso de WebSocket
                reconnection: true,
                reconnectionAttempts: Infinity,
                reconnectionDelay: 1000,
            });

            externalSocket.on('connect', () => {
                console.log('Conectado al socket externo (v2)');

                // Emitir los eventos de suscripción requeridos
                externalSocket.emit('sub_gps', { key, didArray });
                externalSocket.emit('sub_alarm', { key, didArray, alarmType: [1, 2] });

                console.log('Eventos de suscripción enviados al socket externo.');
            });

            // Escuchar eventos del socket externo y retransmitir
            externalSocket.on('sub_gps', (data) => {
                console.log('Datos recibidos de sub_gps:', data);
                socket.emit('sub_gps', data);
            });

            externalSocket.on('sub_alarm', (data) => {
                console.log('Datos recibidos de sub_alarm:', data);
                socket.emit('sub_alarm', data);
            });

            // Manejar errores del socket externo
            externalSocket.on('error', (err) => {
                console.error('Error en el socket externo:', err.message);
                socket.emit('external-error', err.message);
            });

            // Manejar desconexión del socket externo
            externalSocket.on('disconnect', (reason) => {
                console.log(`Socket externo desconectado: ${reason}`);
                socket.emit('external-disconnect', reason);
            });
        } catch (error) {
            console.error('Error al conectar con el socket externo:', error.message);
            socket.emit('connection-error', { message: 'Error de conexión', error: error.message });
        }
    });

    socket.on('disconnect', (reason) => {
        console.log(`Cliente desconectado: ${reason}`);
    });
});

// Manejo global de errores para garantizar disponibilidad
process.on('uncaughtException', (err) => {
    console.error('Excepción no capturada:', err.message);
});

process.on('unhandledRejection', (reason, promise) => {
    console.error('Promesa rechazada sin manejar:', promise, 'Razón:', reason);
});