import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plan_cfe/page/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<dynamic> _allUsers = [];
  final List<dynamic> _validUsers = [];
  bool _isLoading = true; // Nuevo estado para indicar si se está cargando

  Future<void> _loadUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? email = prefs.getString('email');

    if (token != null) {
      final response = await http.get(
        Uri.parse('https://apicfe.onrender.com/api/usuarios'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        // Verificar si el widget está todavía montado antes de llamar a setState()
        if (mounted) {
          setState(() {
            _allUsers = jsonResponse;
            _isLoading = false;
          });
        }

        // Validar los usuarios
        _validUsers.clear();
        for (var User in _allUsers) {
          if (User['correo'] == email) {
            _validUsers.add(User);
          }
        }
      } else {
        throw Exception('Failed to load users');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isLoading // Mostrar el indicador de carga si isLoading es verdadero
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _validUsers.length,
                  itemBuilder: (BuildContext context, int index) {
                    final user = _validUsers[index];
                    return Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 250,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 2, 108, 45),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20.0),
                                  bottomRight: Radius.circular(20.0),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 140,
                              //left: 20,
                              child: Container(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  '${user['nombres']} ${user['apellido_p']} ${user['apellido_m']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Color.fromARGB(162, 0, 0, 0)),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 175,
                              //left: 20,
                              child: Container(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  '${user['puesto']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Color.fromARGB(162, 0, 0, 0)),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 210,
                              //left: 20,
                              child: Container(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  '${user['correo']}',
                                  style: const TextStyle(
                                      //fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color.fromARGB(162, 0, 0, 0)),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 30,
                              child: Container(
                                alignment: Alignment.topCenter,
                                child: const CircleAvatar(
                                  radius: 50,
                                  backgroundColor:
                                      Color.fromARGB(69, 129, 130, 129),
                                  backgroundImage: NetworkImage(
                                    "https://play-lh.googleusercontent.com/7UppiZcZTNBInAJzU-XG8EpGeU3BlLVJM9LoJTaWiVamvguplwUFMNUg_92lk-0z4g",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Card(
                            child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Row(
                            children: [
                              Icon(Icons.account_box),
                              SizedBox(width: 16.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Cuenta",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("Activa"),
                                ],
                              ),
                            ],
                          ),
                        )),
                        const SizedBox(
                          height: 330,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.logout),
                              onPressed: () {
                                // Navega a la pantalla de inicio de sesión
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const LoginPage()));
                              },
                            ),
                            const Text("Cerrar sesion"),
                          ],
                        )
                      ],
                    );
                  },
                ),
    );
  }
}

Widget _buildRow(IconData icon, String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: Row(
      children: [
        Icon(icon),
        const SizedBox(width: 16.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(value),
          ],
        ),
      ],
    ),
  );
}
