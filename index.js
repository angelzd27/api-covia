import express from 'express';
import cors from 'cors';
import net from 'net';
import http from 'http';
import { WebSocketServer } from 'ws';
import { router_hikvision } from './routes/hikvision.js';
import { router_ruptela } from './routes/ruptela.js';
import { router_auth } from './routes/auth.js';
import { router_devices } from './routes/devices.js';
import { router_geofences } from './routes/geofences.js';
import { parseRuptelaPacketWithExtensions } from './controller/ruptela.js';

const app = express();
const PORT = 5000 || 1500;
const TCP_PORT = 6000;
const WS_PORT = 4000;

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

app.listen(PORT, () => {
    console.log(`La marrana HTTP está viva en el puerto ${PORT}`);
});

// Configuración del servidor TCP
const tcpServer = net.createServer((socket) => {
    console.log('GPS connected via TCP');

    socket.on('data', (data) => {
        try {
            const hexData = data.toString('hex');
            const decodedData = parseRuptelaPacketWithExtensions(hexData);

            // Emitir datos decodificados a los clientes conectados vía WebSocket
            broadcastToWebSocketClients(decodedData);
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

// Configuración del servidor HTTP y WebSocket
const httpServer = http.createServer();
const wsServer = new WebSocketServer({ server: httpServer });

const clients = new Set();

wsServer.on('connection', (ws) => {
    console.log('Client connected via WebSocket');
    clients.add(ws);

    ws.on('close', () => {
        console.log('Client disconnected');
        clients.delete(ws);
    });

    ws.on('error', (error) => {
        console.error('WebSocket error:', error.message);
    });
});

// Función para enviar datos a todos los clientes WebSocket conectados
function broadcastToWebSocketClients(data) {
    for (const client of clients) {
        if (client.readyState === client.OPEN) {
            client.send(JSON.stringify(data));
        }
    }
}

tcpServer.listen(TCP_PORT, () => {
    console.log(`TCP server listening on port ${TCP_PORT}`);
});

httpServer.listen(WS_PORT, () => {
    console.log(`WebSocket server listening on port ${WS_PORT}`);
});
