import 'package:plan_cfe/models/subestacion.model.dart';

class Circuito {
  final int id;
  final int idarea;
  final int idsubestacion;
  final int idnumcirc;
  final String nombre;
  final String diagrama;
  final String createdAt;
  final String updatedAt;
  final Area area;
  final Substation subestacion;
  final NumCirc numcirc;
  final List<Ubicacion> ubicaciones;

  Circuito({
    required this.id,
    required this.idarea,
    required this.idsubestacion,
    required this.idnumcirc,
    required this.nombre,
    required this.diagrama,
    required this.createdAt,
    required this.updatedAt,
    required this.area,
    required this.subestacion,
    required this.numcirc,
    required this.ubicaciones,
  });

  factory Circuito.fromJson(Map<String, dynamic> json) {
    return Circuito(
      id: json['id'],
      idarea: json['idarea'],
      idsubestacion: json['idsubestacion'],
      idnumcirc: json['idnumcirc'],
      nombre: json['nombre'],
      diagrama: json['diagrama'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'],
      area: Area.fromJson(json['area']),
      subestacion: Substation.fromJson(json['subestacion']),
      numcirc: NumCirc.fromJson(json['numcirc']),
      ubicaciones: (json['ubicaciones'] as List)
          .map((i) => Ubicacion.fromJson(i))
          .toList(),
    );
  }
}

class Ubicacion {
  final int id;
  final int idcircuito;
  final String cuchilla;
  final String tipo;
  final String direccion;
  final int enlace;
  final String normal;
  final double latitud;
  final double longitud;
  final String createdAt;
  final String updatedAt;

  Ubicacion({
    required this.id,
    required this.idcircuito,
    required this.cuchilla,
    required this.tipo,
    required this.direccion,
    required this.enlace,
    required this.normal,
    required this.latitud,
    required this.longitud,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Ubicacion.fromJson(Map<String, dynamic> json) {
    return Ubicacion(
      id: json['id'],
      idcircuito: json['idcircuito'],
      cuchilla: json['cuchilla'],
      tipo: json['tipo'],
      direccion: json['direccion'],
      enlace: json['enlace'],
      normal: json['normal'],
      latitud: json['latitud'],
      longitud: json['longitud'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
