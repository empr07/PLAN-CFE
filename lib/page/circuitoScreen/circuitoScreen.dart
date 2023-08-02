import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plan_cfe/models/circuito.model.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CircuitoDetailScreen extends StatefulWidget {
  final Circuito? circuito;
  final int id;
  CircuitoDetailScreen({Key? key, required this.id, this.circuito})
      : super(key: key);

  @override
  _CircuitoDetailScreenState createState() => _CircuitoDetailScreenState();
}

class _CircuitoDetailScreenState extends State<CircuitoDetailScreen> {
  late Future<Circuito> futureCircuito;

  @override
  void initState() {
    super.initState();
    futureCircuito = fetchCircuito();
  }

  Future<Circuito> fetchCircuito() async {
    final token = await _getToken();
    final response = await Dio().get(
      'https://apicfe.onrender.com/api/circuitos/${widget.id}',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    return Circuito.fromJson(response.data);
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Circuito>(
      future: futureCircuito,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final imageBase64 = snapshot.data!.diagrama.split(',').last;
          final imageBytes = base64Decode(imageBase64);
          return Scaffold(
            appBar: AppBar(
              title: Text('${snapshot.data!.nombre}'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Diagrama
                    GestureDetector(
                      child: Image.memory(imageBytes),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Scaffold(
                            backgroundColor: Colors.white,
                            appBar: AppBar(),
                            body: Container(
                              color: Colors.white,
                              child: PhotoView(
                                imageProvider: MemoryImage(imageBytes),
                              ),
                            ),
                          );
                        }));
                      },
                    ),
                    // Ubicaciones
                    ...snapshot.data!.ubicaciones.map((ubicacion) {
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            final url =
                                'https://www.google.com/maps/search/?api=1&query=${ubicacion.latitud},${ubicacion.longitud}';
                            canLaunch(url).then((canLaunchURL) {
                              if (canLaunchURL) {
                                launch(url,
                                    forceWebView: true, enableJavaScript: true);
                              } else {
                                throw 'Could not launch $url';
                              }
                            }).catchError((err) {
                              print('Error: $err');
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                const Icon(Icons.place, size: 32),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ubicacion.cuchilla,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text('Tipo: ${ubicacion.tipo}'),
                                      Text('Enlace: ${ubicacion.enlace}'),
                                      Text('Normal: ${ubicacion.normal}'),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Dirección: ${ubicacion.direccion}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        // By default, show a loading spinner.
        return const Scaffold(
          backgroundColor: Colors.white, // Define el color de fondo aquí
          body: Center(
            child: SizedBox(
              height: 50.0, // Define el alto del spinner aquí
              width: 50.0, // Define el ancho del spinner aquí
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
