import '../services/platform_service.dart';

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/models.dart';

class LayerWidget extends StatefulWidget {
  final LayerModel layer;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final Function(Size)? onResize;
  final Function(double)? onRotate;
  final Function(Offset)? onMove;
  final VoidCallback? onInteractionStart;
  final VoidCallback? onInteractionEnd;

  const LayerWidget({
    super.key,
    required this.layer,
    this.onTap,
    this.onDoubleTap,
    this.onResize,
    this.onRotate,
    this.onMove,
    this.onInteractionStart,
    this.onInteractionEnd,
  });

  @override
  State<LayerWidget> createState() => _LayerWidgetState();
}

class _LayerWidgetState extends State<LayerWidget> {
  Size? _interactionSize;
  double? _interactionRotation;

  Widget _buildContent(Size size) {
    if (widget.layer is TextLayer) {
      final textLayer = widget.layer as TextLayer;
      // If stroke is active, we need to render fill on top
      if (textLayer.strokeWidth > 0) {
        return Stack(
          children: [
            Text(
              textLayer.text,
              style: textLayer.style.copyWith(
                letterSpacing: textLayer.letterSpacing,
                height: textLayer.lineHeight,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = textLayer.strokeWidth
                  ..color = textLayer.strokeColor,
              ),
              textAlign: textLayer.align,
            ),
            Text(
              textLayer.text,
              style: textLayer.style.copyWith(
                letterSpacing: textLayer.letterSpacing,
                height: textLayer.lineHeight,
                shadows: [
                  Shadow(
                    color: textLayer.shadowColor,
                    blurRadius: textLayer.shadowBlur,
                    offset: textLayer.shadowOffset,
                  ),
                ],
              ),
              textAlign: textLayer.align,
            ),
          ],
        );
      }

      return Text(
        textLayer.text,
        style: textLayer.style.copyWith(
          letterSpacing: textLayer.letterSpacing,
          height: textLayer.lineHeight,
          shadows: [
            Shadow(
              color: textLayer.shadowColor,
              blurRadius: textLayer.shadowBlur,
              offset: textLayer.shadowOffset,
            ),
          ],
        ),
        textAlign: textLayer.align,
      );
    } else if (widget.layer is ImageLayer) {
      final imageLayer = widget.layer as ImageLayer;

      // Determine image provider based on source
      ImageProvider imageProvider;
      if (imageLayer.bytes != null) {
        imageProvider = MemoryImage(imageLayer.bytes!);
      } else if (imageLayer.isNetwork ||
          imageLayer.source.startsWith('http') ||
          imageLayer.source.startsWith('https') ||
          imageLayer.source.startsWith('blob:')) {
        imageProvider = NetworkImage(imageLayer.source);
      } else if (imageLayer.source.startsWith('assets/')) {
        imageProvider = AssetImage(imageLayer.source);
      } else {
        // Assume it's a file path if it's not network and not an asset
        imageProvider =
            PlatformService.instance.getLocalImageProvider(imageLayer.source);
      }

      return SizedBox(
        width: size.width,
        height: size.height,
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix([
            // Brightness
            1, 0, 0, 0, imageLayer.brightness * 255,
            0, 1, 0, 0, imageLayer.brightness * 255,
            0, 0, 1, 0, imageLayer.brightness * 255,
            0, 0, 0, 1, 0,
          ]),
          child: ColorFiltered(
            colorFilter: ColorFilter.matrix([
              // Contrast
              imageLayer.contrast, 0, 0, 0, 128 * (1 - imageLayer.contrast),
              0, imageLayer.contrast, 0, 0, 128 * (1 - imageLayer.contrast),
              0, 0, imageLayer.contrast, 0, 128 * (1 - imageLayer.contrast),
              0, 0, 0, 1, 0,
            ]),
            child: ColorFiltered(
              colorFilter: ColorFilter.matrix([
                // Saturation
                0.2126 * (1 - imageLayer.saturation) + imageLayer.saturation,
                0.7152 * (1 - imageLayer.saturation),
                0.0722 * (1 - imageLayer.saturation),
                0,
                0,
                0.2126 * (1 - imageLayer.saturation),
                0.7152 * (1 - imageLayer.saturation) + imageLayer.saturation,
                0.0722 * (1 - imageLayer.saturation),
                0,
                0,
                0.2126 * (1 - imageLayer.saturation),
                0.7152 * (1 - imageLayer.saturation),
                0.0722 * (1 - imageLayer.saturation) + imageLayer.saturation,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
              ]),
              child: ColorFiltered(
                colorFilter: ColorFilter.matrix([
                  // Sepia
                  0.393 + 0.607 * (1 - imageLayer.sepia),
                  0.769 - 0.769 * (1 - imageLayer.sepia),
                  0.189 - 0.189 * (1 - imageLayer.sepia),
                  0,
                  0,
                  0.349 - 0.349 * (1 - imageLayer.sepia),
                  0.686 + 0.314 * (1 - imageLayer.sepia),
                  0.168 - 0.168 * (1 - imageLayer.sepia),
                  0,
                  0,
                  0.272 - 0.272 * (1 - imageLayer.sepia),
                  0.534 - 0.534 * (1 - imageLayer.sepia),
                  0.131 + 0.869 * (1 - imageLayer.sepia),
                  0,
                  0,
                  0, 0, 0, 1, 0,
                ]),
                child: Image(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.broken_image,
                              size: 40, color: Colors.grey),
                          const SizedBox(height: 4),
                          Text(
                            'Error loading image',
                            style: TextStyle(
                                fontSize: 10, color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    } else if (widget.layer is ShapeLayer) {
      final shapeLayer = widget.layer as ShapeLayer;
      return Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: shapeLayer.color,
          shape: shapeLayer.shapeType == 'circle'
              ? BoxShape.circle
              : BoxShape.rectangle,
          borderRadius: shapeLayer.shapeType == 'rectangle' &&
                  shapeLayer.borderRadius != null
              ? BorderRadius.circular(shapeLayer.borderRadius!)
              : null,
        ),
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    final width = _interactionSize?.width ?? widget.layer.width ?? 200.0;
    final height = _interactionSize?.height ?? widget.layer.height ?? 200.0;
    final rotation = _interactionRotation ?? widget.layer.rotation;
    final size = Size(width, height);

    return Positioned(
      left: widget.layer.position.dx,
      top: widget.layer.position.dy,
      child: Opacity(
        opacity: widget.layer.opacity,
        child: Transform.rotate(
          angle: rotation,
          child: Transform.scale(
            scale: widget.layer.scale,
            child: GestureDetector(
              onTapDown: (_) {
                if (widget.onInteractionStart != null) {
                  widget.onInteractionStart!();
                }
              },
              onTapUp: (_) {
                if (widget.onInteractionEnd != null) {
                  widget.onInteractionEnd!();
                }
              },
              onTapCancel: () {
                if (widget.onInteractionEnd != null) {
                  widget.onInteractionEnd!();
                }
              },
              onTap: widget.layer.isLocked ? null : widget.onTap,
              onDoubleTap: widget.layer.isLocked ? null : widget.onDoubleTap,
              onPanStart: (_) {
                if (widget.onInteractionStart != null) {
                  widget.onInteractionStart!();
                }
              },
              onPanEnd: (_) {
                if (widget.onInteractionEnd != null) {
                  widget.onInteractionEnd!();
                }
              },
              onPanUpdate: widget.layer.isLocked
                  ? null
                  : (details) {
                      if (widget.onMove != null) {
                        widget.onMove!(details.delta);
                      }
                    },
              child: Stack(
                children: [
                  // Main content
                  _buildContent(size),

                  // Selection handles
                  if (widget.layer.isSelected && !widget.layer.isLocked)
                    _buildSelectionHandles(size, rotation),

                  // Lock indicator
                  if (widget.layer.isLocked)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.lock,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionHandles(Size size, double rotation) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          // Selection border
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
              ),
            ),
          ),

          // Corner handles (resize)
          _buildHandle(Alignment.topLeft, _HandleType.resize, size, rotation),
          _buildHandle(Alignment.topRight, _HandleType.resize, size, rotation),
          _buildHandle(
              Alignment.bottomLeft, _HandleType.resize, size, rotation),
          _buildHandle(
              Alignment.bottomRight, _HandleType.resize, size, rotation),

          // Edge handles (resize)
          _buildHandle(Alignment.topCenter, _HandleType.resize, size, rotation),
          _buildHandle(
              Alignment.bottomCenter, _HandleType.resize, size, rotation),
          _buildHandle(
              Alignment.centerLeft, _HandleType.resize, size, rotation),
          _buildHandle(
              Alignment.centerRight, _HandleType.resize, size, rotation),

          // Rotation handle
          _buildHandle(Alignment.topCenter, _HandleType.rotate, size, rotation,
              offset: const Offset(0, -30)),
        ],
      ),
    );
  }

  Widget _buildHandle(
      Alignment alignment, _HandleType type, Size size, double rotation,
      {Offset offset = Offset.zero}) {
    return Align(
      alignment: alignment,
      child: Transform.translate(
        offset: offset,
        child: GestureDetector(
          onPanStart: (_) {
            if (widget.onInteractionStart != null) {
              widget.onInteractionStart!();
            }
          },
          onPanUpdate: (details) {
            if (type == _HandleType.resize) {
              _handleResize(alignment, details.delta, size);
            } else {
              _handleRotate(details.delta, rotation);
            }
          },
          onPanEnd: (_) {
            if (widget.onInteractionEnd != null) {
              widget.onInteractionEnd!();
            }
            if (type == _HandleType.resize && widget.onResize != null) {
              widget.onResize!(_interactionSize ?? size);
            } else if (type == _HandleType.rotate && widget.onRotate != null) {
              widget.onRotate!(_interactionRotation ?? rotation);
            }

            // Clear interaction state to revert to model state
            setState(() {
              _interactionSize = null;
              _interactionRotation = null;
            });
          },
          child: Container(
            // Transparent hit area for larger touch target
            width: 48,
            height: 48,
            color: Colors.transparent,
            alignment: Alignment.center,
            child: Container(
              width: type == _HandleType.rotate ? 36 : 24,
              height: type == _HandleType.rotate ? 36 : 24,
              decoration: BoxDecoration(
                color: type == _HandleType.rotate ? Colors.green : Colors.blue,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.3),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: type == _HandleType.rotate
                  ? const Icon(Icons.rotate_right,
                      size: 20, color: Colors.white)
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  void _handleResize(Alignment alignment, Offset delta, Size currentSize) {
    setState(() {
      double newWidth = _interactionSize?.width ?? currentSize.width;
      double newHeight = _interactionSize?.height ?? currentSize.height;

      // Adjust size based on handle position
      if (alignment == Alignment.topLeft ||
          alignment == Alignment.centerLeft ||
          alignment == Alignment.bottomLeft) {
        newWidth = math.max(20, newWidth - delta.dx);
      }
      if (alignment == Alignment.topRight ||
          alignment == Alignment.centerRight ||
          alignment == Alignment.bottomRight) {
        newWidth = math.max(20, newWidth + delta.dx);
      }
      if (alignment == Alignment.topLeft ||
          alignment == Alignment.topCenter ||
          alignment == Alignment.topRight) {
        newHeight = math.max(20, newHeight - delta.dy);
      }
      if (alignment == Alignment.bottomLeft ||
          alignment == Alignment.bottomCenter ||
          alignment == Alignment.bottomRight) {
        newHeight = math.max(20, newHeight + delta.dy);
      }

      _interactionSize = Size(newWidth, newHeight);
    });
  }

  void _handleRotate(Offset delta, double currentRotation) {
    setState(() {
      // Simple rotation based on horizontal drag
      _interactionRotation =
          (_interactionRotation ?? currentRotation) + (delta.dx * 0.01);
    });
  }
}

enum _HandleType { resize, rotate }
