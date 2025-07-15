class Visitor {
  final String id; // ID único del visitante, generalmente generado por Supabase
  final String name; // Nombre del visitante
  final String reason; // Motivo de la visita
  final DateTime visitTime; // Hora de la visita
  final String? photoUrl; // URL de la foto del visitante (opcional)

  // Constructor de la clase Visitor
  Visitor({
    required this.id,
    required this.name,
    required this.reason,
    required this.visitTime,
    this.photoUrl,
  });

  // Método de fábrica para crear una instancia de Visitor desde un mapa (usado al leer de Supabase)
  factory Visitor.fromMap(Map<String, dynamic> map) {
    return Visitor(
      id: map['id'],
      name: map['name'],
      reason: map['reason'],
      visitTime: DateTime.parse(map['visit_time']), // Convierte la cadena de fecha/hora a DateTime
      photoUrl: map['photo_url'],
    );
  }

  // Método para convertir una instancia de Visitor a un mapa (usado al escribir en Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'reason': reason,
      'visit_time': visitTime.toIso8601String(), // Convierte DateTime a una cadena ISO 8601
      'photo_url': photoUrl,
    };
  }
}
