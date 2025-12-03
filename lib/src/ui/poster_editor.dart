import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../core/controller.dart';
import '../core/models.dart';
import '../services/export_service.dart';
import 'canvas.dart';
import 'toolbar.dart';
import 'property_panel.dart';

// ignore_for_file: deprecated_member_use

/// The main editor widget for creating and modifying posters.
class PosterEditor extends StatefulWidget {
  /// Optional initial poster model to load into the editor.
  final PosterModel? initialPoster;
  final PosterController? controller;
  final bool showText;
  final bool showImage;
  final bool showShape;
  final bool showExport;
  final Function(Uint8List)? onExport;

  const PosterEditor({
    super.key,
    this.initialPoster,
    this.controller,
    this.showText = true,
    this.showImage = true,
    this.showShape = true,
    this.showExport = true,
    this.onExport,
  });

  @override
  State<PosterEditor> createState() => _PosterEditorState();
}

class _PosterEditorState extends State<PosterEditor> {
  late PosterController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? PosterController(poster: widget.initialPoster);
  }

  Future<void> _showTextEditorDialog(String layerId, String currentText) async {
    final textController = TextEditingController(text: currentText);
    final focusNode = FocusNode();

    // Ensure focus is requested after the dialog is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Text'),
        content: TextField(
          controller: textController,
          focusNode: focusNode,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter text',
            border: OutlineInputBorder(),
          ),
          maxLines: null,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, textController.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    textController.dispose();
    focusNode.dispose();

    if (result != null && mounted) {
      final layer = _controller.poster.layers.firstWhere(
        (l) => l.id == layerId,
        orElse: () => throw Exception('Layer not found'),
      );
      if (layer is TextLayer) {
        _controller.updateLayer(
          layerId,
          layer.copyWith(text: result),
        );
      }
    }
  }

  Future<void> _showExportDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const _ExportDialog(),
    );

    if (result != null && mounted) {
      _exportPoster(
        filename: result['filename'] as String,
        format: result['format'] as ExportFormat,
        quality: result['quality'] as ExportQuality,
      );
    }
  }

  Future<void> _exportPoster({
    required String filename,
    required ExportFormat format,
    required ExportQuality quality,
  }) async {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      final image =
          await _controller.exportAsPNG(pixelRatio: quality.pixelRatio);

      if (image != null) {
        if (widget.onExport != null) {
          final byteData =
              await image.toByteData(format: ui.ImageByteFormat.png);
          if (byteData != null) {
            widget.onExport!(byteData.buffer.asUint8List());
          }
        }

        final result = await ExportService.saveImageToDevice(
          image: image,
          filename: filename,
          format: format,
          quality: quality,
        );

        if (mounted) {
          Navigator.pop(context);

          if (result.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result.message),
                backgroundColor: Colors.green,
                action: result.filePath != null
                    ? SnackBarAction(
                        label: 'OK',
                        textColor: Colors.white,
                        onPressed: () {},
                      )
                    : null,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to export image'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showPropertiesPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: PropertyPanel(controller: _controller),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Poster Creator'),
        actions: [
          if (!isMobile && widget.showExport)
            IconButton(
              icon: const Icon(Icons.download),
              tooltip: 'Export Poster',
              onPressed: _showExportDialog,
            ),
          if (isMobile)
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.showExport)
                          ListTile(
                            leading: const Icon(Icons.download),
                            title: const Text('Export Poster'),
                            onTap: () {
                              Navigator.pop(context);
                              _showExportDialog();
                            },
                          ),
                        ListTile(
                          leading: const Icon(Icons.settings),
                          title: const Text('Properties'),
                          onTap: () {
                            Navigator.pop(context);
                            _showPropertiesPanel();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      // Drawer for mobile property panel
      endDrawer: isMobile
          ? Drawer(
              child: PropertyPanel(controller: _controller),
            )
          : null,
      body: Row(
        children: [
          Expanded(
            child: Container(
              margin: isMobile ? EdgeInsets.zero : const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color:
                    Colors.grey.shade200, // Light grey background for workspace
              ),
              child: PosterCanvas(
                controller: _controller,
                onEdit: _showTextEditorDialog,
              ),
            ),
          ),
          if (!isMobile)
            SizedBox(
              width: 80,
              child: Toolbar(
                controller: _controller,
                showText: widget.showText,
                showImage: widget.showImage,
                showShape: widget.showShape,
              ),
            ),
          if (!isMobile)
            SizedBox(
              width: 300,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: PropertyPanel(controller: _controller),
              ),
            ),
        ],
      ),
      bottomNavigationBar: isMobile
          ? Toolbar(
              controller: _controller,
              showText: widget.showText,
              showImage: widget.showImage,
              showShape: widget.showShape,
              axis: Axis.horizontal,
            )
          : null,
    );
  }
}

class _ExportDialog extends StatefulWidget {
  const _ExportDialog();

  @override
  State<_ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<_ExportDialog> {
  final _filenameController = TextEditingController(text: 'poster');
  ExportFormat _format = ExportFormat.png;
  ExportQuality _quality = ExportQuality.high;

  @override
  void dispose() {
    _filenameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return AlertDialog(
      title: const Text('Export Poster'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _filenameController,
              decoration: const InputDecoration(
                labelText: 'Filename',
                hintText: 'Enter filename',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Format:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            if (isMobile)
              Column(
                children: [
                  RadioListTile<ExportFormat>(
                    title: const Text('PNG'),
                    value: ExportFormat.png,
                    groupValue: _format,
                    onChanged: (value) => setState(() => _format = value!),
                  ),
                  RadioListTile<ExportFormat>(
                    title: const Text('JPG'),
                    value: ExportFormat.jpg,
                    groupValue: _format,
                    onChanged: (value) => setState(() => _format = value!),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Radio<ExportFormat>(
                          value: ExportFormat.png,
                          groupValue: _format,
                          onChanged: (value) =>
                              setState(() => _format = value!),
                        ),
                        const Text('PNG'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Radio<ExportFormat>(
                          value: ExportFormat.jpg,
                          groupValue: _format,
                          onChanged: (value) =>
                              setState(() => _format = value!),
                        ),
                        const Text('JPG'),
                      ],
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),
            const Text('Quality:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<ExportQuality>(
              value: _quality,
              isExpanded: true,
              items: ExportQuality.values.map((quality) {
                return DropdownMenuItem(
                  value: quality,
                  child: Text(quality.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) => setState(() => _quality = value!),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'filename': _filenameController.text,
              'format': _format,
              'quality': _quality,
            });
          },
          child: const Text('Export'),
        ),
      ],
    );
  }
}
