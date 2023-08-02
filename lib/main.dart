import 'package:flutter/material.dart';
import 'package:plan_cfe/page/home/home.dart';
import 'package:plan_cfe/page/inicio/inicio.dart';
import 'package:plan_cfe/page/splash/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return token;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: AppBarTheme(
          color: Colors.green[800],
        ),
        // Define el color de fondo de los botones
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.green,
        ),
      ),
      home: FutureBuilder<String>(
        future: _getToken(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return snapshot.data!.isEmpty
                  ? const SplashPage()
                  : BottomNavBar(); // Assuming Inicio takes no arguments
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
