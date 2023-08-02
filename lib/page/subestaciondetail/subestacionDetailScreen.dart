import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plan_cfe/models/subestacion.model.dart';
import 'package:plan_cfe/page/circuitoScreen/circuitoScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubstationDetailScreen extends StatefulWidget {
  final Substation? subestacion;
  final int id;
  const SubstationDetailScreen({Key? key, required this.id, this.subestacion})
      : super(key: key);

  @override
  _SubstationDetailScreenState createState() => _SubstationDetailScreenState();
}

class _SubstationDetailScreenState extends State<SubstationDetailScreen> {
  late Future<Substation> futureSubstation;

  @override
  void initState() {
    super.initState();
    futureSubstation = fetchSubstation();
  }

  Future<Substation> fetchSubstation() async {
    final token = await _getToken();
    final response = await Dio().get(
      'https://apicfe.onrender.com/api/subestaciones/${widget.id}',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    return Substation.fromJson(response.data);
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Substation>(
      future: futureSubstation,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text('${snapshot.data!.nombre}'),
            ),
            body: ListView(
              children: snapshot.data!.numcircs.map((circ) {
                return Card(
                  color: const Color.fromARGB(174, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.green, width: 2),
                  ),
                  child: ListTile(
                    title: Text('${circ.numero}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CircuitoDetailScreen(id: circ.id),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
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
