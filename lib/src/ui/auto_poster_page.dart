import 'package:flutter/material.dart';
import '../auto/auto_poster.dart';
import 'poster_editor.dart';

/// Page for automatically generating a poster.
class AutoPosterPage extends StatelessWidget {
  const AutoPosterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auto Poster'),
      ),
      body: AutoPosterForm(
        onGenerate: (poster) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PosterEditor(initialPoster: poster),
            ),
          );
        },
      ),
    );
  }
}
