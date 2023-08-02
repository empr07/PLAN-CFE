class Substation {
  final int id;
  final int idarea;
  final String nombre;
  final String? createdAt;
  final String? updatedAt;
  final Area area;
  final List<NumCirc> numcircs;

  Substation({
    required this.id,
    required this.idarea,
    required this.nombre,
    this.createdAt,
    this.updatedAt,
    required this.area,
    required this.numcircs,
  });

  factory Substation.fromJson(Map<String, dynamic> json) {
    var numcircsFromJson = json['numcircs'] as List<dynamic>?;
    return Substation(
      id: json['id'],
      idarea: json['idarea'] ?? 0,
      nombre: json['nombre'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      area: json['area'] != null
          ? Area.fromJson(json['area'])
          : Area(id: 0, nombre: 'N/A'),
      numcircs: numcircsFromJson != null
          ? numcircsFromJson.map((item) => NumCirc.fromJson(item)).toList()
          : [],
    );
  }
}

class Area {
  final int id;
  final String nombre;

  Area({required this.id, required this.nombre});

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}

class NumCirc {
  final int id;
  final String numero;

  NumCirc({required this.id, required this.numero});

  factory NumCirc.fromJson(Map<String, dynamic> json) {
    return NumCirc(
      id: json['id'],
      numero: json['numero'],
    );
  }
}
