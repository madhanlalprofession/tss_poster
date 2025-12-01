import 'package:flutter/material.dart';
import '../templates/template_gallery.dart';
import 'poster_editor.dart';

/// Page for selecting a poster template.
class TemplatePage extends StatelessWidget {
  const TemplatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Template'),
      ),
      body: TemplateGallery(
        onSelect: (template) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PosterEditor(initialPoster: template),
            ),
          );
        },
      ),
    );
  }
}
