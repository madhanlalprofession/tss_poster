import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/controller.dart';
import '../core/models.dart';

/// A toolbar widget containing buttons for adding layers and exporting.
class Toolbar extends StatelessWidget {
  /// The controller managing the poster state.
  final PosterController controller;
  final bool showText;
  final bool showImage;
  final bool showShape;

  final Axis axis;

  const Toolbar({
    super.key,
    required this.controller,
    this.showText = true,
    this.showImage = true,
    this.showShape = true,
    this.axis = Axis.vertical,
  });

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    // Show dialog to choose between camera and gallery
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('From Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('From Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      try {
        final XFile? image = await picker.pickImage(source: source);
        if (image != null) {
          final bytes = await image.readAsBytes();
          controller.addImageFromFile(image.path, bytes: bytes);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image added successfully')),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to pick image: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: axis == Axis.vertical ? null : double.infinity,
      height: axis == Axis.horizontal ? null : double.infinity,
      child: SingleChildScrollView(
        scrollDirection: axis,
        child: Flex(
          direction: axis,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: axis == Axis.horizontal ? 10 : 0,
              height: axis == Axis.vertical ? 20 : 0,
            ),
            if (showText)
              _ToolbarButton(
                icon: Icons.text_fields,
                label: 'Text',
                onTap: () {
                  controller.addLayer(TextLayer(text: 'New Text'));
                },
                axis: axis,
              ),
            if (showImage)
              _ToolbarButton(
                icon: Icons.image,
                label: 'Image',
                onTap: () => _pickImage(context),
                axis: axis,
              ),
            if (showShape) ...[
              _ToolbarButton(
                icon: Icons.circle,
                label: 'Circle',
                onTap: () {
                  controller.addLayer(ShapeLayer(
                    shapeType: 'circle',
                    color: Colors.red,
                  ));
                },
                axis: axis,
              ),
              _ToolbarButton(
                icon: Icons.rectangle,
                label: 'Box',
                onTap: () {
                  controller.addLayer(ShapeLayer(
                    shapeType: 'rectangle',
                    color: Colors.blue,
                  ));
                },
                axis: axis,
              ),
            ],
            if (axis == Axis.vertical)
              const Divider()
            else
              Container(
                width: 1,
                height: 40,
                color: Colors.grey[300],
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
            _ToolbarButton(
              icon: Icons.undo,
              label: 'Undo',
              onTap: () => controller.undo(),
              axis: axis,
            ),
            _ToolbarButton(
              icon: Icons.redo,
              label: 'Redo',
              onTap: () => controller.redo(),
              axis: axis,
            ),
            _ToolbarButton(
              icon: Icons.content_copy,
              label: 'Duplicate',
              onTap: () {
                final selected = controller.selectedLayer;
                if (selected != null) {
                  controller.duplicateLayer(selected.id);
                }
              },
              axis: axis,
            ),
            _ToolbarButton(
              icon: Icons.delete,
              label: 'Delete',
              onTap: () {
                final selected = controller.selectedLayer;
                if (selected != null) {
                  controller.removeLayer(selected.id);
                }
              },
              axis: axis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Axis axis;

  const _ToolbarButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.axis,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: axis == Axis.vertical ? 16.0 : 8.0,
          horizontal: axis == Axis.horizontal ? 16.0 : 0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
