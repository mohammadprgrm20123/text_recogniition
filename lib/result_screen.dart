import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text_recognition_flutter/services/database_service.dart';
import '../models/point.dart';

class ResultScreen extends StatefulWidget {
  final String text;

  const ResultScreen({super.key, required this.text});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  RxList<Point> points = <Point>[].obs;

  @override
  void initState() {
    getAllImages();
    DatabaseService().getAllData('tricept'.toLowerCase());

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
        ),
        body: Obx(() => points.isEmpty
            ? const Center(
                child: Text(
                'Not Found any Image',
                style: TextStyle(fontWeight: FontWeight.bold),
              ))
            : ListView(
                children: [
                  ...points
                      .map((e) => Card(
                            child: Image.memory(
                              base64.decode(e.img),
                              width: 250,
                              height: 250,
                            ),
                          ))
                      .toList()
                ],
              )),
      );

  void getAllImages() async {
    print('-------------------------');
    print(widget.text);

    print(widget.text.split('\n').length);

    print('=================++++++++++++++');
    widget.text.split('\n').forEach((element) async {
      print(element);
      final list = await DatabaseService().getAllData(element);
    print('points lenght = ${points.length}');
      points.addAll(list);
    });


    points.value = points.toSet().toList();
  }
}
