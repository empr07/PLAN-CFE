import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:plan_cfe/page/login/login.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset(
        'assets/image/Comisión_Federal_de_Electricidad_(logo)_.svg.png',
        fit: BoxFit.contain,
      ),
      logoWidth: 160.0,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      showLoader: true,
      loadingText: const Text(
        "Loading...",
        style: TextStyle(fontSize: 10),
      ),
      navigator: const LoginPage(),
      durationInSeconds: 2,
    );
  }
}
