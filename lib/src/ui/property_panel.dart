import 'package:flutter/material.dart';
import '../core/controller.dart';
import '../core/models.dart';

/// Property panel for editing selected layer properties
class PropertyPanel extends StatelessWidget {
  final PosterController controller;

  const PropertyPanel({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final selectedLayer = controller.selectedLayer;

        if (selectedLayer == null) {
          return Container(
            color: Colors.white,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.touch_app, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Select a layer to edit',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        return Container(
          color: Colors.white,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Layer type indicator
                _buildSectionHeader(
                  _getLayerTypeIcon(selectedLayer),
                  _getLayerTypeName(selectedLayer),
                ),
                const Divider(),

                // Common properties
                _buildCommonProperties(selectedLayer),
                const SizedBox(height: 16),

                // Layer-specific properties
                if (selectedLayer is TextLayer)
                  _buildTextProperties(selectedLayer)
                else if (selectedLayer is ShapeLayer)
                  _buildShapeProperties(selectedLayer)
                else if (selectedLayer is ImageLayer)
                  _buildImageProperties(selectedLayer),

                const SizedBox(height: 16),
                const Divider(),

                // Layer actions
                _buildLayerActions(selectedLayer),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCommonProperties(LayerModel layer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Position
        const Text('Position', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: _buildNumberField(
                'X',
                layer.position.dx,
                (value) {
                  layer.position = Offset(value, layer.position.dy);
                  controller.updateLayer(layer.id, layer);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildNumberField(
                'Y',
                layer.position.dy,
                (value) {
                  layer.position = Offset(layer.position.dx, value);
                  controller.updateLayer(layer.id, layer);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Size
        const Text('Size', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: _buildNumberField(
                'W',
                layer.width ?? 200,
                (value) {
                  controller.resizeLayer(
                      layer.id, Size(value, layer.height ?? 200));
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildNumberField(
                'H',
                layer.height ?? 200,
                (value) {
                  controller.resizeLayer(
                      layer.id, Size(layer.width ?? 200, value));
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Rotation
        const Text('Rotation', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: (layer.rotation * 180 / 3.14159).clamp(0, 360),
                min: 0,
                max: 360,
                divisions: 360,
                label: '${(layer.rotation * 180 / 3.14159).round()}°',
                onChanged: (value) {
                  controller.rotateLayer(layer.id, value * 3.14159 / 180);
                },
              ),
            ),
            SizedBox(
              width: 50,
              child: Text(
                '${(layer.rotation * 180 / 3.14159).round()}°',
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Opacity
        const Text('Opacity', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: layer.opacity,
                min: 0,
                max: 1,
                divisions: 100,
                label: '${(layer.opacity * 100).round()}%',
                onChanged: (value) {
                  controller.updateLayerOpacity(layer.id, value);
                },
              ),
            ),
            SizedBox(
              width: 50,
              child: Text(
                '${(layer.opacity * 100).round()}%',
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Scale
        const Text('Scale', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: layer.scale,
                min: 0.1,
                max: 3.0,
                divisions: 29,
                label: '${(layer.scale * 100).round()}%',
                onChanged: (value) {
                  controller.scaleLayer(layer.id, value);
                },
              ),
            ),
            SizedBox(
              width: 50,
              child: Text(
                '${(layer.scale * 100).round()}%',
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextProperties(TextLayer layer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const Text('Text Properties',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),

        // Text content
        TextField(
          controller: TextEditingController(text: layer.text),
          decoration: const InputDecoration(
            labelText: 'Text',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          onChanged: (value) {
            layer.text = value;
            controller.updateLayer(layer.id, layer);
          },
        ),
        const SizedBox(height: 12),

        // Font size
        const Text('Font Size', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: (layer.style.fontSize ?? 20).clamp(8, 200),
                min: 8,
                max: 200,
                divisions: 192,
                label: '${(layer.style.fontSize ?? 20).round()}',
                onChanged: (value) {
                  layer.style = layer.style.copyWith(fontSize: value);
                  controller.updateLayer(layer.id, layer);
                },
              ),
            ),
            SizedBox(
              width: 50,
              child: Text(
                '${(layer.style.fontSize ?? 20).round()}',
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Font weight
        const Text('Font Weight',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children: [
            _buildToggleButton(
              'Normal',
              layer.style.fontWeight == FontWeight.normal,
              () {
                layer.style =
                    layer.style.copyWith(fontWeight: FontWeight.normal);
                controller.updateLayer(layer.id, layer);
              },
            ),
            _buildToggleButton(
              'Bold',
              layer.style.fontWeight == FontWeight.bold,
              () {
                layer.style = layer.style.copyWith(fontWeight: FontWeight.bold);
                controller.updateLayer(layer.id, layer);
              },
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Text color
        const Text('Text Color', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children: [
            _buildColorButton(Colors.black, layer.style.color, (color) {
              layer.style = layer.style.copyWith(color: color);
              controller.updateLayer(layer.id, layer);
            }),
            _buildColorButton(Colors.white, layer.style.color, (color) {
              layer.style = layer.style.copyWith(color: color);
              controller.updateLayer(layer.id, layer);
            }),
            _buildColorButton(Colors.red, layer.style.color, (color) {
              layer.style = layer.style.copyWith(color: color);
              controller.updateLayer(layer.id, layer);
            }),
            _buildColorButton(Colors.blue, layer.style.color, (color) {
              layer.style = layer.style.copyWith(color: color);
              controller.updateLayer(layer.id, layer);
            }),
            _buildColorButton(Colors.green, layer.style.color, (color) {
              layer.style = layer.style.copyWith(color: color);
              controller.updateLayer(layer.id, layer);
            }),
            _buildColorButton(Colors.yellow, layer.style.color, (color) {
              layer.style = layer.style.copyWith(color: color);
              controller.updateLayer(layer.id, layer);
            }),
            _buildColorButton(Colors.purple, layer.style.color, (color) {
              layer.style = layer.style.copyWith(color: color);
              controller.updateLayer(layer.id, layer);
            }),
            _buildColorButton(Colors.orange, layer.style.color, (color) {
              layer.style = layer.style.copyWith(color: color);
              controller.updateLayer(layer.id, layer);
            }),
          ],
        ),
        const SizedBox(height: 12),

        // Text alignment
        const Text('Alignment', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            _buildIconButton(
                Icons.format_align_left, layer.align == TextAlign.left, () {
              layer.align = TextAlign.left;
              controller.updateLayer(layer.id, layer);
            }),
            _buildIconButton(
                Icons.format_align_center, layer.align == TextAlign.center, () {
              layer.align = TextAlign.center;
              controller.updateLayer(layer.id, layer);
            }),
            _buildIconButton(
                Icons.format_align_right, layer.align == TextAlign.right, () {
              layer.align = TextAlign.right;
              controller.updateLayer(layer.id, layer);
            }),
          ],
        ),
        const SizedBox(height: 12),

        // Advanced Text Effects
        const Divider(),
        const Text('Advanced Effects',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),

        // Letter Spacing
        const Text('Letter Spacing',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: layer.letterSpacing,
          min: -2.0,
          max: 10.0,
          divisions: 24,
          label: layer.letterSpacing.toStringAsFixed(1),
          onChanged: (value) {
            layer.letterSpacing = value;
            controller.updateLayer(layer.id, layer);
          },
        ),

        // Line Height
        const Text('Line Height',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: layer.lineHeight,
          min: 0.8,
          max: 3.0,
          divisions: 22,
          label: layer.lineHeight.toStringAsFixed(1),
          onChanged: (value) {
            layer.lineHeight = value;
            controller.updateLayer(layer.id, layer);
          },
        ),

        // Stroke Width
        const Text('Outline Width',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: layer.strokeWidth,
          min: 0.0,
          max: 10.0,
          divisions: 20,
          label: layer.strokeWidth.toStringAsFixed(1),
          onChanged: (value) {
            layer.strokeWidth = value;
            controller.updateLayer(layer.id, layer);
          },
        ),

        if (layer.strokeWidth > 0) ...[
          const Text('Outline Color',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildColorButton(Colors.black, layer.strokeColor, (c) {
                layer.strokeColor = c;
                controller.updateLayer(layer.id, layer);
              }),
              _buildColorButton(Colors.white, layer.strokeColor, (c) {
                layer.strokeColor = c;
                controller.updateLayer(layer.id, layer);
              }),
              _buildColorButton(Colors.red, layer.strokeColor, (c) {
                layer.strokeColor = c;
                controller.updateLayer(layer.id, layer);
              }),
            ],
          ),
          const SizedBox(height: 12),
        ],

        // Shadow Blur
        const Text('Shadow Blur',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: layer.shadowBlur,
          min: 0.0,
          max: 20.0,
          divisions: 20,
          label: layer.shadowBlur.toStringAsFixed(1),
          onChanged: (value) {
            layer.shadowBlur = value;
            controller.updateLayer(layer.id, layer);
          },
        ),

        if (layer.shadowBlur > 0) ...[
          const Text('Shadow Color',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildColorButton(Color.fromRGBO(0, 0, 0, 0.5), layer.shadowColor,
                  (c) {
                layer.shadowColor = c;
                controller.updateLayer(layer.id, layer);
              }),
              _buildColorButton(
                  Color.fromRGBO(158, 158, 158, 0.5), layer.shadowColor, (c) {
                layer.shadowColor = c;
                controller.updateLayer(layer.id, layer);
              }),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildShapeProperties(ShapeLayer layer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const Text('Shape Properties',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),

        // Shape color
        const Text('Fill Color', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children: [
            _buildColorButton(Colors.red, layer.color, (color) {
              layer.color = color;
              controller.updateLayer(layer.id, layer);
            }),
            _buildColorButton(Colors.blue, layer.color, (color) {
              layer.color = color;
              controller.updateLayer(layer.id, layer);
            }),
            _buildColorButton(Colors.green, layer.color, (color) {
              layer.color = color;
              controller.updateLayer(layer.id, layer);
            }),
            _buildColorButton(Colors.yellow, layer.color, (color) {
              layer.color = color;
              controller.updateLayer(layer.id, layer);
            }),
            _buildColorButton(Colors.purple, layer.color, (color) {
              layer.color = color;
              controller.updateLayer(layer.id, layer);
            }),
            _buildColorButton(Colors.orange, layer.color, (color) {
              layer.color = color;
              controller.updateLayer(layer.id, layer);
            }),
            _buildColorButton(Colors.pink, layer.color, (color) {
              layer.color = color;
              controller.updateLayer(layer.id, layer);
            }),
            _buildColorButton(Colors.teal, layer.color, (color) {
              layer.color = color;
              controller.updateLayer(layer.id, layer);
            }),
          ],
        ),
        const SizedBox(height: 12),

        // Border radius (for rectangles)
        if (layer.shapeType == 'rectangle') ...[
          const Text('Border Radius',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: (layer.borderRadius ?? 0).clamp(0, 100),
            min: 0,
            max: 100,
            divisions: 100,
            label: '${(layer.borderRadius ?? 0).round()}',
            onChanged: (value) {
              layer.borderRadius = value;
              controller.updateLayer(layer.id, layer);
            },
          ),
        ],
      ],
    );
  }

  Widget _buildImageProperties(ImageLayer layer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const Text('Image Properties',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        Text('Source: ${layer.isNetwork ? "Network" : "Local"}'),
        const SizedBox(height: 8),
        Text(
          layer.source,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),

        // Image Filters
        const Divider(),
        const Text('Image Filters',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),

        // Brightness
        const Text('Brightness', style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: layer.brightness,
          min: -1.0,
          max: 1.0,
          divisions: 20,
          label: layer.brightness.toStringAsFixed(1),
          onChanged: (value) {
            layer.brightness = value;
            controller.updateLayer(layer.id, layer);
          },
        ),

        // Contrast
        const Text('Contrast', style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: layer.contrast,
          min: 0.0,
          max: 2.0,
          divisions: 20,
          label: layer.contrast.toStringAsFixed(1),
          onChanged: (value) {
            layer.contrast = value;
            controller.updateLayer(layer.id, layer);
          },
        ),

        // Saturation
        const Text('Saturation', style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: layer.saturation,
          min: 0.0,
          max: 2.0,
          divisions: 20,
          label: layer.saturation.toStringAsFixed(1),
          onChanged: (value) {
            layer.saturation = value;
            controller.updateLayer(layer.id, layer);
          },
        ),

        // Sepia
        const Text('Sepia', style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: layer.sepia,
          min: 0.0,
          max: 1.0,
          divisions: 10,
          label: layer.sepia.toStringAsFixed(1),
          onChanged: (value) {
            layer.sepia = value;
            controller.updateLayer(layer.id, layer);
          },
        ),
      ],
    );
  }

  Widget _buildLayerActions(LayerModel layer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Layer Actions',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => controller.duplicateLayer(layer.id),
                icon: const Icon(Icons.content_copy, size: 18),
                label: const Text('Duplicate'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => controller.removeLayer(layer.id),
                icon: const Icon(Icons.delete, size: 18),
                label: const Text('Delete'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => controller.bringToFront(layer.id),
                icon: const Icon(Icons.flip_to_front, size: 18),
                label: const Text('To Front'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => controller.sendToBack(layer.id),
                icon: const Icon(Icons.flip_to_back, size: 18),
                label: const Text('To Back'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Lock Layer'),
          value: layer.isLocked,
          onChanged: (value) => controller.lockLayer(layer.id, value),
          dense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildNumberField(
      String label, double value, Function(double) onChanged) {
    return TextField(
      controller: TextEditingController(text: value.round().toString()),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      keyboardType: TextInputType.number,
      onChanged: (text) {
        final newValue = double.tryParse(text);
        if (newValue != null) {
          onChanged(newValue);
        }
      },
    );
  }

  Widget _buildToggleButton(String label, bool isSelected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
    );
  }

  Widget _buildColorButton(
      Color color, Color? currentColor, Function(Color) onTap) {
    final isSelected = currentColor == color;
    return GestureDetector(
      onTap: () => onTap(color),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: isSelected ? 3 : 1,
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, bool isSelected, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onTap,
      color: isSelected ? Colors.blue : Colors.grey,
      style: IconButton.styleFrom(
        backgroundColor: isSelected ? Color.fromRGBO(0, 0, 255, 0.1) : null,
      ),
    );
  }

  IconData _getLayerTypeIcon(LayerModel layer) {
    if (layer is TextLayer) return Icons.text_fields;
    if (layer is ImageLayer) return Icons.image;
    if (layer is ShapeLayer) return Icons.category;
    return Icons.layers;
  }

  String _getLayerTypeName(LayerModel layer) {
    if (layer is TextLayer) return 'Text Layer';
    if (layer is ImageLayer) return 'Image Layer';
    if (layer is ShapeLayer) return 'Shape Layer';
    return 'Layer';
  }
}
