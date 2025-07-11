import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/services/matrix_service.dart'; // Import MatrixService

import 'dart:ui'; // Import for ImageFilter

class LoginPage extends StatefulWidget {
  final MatrixService matrixService; // Add MatrixService parameter

  const LoginPage({Key? key, required this.matrixService}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final MatrixService _matrixService = MatrixService(); // Instantiate MatrixService - now passed in

  String? _errorMessage;
  bool _isLoading = false; // Add loading state

  @override
  void initState() {
    super.initState();
    // _initializeMatrixClient(); // Removed initialization call
  }

  // Future<void> _initializeMatrixClient() async { // Removed initialization method
  //   setState(() {
  //     _isLoading = true; // Start loading
  //   });
  //   try {
  //     await _matrixService.init();
  //   } catch (e) {
  //     setState(() {
  //       _errorMessage = 'Matrix client initialization failed: ${e.toString()}';
  //     });
  //   } finally {
  //     setState(() {
  //       _isLoading = false; // End loading
  //     });
  //   }
  // }

  Future<void> _signIn() async {
    setState(() {
      _errorMessage = null; // Clear previous errors
      _isLoading = true; // Start loading for sign-in
    });

    try {
      // Ensure Matrix client is initialized before attempting login
      if (!widget.matrixService.matrixClient.isLogged()) { // Check if client is not already logged in
        bool matrixLoginSuccess = await widget.matrixService.loginMatrixUser(
          _emailController.text.trim(), // Use email as matrixId for now
          _passwordController.text.trim(),
        );

        if (!matrixLoginSuccess) {
          setState(() {
            _errorMessage = 'Matrix login failed. Please check your credentials.';
          });
          return; // Stop if Matrix login fails
        }
      }

      // If Matrix login is successful or already logged in, proceed with Firebase login
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Firebase authentication failed.';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false; // End loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF006A4E), // connect-green
            Color(0xFF111827), // gray-900
            Color(0x4DF42A41), // connect-red at 30% opacity (0x4D is approx 30% of FF)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Login', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white70),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white54),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white70),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white54),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        obscureText: true,
                      ),
                      const SizedBox(height: 24.0),
                      if (_errorMessage != null)
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      const SizedBox(height: 16.0),
                      _isLoading
                          ? const CircularProgressIndicator() // Show loading indicator
                          : ElevatedButton(
                              onPressed: _signIn,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF006A4E), // connect-green
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/signup');
                        },
                        child: const Text(
                          'Don\'t have an account? Sign Up',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
