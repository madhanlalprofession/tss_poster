import 'package:flutter/material.dart';
import 'package:tss_poster/tss_poster.dart';
import 'dart:ui' as ui;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TSS Poster Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PosterHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PosterHomePage extends StatefulWidget {
  @override
  _PosterHomePageState createState() => _PosterHomePageState();
}

class _PosterHomePageState extends State<PosterHomePage> {
  late PosterController controller;

  @override
  void initState() {
    super.initState();
    // Start with the first available template
    final templates = TemplateFactory.getAllTemplates();
    controller = PosterController(
      poster: templates.isNotEmpty
          ? templates.first.poster
          : PosterModel(
              backgroundColor: Colors.white,
              size: const Size(1080, 1920),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PosterEditor(
        controller: controller,
        initialPoster: controller.poster,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
