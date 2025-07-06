const functions = require("firebase-functions");
const matrixSdk = require("matrix-js-sdk");
const fetch = require("node-fetch");

exports.matrixAuth = functions.https.onCall(async (data, context) => {
  // Check if the user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError(
        "unauthenticated",
        "The function must be called while authenticated",
    );
  }

  const userId = context.auth.uid;

  // Your Matrix homeserver URL
  const homeserverUrl = "https://matrix.org"; // Replace with your homeserver URL

  // Create a Matrix client
  const matrixClient = matrixSdk.createClient({
    baseUrl: homeserverUrl,
    fetch: fetch,
  });

  try {
    // Try to register the user
    await matrixClient.register(userId, userId, null);
  } catch (error) {
    // If the user is already registered, ignore the error
    if (error.message !== "User ID already taken.") {
      console.error("Error registering user:", error);
      throw new functions.https.HttpsError(
          "internal",
          "Could not register user",
      );
    }
  }

  try {
    // Login the user
    const loginResult = await matrixClient.login("m.login.password", {
      identifier: {
        type: "m.id.user",
        user: userId,
      },
      password: userId,
    });

    const accessToken = loginResult.access_token;
    const deviceId = loginResult.device_id;

    return {
      accessToken: accessToken,
      deviceId: deviceId,
    };
  } catch (error) {
    console.error("Error logging in:", error);
    throw new functions.https.HttpsError("internal", "Could not log in.");
  }
});
