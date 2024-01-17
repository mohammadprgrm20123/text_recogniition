import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:text_recognition_flutter/services/database_service.dart';
import '../models/point.dart';

class ResultScreen extends StatelessWidget {
  final String text;
  const ResultScreen({super.key, required this.text});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
        ),
        body: Container(
          padding: const EdgeInsets.all(30.0),
          child: Text(text),
        ),
      );
}

Future<String> getPointPicture(String name) async {
  final DatabaseService _databaseService = DatabaseService();
  //final point = await _databaseService.point(name);
  return "point.img";
}
