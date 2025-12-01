import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/models.dart';

/// A form widget for automatically generating posters based on user input.
class AutoPosterForm extends StatefulWidget {
  /// Callback function triggered when a poster is generated.
  final Function(PosterModel) onGenerate;

  const AutoPosterForm({super.key, required this.onGenerate});

  @override
  State<AutoPosterForm> createState() => _AutoPosterFormState();
}

class _AutoPosterFormState extends State<AutoPosterForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _subtitle = '';
  String _description = '';
  String _layoutStyle = 'Simple'; // Simple, Modern, Grid
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _images.addAll(pickedFiles);
      });
    }
  }

  void _generatePoster() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final poster = PosterModel();

      if (_layoutStyle == 'Simple') {
        _generateSimpleLayout(poster);
      } else if (_layoutStyle == 'Modern') {
        _generateModernLayout(poster);
      } else if (_layoutStyle == 'Grid') {
        _generateGridLayout(poster);
      }

      widget.onGenerate(poster);
    }
  }

  void _generateSimpleLayout(PosterModel poster) {
    poster.backgroundColor = Colors.white;
    poster.layers.add(TextLayer(
      text: _title,
      style: const TextStyle(
          fontSize: 60, fontWeight: FontWeight.bold, color: Colors.black),
      position: const Offset(50, 100),
    ));
    if (_subtitle.isNotEmpty) {
      poster.layers.add(TextLayer(
        text: _subtitle,
        style: const TextStyle(fontSize: 40, color: Colors.grey),
        position: const Offset(50, 180),
      ));
    }
    double currentY = 300;
    for (var img in _images) {
      poster.layers.add(ImageLayer(
        source: img.path,
        isNetwork: false,
        position: Offset(50, currentY),
        scale: 0.5,
      ));
      currentY += 250;
    }
    if (_description.isNotEmpty) {
      poster.layers.add(TextLayer(
        text: _description,
        style: const TextStyle(fontSize: 30, color: Colors.black87),
        position: Offset(50, currentY + 50),
      ));
    }
  }

  void _generateModernLayout(PosterModel poster) {
    poster.backgroundColor = Colors.black;
    // Title centered with color
    poster.layers.add(TextLayer(
      text: _title,
      style: const TextStyle(
          fontSize: 70, fontWeight: FontWeight.bold, color: Colors.amber),
      position: const Offset(100, 100),
      align: TextAlign.center,
    ));
    // Images in a row if possible
    double currentX = 50;
    double currentY = 300;
    for (var i = 0; i < _images.length; i++) {
      poster.layers.add(ImageLayer(
        source: _images[i].path,
        isNetwork: false,
        position: Offset(currentX, currentY),
        scale: 0.4,
      ));
      currentX += 220;
      if (currentX > 800) {
        currentX = 50;
        currentY += 220;
      }
    }
  }

  void _generateGridLayout(PosterModel poster) {
    poster.backgroundColor = Colors.grey[200]!;
    // 2x2 Grid logic for images
    double x = 50;
    double y = 50;
    for (var img in _images) {
      poster.layers.add(ImageLayer(
        source: img.path,
        isNetwork: false,
        position: Offset(x, y),
        scale: 0.45,
      ));
      x += 500;
      if (x > 600) {
        x = 50;
        y += 500;
      }
    }
    // Overlay rectangle with opacity
    poster.layers.add(ShapeLayer(
      shapeType: 'rectangle',
      color: Color.fromRGBO(255, 255, 255, 0.8),
      position: const Offset(100, 800),
      scale: 3.0,
    ));
    // Title text
    poster.layers.add(TextLayer(
      text: _title,
      style: const TextStyle(
          fontSize: 50, fontWeight: FontWeight.bold, color: Colors.black),
      position: const Offset(120, 820),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Required' : null,
              onSaved: (value) => _title = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Subtitle'),
              onSaved: (value) => _subtitle = value ?? '',
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              onSaved: (value) => _description = value ?? '',
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              initialValue: _layoutStyle,
              decoration: const InputDecoration(labelText: 'Layout Style'),
              items: ['Simple', 'Modern', 'Grid']
                  .map((style) =>
                      DropdownMenuItem(value: style, child: Text(style)))
                  .toList(),
              onChanged: (value) => setState(() => _layoutStyle = value!),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.image),
              label: const Text('Upload Images'),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children:
                  _images.map((img) => Chip(label: Text(img.name))).toList(),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _generatePoster,
              child: const Text('Generate Poster'),
            ),
          ],
        ),
      ),
    );
  }
}
