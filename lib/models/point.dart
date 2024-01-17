import 'dart:convert';

import 'package:flutter/services.dart';

class Point {
  final int? id;
  final String name;
  final String img;

  Point({
    this.id,
    required this.name,
    required this.img,
  });

  // Convert a Point into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id' :id,
      'name': name,
      'image': img,
    };
  }

  factory Point.fromMap(Map<String, dynamic> map) {
    return Point(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      img: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Point.fromJson(String source) => Point.fromMap(json.decode(source));

  // Implement toString to make it easier to see information about
  // each Point when using the print statement.
  @override
  String toString() => 'Point(id: $id, name: $name, description: $img)';
}
