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
      appBar: AppBar(
        title: const Text('TSS Poster Editor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportPoster(),
            tooltip: 'Export Poster',
          ),
        ],
      ),
      body: PosterEditor(
        controller: controller,
        initialPoster: controller.poster,
      ),
    );
  }

  Future<void> _exportPoster() async {
    try {
      final exportService = ExportService();
      await exportService.exportPoster(
        controller.poster,
        format: ExportFormat.png,
        quality: ExportQuality.high,
        filename: 'my_awesome_poster',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Poster exported successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
