import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studiosync/core/router/routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller!,
      curve: Curves.fastOutSlowIn,
    ));

    _controller!.forward();

    Future.delayed(const Duration(seconds: 2), () {
      Get.toNamed(Routes.widgetTree);
    });
  }

  @override
  void dispose() {
    _controller?.dispose(); 
    super.dispose(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            // Image slide transition
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: SlideTransition(
                position: _slideAnimation!,
                child: Image.asset(
                  'assets/images/image_login.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Circular progress on top
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
