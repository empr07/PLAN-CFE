import 'package:dio/dio.dart';
import 'package:plan_cfe/models/area.model.dart';
import 'package:flutter/material.dart';
import 'package:plan_cfe/page/inicio/carrusel.dart';
import 'package:plan_cfe/page/searchScreen/searchScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../areasdetail/areaDetailScreen.dart';

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  List<Areasss>? areas;

  @override
  void initState() {
    super.initState();
    getAreas();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return token;
  }

  Future<void> getAreas() async {
    final token = await _getToken(); // Obten el token
    final response = await Dio().get(
      'https://apicfe.onrender.com/api/areas',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        }, // Añade el token a los headers
      ),
    );

    areas =
        (response.data as List).map((data) => Areasss.fromJson(data)).toList();
    setState(() {});
    print(response.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'ZONA MÉRIDA',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(
                    height: 10,
                  ),
                  const Carrusel(),
                  //TITULO CATEGORIA
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: const Center(
                      child: Text(
                        'Áreas',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0), // Ajusta el padding para que sea igual en todos los lados
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0), // Establece el radio de esquinas a 0 para que sea cuadrado
                        ),
                      ),
                      child: Text(
                        'Buscar',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: areas != null
                          ? areas!.map<Widget>((area) {
                              return Card(
                                color: const Color.fromARGB(174, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(
                                      color: Colors.green, width: 2),
                                ),
                                child: ListTile(
                                    title: Text(area.nombre ?? 'No hay datos'),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AreaDetailScreen(id: area.id),
                                        ),
                                      );
                                    }),
                              );
                            }).toList()
                          : [
                              Center(
                                child: CircularProgressIndicator(),
                              ),
                            ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}