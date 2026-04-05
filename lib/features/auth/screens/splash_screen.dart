import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate loading/initialization time
    Future.delayed(const Duration(seconds: 2), () {
      // In a real app we'll check auth state and route to login or home
      // context.goNamed('login'); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF004655), // App theme color (Deep Sea)
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_outline,
              size: 80,
              color: Colors.white,
            ),
            SizedBox(height: 24),
            Text(
              'PalCareer',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(
              color: Color(0xFF0E7C7B), // App theme secondary color (Teal Horizon)
            ),
          ],
        ),
      ),
    );
  }
}
