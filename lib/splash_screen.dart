import 'package:flutter/material.dart';
import 'package:healthroutine/core/main_page.dart';
import 'package:healthroutine/core/widgets/app_background.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _lottieController;
  late final AnimationController _textController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
    // Controla o "fade in" do texto
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _lottieController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Lottie.asset(
              'assets/animations/splash_animation_final.json',
              controller: _lottieController,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.contain,
              onLoaded: (composition) {
                _lottieController
                  ..duration = composition.duration
                  ..forward();

                _lottieController.addListener(() {
                  if (_lottieController.value >= 0.7 &&
                      !_textController.isAnimating) {
                    _textController.forward();
                  }
                });

                // Navega quando tudo terminar
                _lottieController.addStatusListener((status) {
                  if (status == AnimationStatus.completed) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainPage()),
                    );
                  }
                });
              },
            ),

            FadeTransition(
              opacity: _textController,
              child: const Text(
                "HealthRoutine",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF7B928),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
