import 'package:flutter/material.dart';

class AuthOptionsScreen extends StatelessWidget {
  const AuthOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "WELCOME!",
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30.0),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Image.asset(
                  'assets/images/nex_logo.jpg',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 50.0),
              ElevatedButton(
                onPressed:
                    () => Navigator.pushNamed(context, '/login_form_screen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC8E6C9),
                  foregroundColor: Colors.grey.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  minimumSize: Size(
                    MediaQuery.of(context).size.width * 0.75,
                    50.0,
                  ),
                ),
                child: const Text(
                  "LOG IN",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed:
                    () => Navigator.pushNamed(context, '/signup_form_screen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC8E6C9),
                  foregroundColor: Colors.grey.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  minimumSize: Size(
                    MediaQuery.of(context).size.width * 0.75,
                    50.0,
                  ),
                ),
                child: const Text(
                  "SIGN UP",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
