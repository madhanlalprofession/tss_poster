import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../core/controller.dart';
import '../core/models.dart';
import 'layer_widget.dart';

/// The canvas widget where the poster layers are rendered and interacted with.
class PosterCanvas extends StatefulWidget {
  final PosterController controller;
  final Function(String, String)? onEdit;

  const PosterCanvas({
    super.key,
    required this.controller,
    this.onEdit,
  });

  @override
  State<PosterCanvas> createState() => _PosterCanvasState();
}

class _PosterCanvasState extends State<PosterCanvas> {
  bool _isInteracting = false;
  final TransformationController _transformationController =
      TransformationController();
  bool _initialFitDone = false;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _fitToScreen(BoxConstraints constraints, Size posterSize) {
    if (_initialFitDone) return;

    final double scaleX = constraints.maxWidth / posterSize.width;
    final double scaleY = constraints.maxHeight / posterSize.height;
    final double scale = math.min(scaleX, scaleY) * 0.9; // 90% fit

    final double offsetX =
        (constraints.maxWidth - posterSize.width * scale) / 2;
    final double offsetY =
        (constraints.maxHeight - posterSize.height * scale) / 2;

    _transformationController.value = Matrix4.fromList([
      scale,
      0.0,
      0.0,
      0.0,
      0.0,
      scale,
      0.0,
      0.0,
      0.0,
      0.0,
      scale,
      0.0,
      offsetX,
      offsetY,
      0.0,
      1.0,
    ]);

    _initialFitDone = true;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate initial fit on first build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _fitToScreen(constraints, widget.controller.poster.size);
        });

        return AnimatedBuilder(
          animation: widget.controller,
          builder: (context, child) {
            final poster = widget.controller.poster;
            return InteractiveViewer(
              transformationController: _transformationController,
              boundaryMargin: const EdgeInsets.all(500),
              minScale: 0.1,
              maxScale: 4.0,
              constrained: false, // Allow poster to be its full size
              panEnabled: !_isInteracting,
              scaleEnabled: !_isInteracting,
              child: RepaintBoundary(
                key: widget.controller.repaintBoundaryKey,
                child: Container(
                  width: poster.size.width,
                  height: poster.size.height,
                  decoration: BoxDecoration(
                    color: poster.backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      if (poster.backgroundImage != null)
                        Positioned.fill(
                          child: Image.network(
                            poster.backgroundImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.broken_image,
                                    size: 50, color: Colors.grey),
                              );
                            },
                          ),
                        ),
                      ...poster.layers.map((layer) {
                        return LayerWidget(
                          layer: layer,
                          onTap: () => widget.controller.selectLayer(layer.id),
                          onDoubleTap: () {
                            if (layer is TextLayer && widget.onEdit != null) {
                              widget.onEdit!(layer.id, layer.text);
                            }
                          },
                          onResize: (size) {
                            widget.controller.resizeLayer(layer.id, size);
                          },
                          onRotate: (rotation) {
                            widget.controller.rotateLayer(layer.id, rotation);
                          },
                          onMove: (delta) {
                            widget.controller.moveLayer(delta);
                          },
                          onInteractionStart: () {
                            setState(() => _isInteracting = true);
                          },
                          onInteractionEnd: () {
                            setState(() => _isInteracting = false);
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
