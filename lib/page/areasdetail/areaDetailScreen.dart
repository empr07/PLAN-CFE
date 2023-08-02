import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plan_cfe/models/area.model.dart';
import 'package:plan_cfe/page/subestaciondetail/subestacionDetailScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AreaDetailScreen extends StatefulWidget {
  final Areasss? area;
  final int id;
  const AreaDetailScreen({Key? key, required this.id, this.area})
      : super(key: key);

  @override
  State<AreaDetailScreen> createState() => _AreaDetailScreenState();
}

class _AreaDetailScreenState extends State<AreaDetailScreen> {
  late Future<Areasss> futureArea;

  @override
  void initState() {
    super.initState();
    futureArea = fetchArea();
  }

  Future<Areasss> fetchArea() async {
    final token = await _getToken();
    final response = await Dio().get(
      'https://apicfe.onrender.com/api/areas/${widget.id}',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    return Areasss.fromJson(response.data);
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Areasss>(
          future: futureArea,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.nombre);
            } else if (snapshot.hasError) {
              return Text('Error');
            }
            // By default, show a loading spinner.
            return CircularProgressIndicator(
              color: Colors.white, // Spinner color, you can change it
              strokeWidth: 2.0, // Spinner line width, you can change it
            );
          },
        ),
      ),
      body: FutureBuilder<Areasss>(
        future: futureArea,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ...snapshot.data!.subestaciones.map((sub) {
                    return Card(
                      color: const Color.fromARGB(174, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.green, width: 2),
                      ),
                      child: ListTile(
                        title: Text(sub.nombre),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SubstationDetailScreen(id: sub.id),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ],
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
      ),
    );
  }
}
