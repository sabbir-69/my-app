const express = require('express');
const admin = require('firebase-admin');
const matrixSdk = require('matrix-js-sdk');
const fetch = require('node-fetch'); // matrix-js-sdk might need a fetch polyfill in Node.js

const app = express();
app.use(express.json());

// Initialize Firebase Admin SDK
// You will need to replace this with your actual service account key
// For Render deployment, consider using environment variables for credentials
// For Render deployment, you MUST set the FIREBASE_SERVICE_ACCOUNT_KEY environment variable
// with the full JSON content of your service account key.
const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT_KEY);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

// Your Matrix homeserver URL
const homeserverUrl = 'https://matrix.org'; // Replace with your homeserver URL

// Middleware to verify Firebase ID Token
const verifyFirebaseToken = async (req, res, next) => {
  const idToken = req.headers.authorization?.split('Bearer ')[1];

  if (!idToken) {
    return res.status(401).send('Unauthorized: No ID token provided.');
  }

  try {
    const decodedToken = await admin.auth().verifyIdToken(idToken);
    req.user = decodedToken;
    next();
  } catch (error) {
    console.error('Error verifying Firebase ID token:', error);
    return res.status(401).send('Unauthorized: Invalid ID token.');
  }
};

// API endpoint for Matrix authentication
app.post('/api/matrix-auth', verifyFirebaseToken, async (req, res) => {
  const userId = req.user.uid; // Firebase UID will be used as Matrix user ID

  const matrixClient = matrixSdk.createClient({
    baseUrl: homeserverUrl,
    fetch: fetch, // Pass fetch polyfill
  });

  try {
    // Try to register the user
    await matrixClient.register(userId, userId, null); // Using UID as password for simplicity, consider a more secure approach
  } catch (error) {
    // If the user is already registered, ignore the error
    if (error.message !== 'User ID already taken.') {
      console.error('Error registering Matrix user:', error.message, error.body);
      return res.status(500).send(`Could not register Matrix user: ${error.message || JSON.stringify(error.body)}`);
    }
  }

  try {
    // Login the user
    const loginResult = await matrixClient.login('m.login.password', {
      identifier: {
        type: 'm.id.user',
        user: userId,
      },
      password: userId, // Using UID as password
    });

    const accessToken = loginResult.access_token;
    const deviceId = loginResult.device_id;

    res.status(200).json({
      accessToken: accessToken,
      deviceId: deviceId,
      homeserverUrl: homeserverUrl,
    });
  } catch (error) {
    console.error('Error logging into Matrix:', error.message, error.body);
    res.status(500).send(`Could not log into Matrix: ${error.message || JSON.stringify(error.body)}`);
  }
});

// Define the port for the backend server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Backend server running on port ${PORT}`);
});
