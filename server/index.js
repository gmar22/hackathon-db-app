const express = require('express');
const dotenv = require('dotenv');
dotenv.config();

const app = express();

// Middleware
app.use(express.json());

// Test endpoint
app.get('/', (req, res) => {
  res.send('Hello World');
});

// Listen on port from environment variable or fallback to 3000
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
