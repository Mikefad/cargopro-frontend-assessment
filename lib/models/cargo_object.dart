class CargoObject {
  final String? id;
  final String name;
  final Map<String, dynamic> data;

  CargoObject({
    this.id,
    required this.name,
    required this.data,
  });

  factory CargoObject.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return CargoObject(
      id: json['id']?.toString(),
      name: (json['name'] ?? '').toString(),
      data: rawData is Map<String, dynamic>
          ? rawData
          : rawData is Map
              ? rawData.map((key, value) => MapEntry(key.toString(), value))
              : <String, dynamic>{},
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'name': name,
      'data': data,
    };
  }
}

