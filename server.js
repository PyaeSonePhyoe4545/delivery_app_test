const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const cors = require('cors');

const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"]
  }
});

app.use(cors());
app.use(express.json());

// Store connected delivery men
const deliveryMen = new Map();
const activeDeliveries = [];

// Socket.IO connection handling
io.on('connection', (socket) => {
  console.log('New client connected:', socket.id);

  // Handle authentication
  socket.on('authenticate', (data) => {
    console.log('Authentication:', data);
    if (data.userType === 'delivery_man') {
      deliveryMen.set(socket.id, {
        id: socket.id,
        userId: data.userId,
        name: data.name,
        isOnline: true,
        lastLocation: null,
        connectedAt: new Date()
      });
      
      socket.emit('authenticated', { success: true });
      console.log(`Delivery man ${data.name} authenticated`);
      
      // Send existing active deliveries to the newly connected delivery man
      socket.emit('active_deliveries', activeDeliveries);
    }
  });

  // Handle location updates
  socket.on('location_update', (locationData) => {
    console.log('Location update received:', locationData);
    
    const deliveryMan = deliveryMen.get(socket.id);
    if (deliveryMan) {
      deliveryMan.lastLocation = locationData;
      deliveryMan.lastUpdate = new Date();
      
      // Broadcast location to other clients (like admin dashboard)
      socket.broadcast.emit('delivery_man_location', {
        deliveryManId: deliveryMan.userId,
        location: locationData
      });

      // Acknowledge the location update
      socket.emit('location_update_ack', {
        status: 'received',
        timestamp: new Date().toISOString()
      });
    }
  });

  // Handle delivery status updates
  socket.on('delivery_status_update', (data) => {
    console.log('Delivery status update:', data);
    
    const deliveryIndex = activeDeliveries.findIndex(d => d.id === data.deliveryId);
    if (deliveryIndex !== -1) {
      activeDeliveries[deliveryIndex].status = data.status;
      activeDeliveries[deliveryIndex].updatedAt = data.timestamp;
      
      // Broadcast delivery update to all clients
      io.emit('delivery_updated', activeDeliveries[deliveryIndex]);
    }
  });

  // Handle messages
  socket.on('message', (data) => {
    console.log('Message received:', data);
    
    const deliveryMan = deliveryMen.get(socket.id);
    if (deliveryMan) {
      console.log(`Message from ${deliveryMan.name}: ${data.message}`);
    }
  });

  // Handle disconnection
  socket.on('disconnect', () => {
    console.log('Client disconnected:', socket.id);
    
    const deliveryMan = deliveryMen.get(socket.id);
    if (deliveryMan) {
      console.log(`Delivery man ${deliveryMan.name} disconnected`);
      deliveryMen.delete(socket.id);
    }
  });
});

// REST API endpoints for testing
app.get('/api/delivery-men', (req, res) => {
  const deliveryMenArray = Array.from(deliveryMen.values());
  res.json(deliveryMenArray);
});

app.post('/api/create-delivery', (req, res) => {
  const newDelivery = {
    id: `delivery_${Date.now()}`,
    orderId: `ORD${Math.floor(Math.random() * 10000)}`,
    customerName: req.body.customerName || 'Test Customer',
    customerPhone: req.body.customerPhone || '+1234567890',
    deliveryAddress: req.body.deliveryAddress || '123 Test Street, Test City',
    destinationLat: req.body.destinationLat || 40.7128,
    destinationLng: req.body.destinationLng || -74.0060,
    status: 'assigned',
    createdAt: new Date().toISOString(),
    assignedAt: new Date().toISOString()
  };

  activeDeliveries.push(newDelivery);
  
  // Broadcast new delivery to all connected delivery men
  io.emit('new_delivery', newDelivery);
  
  res.json(newDelivery);
});

app.get('/api/deliveries', (req, res) => {
  res.json(activeDeliveries);
});

app.get('/', (req, res) => {
  res.json({
    message: 'Delivery Tracker Server',
    connectedDeliveryMen: deliveryMen.size,
    activeDeliveries: activeDeliveries.length
  });
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Socket.IO server ready for connections`);
});

// Create a test delivery every 30 seconds for demonstration
setInterval(() => {
  if (deliveryMen.size > 0) {
    const testDelivery = {
      id: `delivery_${Date.now()}`,
      orderId: `ORD${Math.floor(Math.random() * 10000)}`,
      customerName: `Customer ${Math.floor(Math.random() * 100)}`,
      customerPhone: '+1234567890',
      deliveryAddress: `${Math.floor(Math.random() * 999)} Test Street, Test City`,
      destinationLat: 40.7128 + (Math.random() - 0.5) * 0.1,
      destinationLng: -74.0060 + (Math.random() - 0.5) * 0.1,
      status: 'assigned',
      createdAt: new Date().toISOString(),
      assignedAt: new Date().toISOString()
    };

    activeDeliveries.push(testDelivery);
    io.emit('new_delivery', testDelivery);
    console.log('Test delivery created:', testDelivery.orderId);
  }
}, 30000);
