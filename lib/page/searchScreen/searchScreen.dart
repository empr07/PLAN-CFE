import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:plan_cfe/models/area.model.dart';
import 'package:plan_cfe/models/circuito.model.dart';
import 'package:plan_cfe/models/subestacion.model.dart';

import 'package:plan_cfe/page/areasdetail/areaDetailScreen.dart';
import 'package:plan_cfe/page/circuitoScreen/circuitoScreen.dart';
import 'package:plan_cfe/page/subestaciondetail/subestacionDetailScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  SearchType _searchType = SearchType.area;
  List<dynamic> searchResults = [];

  List<Areasss> _areas = [];
  List<Substation> _subestaciones = [];
  List<Circuito> _circuitos = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return token;
  }

  Future<void> fetchData() async {
    final token = await _getToken(); // Obtener el token

    // Obtener áreas desde el endpoint correspondiente
    final areasResponse = await Dio().get(
      'https://apicfe.onrender.com/api/areas',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        }, // Agregar el token en los headers
      ),
    );
    final areasData = areasResponse.data as List<dynamic>;
    _areas = areasData.map((data) => Areasss.fromJson(data)).toList();

    // Obtener subestaciones desde el endpoint correspondiente
    final subestacionesResponse = await Dio().get(
      'https://apicfe.onrender.com/api/subestaciones',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        }, // Agregar el token en los headers
      ),
    );
    final subestacionesData = subestacionesResponse.data as List<dynamic>;
    _subestaciones =
        subestacionesData.map((data) => Substation.fromJson(data)).toList();

    // Obtener circuitos desde el endpoint correspondiente
    final circuitosResponse = await Dio().get(
      'https://apicfe.onrender.com/api/circuitos',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        }, // Agregar el token en los headers
      ),
    );
    final circuitosData = circuitosResponse.data as List<dynamic>;
    _circuitos = circuitosData.map((data) => Circuito.fromJson(data)).toList();

    // Realizar la búsqueda inicial
    _searchQuery = '';
    _searchType = SearchType.area;
    searchResults = performSearch(_searchQuery, _searchType);

    setState(
        () {}); // Actualizar el estado para que se muestren los datos cargados
  }

  String capitalize(String s) {
    if (s.isEmpty) {
      return s;
    }
    return s[0].toUpperCase() + s.substring(1);
  }

  List<dynamic> performSearch(String query, SearchType searchType) {
    final List<dynamic> results = [];

    if (searchType == SearchType.area) {
      results.addAll(_areas.where(
          (area) => area.nombre.toLowerCase().contains(query.toLowerCase())));
    } else if (searchType == SearchType.subestacion) {
      results.addAll(_subestaciones.where((subestacion) =>
          subestacion.nombre.toLowerCase().contains(query.toLowerCase())));
    } else if (searchType == SearchType.circuito) {
      results.addAll(_circuitos.where((circuito) =>
          circuito.nombre.toLowerCase().contains(query.toLowerCase())));
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Búsqueda'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      searchResults = performSearch(_searchQuery, _searchType);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              PopupMenuButton<SearchType>(
                icon: Icon(Icons.filter_list), // icono de filtros
                onSelected: (value) {
                  setState(() {
                    _searchType = value;
                    searchResults = performSearch(_searchQuery, _searchType);
                  });
                },
                itemBuilder: (context) {
                  return SearchType.values.map((SearchType type) {
                    return PopupMenuItem<SearchType>(
                      value: type,
                      // Convertir el tipo de búsqueda a cadena y eliminar "SearchType."
                      child: Text(capitalize(type.toString().split('.').last)),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final result = searchResults[index];
                return ListTile(
                  title: Text(result.nombre),
                  onTap: () {
                    if (result is Areasss) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AreaDetailScreen(area: result, id: result.id),
                        ),
                      );
                    } else if (result is Substation) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubstationDetailScreen(
                              subestacion: result, id: result.id),
                        ),
                      );
                    } else if (result is Circuito) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CircuitoDetailScreen(
                            circuito: result,
                            id: result.id,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum SearchType {
  area,
  subestacion,
  circuito, // Agregar la constante Areasss
}
