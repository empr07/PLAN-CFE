// To parse this JSON data, do
//
//     final areasss = areasssFromJson(jsonString);

import 'dart:convert';

List<Areasss> areasssFromJson(String str) =>
    List<Areasss>.from(json.decode(str).map((x) => Areasss.fromJson(x)));

String areasssToJson(List<Areasss> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Areasss {
  final int id;
  final String nombre;
  final DateTime? createdAt;
  final DateTime updatedAt;
  final List<Subestacione> subestaciones;

  Areasss({
    required this.id,
    required this.nombre,
    this.createdAt,
    required this.updatedAt,
    required this.subestaciones,
  });

  factory Areasss.fromJson(Map<String, dynamic> json) => Areasss(
        id: json["id"],
        nombre: json["nombre"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        subestaciones: List<Subestacione>.from(
            json["subestaciones"].map((x) => Subestacione.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "subestaciones":
            List<dynamic>.from(subestaciones.map((x) => x.toJson())),
      };
}

class Subestacione {
  final int id;
  final String nombre;

  Subestacione({
    required this.id,
    required this.nombre,
  });

  factory Subestacione.fromJson(Map<String, dynamic> json) => Subestacione(
        id: json["id"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
      };
}
