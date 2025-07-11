import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:matrix/matrix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class MatrixService {
  late final Client matrixClient;

  Future<void> init() async {
    final db = await MatrixSdkDatabase.init('my_matrix_db');
    matrixClient = Client(
      'https://my-app-jw9y.onrender.com', // Replace with your actual homeserver URL
      database: db,
    );
  }

  // 🔑 SharedPreferences keys
  static const String _matrixIdKey = 'matrixId';
  static const String _accessTokenKey = 'accessToken';
  static const String _deviceIdKey = 'deviceId';

  /// ✅ Save credentials locally
  Future<void> saveMatrixCredentials(String matrixId, String accessToken, String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_matrixIdKey, matrixId);
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_deviceIdKey, deviceId);
  }

  /// ✅ Load stored credentials
  Future<Map<String, String?>> getMatrixCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'matrixId': prefs.getString(_matrixIdKey),
      'accessToken': prefs.getString(_accessTokenKey),
      'deviceId': prefs.getString(_deviceIdKey),
    };
  }

  /// ✅ Clear credentials
  Future<void> clearMatrixCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_matrixIdKey);
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_deviceIdKey);
  }

  /// ✅ Register new Matrix user
  Future<String?> registerMatrixUser(String username, String password, String email) async {
    try {
      final matrixUsername = username.toLowerCase().replaceAll(' ', '');
      final response = await matrixClient.register(
        username: matrixUsername,
        password: password,
        initialDeviceDisplayName: 'YourApp',
      );
      await saveMatrixCredentials(response.userId!, response.accessToken!, response.deviceId!);
      return response.userId!;
    } catch (e) {
      print('Matrix Registration Error: $e');
      if (e is MatrixException && e.toString().contains('M_USER_IN_USE')) {
        print('Username already in use.');
      }
      return null;
    }
  }

  /// ✅ Log in existing Matrix user
  Future<bool> loginMatrixUser(String matrixId, String password) async {
    try {
      await matrixClient.login(
        LoginType.mLoginPassword,
        identifier: AuthenticationUserIdentifier(user: matrixId),
        password: password,
      );
      await saveMatrixCredentials(matrixId, matrixClient.accessToken!, '');
      return true;
    } catch (e) {
      print('Matrix Login Error: $e');
      return false;
    }
  }

  /// ✅ Auth with stored Matrix credentials
  Future<Map<String, dynamic>> authenticateWithMatrix() async {
    try {
      final credentials = await getMatrixCredentials();
      if (credentials['matrixId'] == null || credentials['accessToken'] == null) {
        throw Exception('No Matrix credentials found. Please log in.');
      }

      // ✅ NOTE: This does NOT actually validate token/session — you should use a ping/test call in real app.
      return {
        'matrixId': credentials['matrixId'],
        'accessToken': credentials['accessToken'],
      };
    } catch (e) {
      print('Matrix Authentication Error: $e');
      throw Exception('Failed to authenticate with Matrix: $e');
    }
  }

  /// ✅ Start a simple Matrix chat
  Future<void> startChat(String recipientMatrixId) async {
    try {
      final roomId = await matrixClient.createRoom(invite: [recipientMatrixId]);
      final room = await matrixClient.getRoomById(roomId);
      if (room != null) {
        await room.sendTextEvent('Hello! Let’s start a call.');
        print('Chat started in room: $roomId');
      } else {
        print('Error: Room not found.');
      }
    } catch (e) {
      print('Error starting chat: $e');
    }
  }
}
