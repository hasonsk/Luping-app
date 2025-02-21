import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const String baseUrl = "http://10.0.2.2:3001/api";

  Future<User?> createUser(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      log("User registered: ${cred.user?.uid}");
      return cred.user;
    } catch (e) {
      _logError("registration", e);
      return null;
    }
  }

  Future<User?> loginUser(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      log("User logged in: ${cred.user?.uid}");
      return cred.user;
    } catch (e) {
      _logError("login", e);
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      log("User signed out");
    } catch (e) {
      _logError("sign out", e);
    }
  }

  static Future<bool> signUp(String email, String password, String fullName) async {
    return await _handleBackendRequest(
      endpoint: "$baseUrl/users/register",
      body: {
        "email": email,
        "password": password,
        "full_name": fullName,
        "date_of_birth": "2000-01-01",
        "phone_number": "+84999999999"
      },
      successMessage: "Registration successful on backend",
      errorMessage: "Registration failed on backend"
    );
  }

  static Future<bool> login(String email, String password) async {
    return await _handleBackendRequest(
      endpoint: "$baseUrl/users/login",
      body: {
        "email": email,
        "password": password,
      },
      successMessage: "Login successful on backend",
      errorMessage: "Login failed on backend"
    );
  }

  static Future<bool> logout() async {
    return await _handleBackendRequest(
      endpoint: "$baseUrl/users/logout",
      method: 'POST',
      successMessage: "Logout successful on backend",
      errorMessage: "Logout failed on backend"
    );
  }

  static Future<bool> _handleBackendRequest({
    required String endpoint,
    String method = 'POST',
    Map<String, dynamic>? body,
    required String successMessage,
    required String errorMessage,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {"Content-Type": "application/json"},
        body: body != null ? jsonEncode(body) : null,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("✅ $successMessage");
        return true;
      } else {
        log("❌ $errorMessage. Error code: ${response.statusCode}, Content: ${response.body}");
        return false;
      }
    } catch (e) {
      log("⚠️ Error connecting to backend: $e");
      return false;
    }
  }

  static void _logError(String action, dynamic error) {
    log("Firebase $action error: $error");
  }
}
