import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

/// Enum representing the type of layer.
enum LayerType { text, image, shape }

/// Base class for all layers in the poster.
abstract class LayerModel {
  /// Unique identifier for the layer.
  String id;

  /// The type of the layer.
  LayerType type;

  /// The position of the layer on the canvas.
  Offset position;

  /// The rotation of the layer in radians.
  double rotation;

  /// The scale factor of the layer.
  double scale;

  /// Whether the layer is currently selected.
  bool isSelected;

  /// Opacity of the layer (0.0 to 1.0).
  double opacity;

  /// Whether the layer is locked (prevents editing).
  bool isLocked;

  /// Explicit width of the layer (null means auto-size).
  double? width;

  /// Explicit height of the layer (null means auto-size).
  double? height;

  LayerModel({
    String? id,
    required this.type,
    this.position = const Offset(0, 0),
    this.rotation = 0.0,
    this.scale = 1.0,
    this.isSelected = false,
    this.opacity = 1.0,
    this.isLocked = false,
    this.width,
    this.height,
  }) : id = id ?? Uuid().v4();

  Map<String, dynamic> toJson();

  static LayerModel fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    switch (type) {
      case 'text':
        return TextLayer.fromJson(json);
      case 'image':
        return ImageLayer.fromJson(json);
      case 'shape':
        return ShapeLayer.fromJson(json);
      default:
        throw Exception('Unknown layer type: $type');
    }
  }
}

/// A layer representing text content.
class TextLayer extends LayerModel {
  /// The text content.
  String text;

  /// The style of the text.
  TextStyle style;

  /// The alignment of the text.
  TextAlign align;

  /// Letter spacing.
  double letterSpacing;

  /// Line height.
  double lineHeight;

  /// Shadow color.
  Color shadowColor;

  /// Shadow blur radius.
  double shadowBlur;

  /// Shadow offset.
  Offset shadowOffset;

  /// Stroke width (0 for no stroke).
  double strokeWidth;

  /// Stroke color.
  Color strokeColor;

  TextLayer({
    super.id,
    required this.text,
    this.style = const TextStyle(fontSize: 20, color: Colors.black),
    this.align = TextAlign.left,
    this.letterSpacing = 0.0,
    this.lineHeight = 1.2,
    this.shadowColor = Colors.transparent,
    this.shadowBlur = 0.0,
    this.shadowOffset = const Offset(2, 2),
    this.strokeWidth = 0.0,
    this.strokeColor = Colors.black,
    super.position,
    super.rotation,
    super.scale,
  }) : super(type: LayerType.text);

  factory TextLayer.fromJson(Map<String, dynamic> json) {
    final styleJson = json['style'] as Map<String, dynamic>;
    final layer = TextLayer(
      id: json['id'],
      text: json['text'],
      style: TextStyle(
        fontSize: styleJson['fontSize'],
        color: styleJson['color'] is String
            ? Color(int.parse(styleJson['color'], radix: 16))
            : Color(styleJson['color']),
        fontWeight: styleJson['fontWeight'] != null
            ? FontWeight.values[styleJson['fontWeight']]
            : FontWeight.normal,
        fontFamily: styleJson['fontFamily'],
      ),
      align: TextAlign.values[json['align'] ?? 0],
      position: Offset(json['dx'] ?? 0, json['dy'] ?? 0),
      rotation: json['rotation'] ?? 0.0,
      scale: json['scale'] ?? 1.0,
    );
    layer.opacity = json['opacity'] ?? 1.0;
    layer.isLocked = json['isLocked'] ?? false;
    layer.width = json['width'];
    layer.height = json['height'];

    // Load new properties with defaults
    layer.letterSpacing = json['letterSpacing'] ?? 0.0;
    layer.lineHeight = json['lineHeight'] ?? 1.2;
    layer.shadowColor = json['shadowColor'] != null
        ? Color(int.parse(json['shadowColor'], radix: 16))
        : Colors.transparent;
    layer.shadowBlur = json['shadowBlur'] ?? 0.0;
    layer.shadowOffset = json['shadowOffsetX'] != null
        ? Offset(json['shadowOffsetX'], json['shadowOffsetY'])
        : const Offset(2, 2);
    layer.strokeWidth = json['strokeWidth'] ?? 0.0;
    layer.strokeColor = json['strokeColor'] != null
        ? Color(int.parse(json['strokeColor'], radix: 16))
        : Colors.black;

    return layer;
  }

  TextLayer copyWith({
    String? text,
    TextStyle? style,
    TextAlign? align,
    double? letterSpacing,
    double? lineHeight,
    Color? shadowColor,
    double? shadowBlur,
    Offset? shadowOffset,
    double? strokeWidth,
    Color? strokeColor,
    Offset? position,
    double? rotation,
    double? scale,
    double? opacity,
    bool? isLocked,
    double? width,
    double? height,
  }) {
    final layer = TextLayer(
      id: id,
      text: text ?? this.text,
      style: style ?? this.style,
      align: align ?? this.align,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      lineHeight: lineHeight ?? this.lineHeight,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowBlur: shadowBlur ?? this.shadowBlur,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeColor: strokeColor ?? this.strokeColor,
      position: position ?? this.position,
      rotation: rotation ?? this.rotation,
      scale: scale ?? this.scale,
    );
    layer.opacity = opacity ?? this.opacity;
    layer.isLocked = isLocked ?? this.isLocked;
    layer.width = width ?? this.width;
    layer.height = height ?? this.height;
    return layer;
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': 'text',
        'text': text,
        'style': {
          'fontSize': style.fontSize,
          // ignore: deprecated_member_use
          'color': style.color?.value.toRadixString(16).padLeft(8, '0'),
          'fontWeight': style.fontWeight?.index,
          'fontFamily': style.fontFamily,
        },
        'align': align.index,
        'dx': position.dx,
        'dy': position.dy,
        'rotation': rotation,
        'scale': scale,
        'opacity': opacity,
        'isLocked': isLocked,
        'width': width,
        'height': height,
        'letterSpacing': letterSpacing,
        'lineHeight': lineHeight,
        // ignore: deprecated_member_use
        'shadowColor': shadowColor.value.toRadixString(16).padLeft(8, '0'),
        'shadowBlur': shadowBlur,
        'shadowOffsetX': shadowOffset.dx,
        'shadowOffsetY': shadowOffset.dy,
        'strokeWidth': strokeWidth,
        // ignore: deprecated_member_use
        'strokeColor': strokeColor.value.toRadixString(16).padLeft(8, '0'),
      };
}

/// A layer representing an image.
class ImageLayer extends LayerModel {
  /// The source of the image (path or URL).
  String source; // Asset path, file path, or URL

  /// Whether the image source is a network URL.
  bool isNetwork;

  /// Brightness adjustment (-1.0 to 1.0).
  double brightness;

  /// Contrast adjustment (0.0 to 2.0).
  double contrast;

  /// Saturation adjustment (0.0 to 2.0).
  double saturation;

  /// Sepia adjustment (0.0 to 1.0).
  double sepia;

  /// Blur radius (0.0 to 20.0).
  double blur;

  /// Raw image bytes (optional, takes precedence over source).
  Uint8List? bytes;

  ImageLayer({
    super.id,
    required this.source,
    this.bytes,
    this.isNetwork = false,
    this.brightness = 0.0,
    this.contrast = 1.0,
    this.saturation = 1.0,
    this.sepia = 0.0,
    this.blur = 0.0,
    super.position,
    super.rotation,
    super.scale,
  }) : super(type: LayerType.image);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': 'image',
        'source': source,
        'isNetwork': isNetwork,
        'dx': position.dx,
        'dy': position.dy,
        'rotation': rotation,
        'scale': scale,
        'opacity': opacity,
        'isLocked': isLocked,
        'width': width,
        'height': height,
        'brightness': brightness,
        'contrast': contrast,
        'saturation': saturation,
        'sepia': sepia,
        'blur': blur,
      };

  factory ImageLayer.fromJson(Map<String, dynamic> json) {
    final layer = ImageLayer(
      id: json['id'],
      source: json['source'],
      isNetwork: json['isNetwork'],
      position: Offset(json['dx'], json['dy']),
      rotation: json['rotation'],
      scale: json['scale'],
    );
    layer.opacity = json['opacity'] ?? 1.0;
    layer.isLocked = json['isLocked'] ?? false;
    layer.width = json['width'];
    layer.height = json['height'];

    // Load filter properties
    layer.brightness = json['brightness'] ?? 0.0;
    layer.contrast = json['contrast'] ?? 1.0;
    layer.saturation = json['saturation'] ?? 1.0;
    layer.sepia = json['sepia'] ?? 0.0;
    layer.blur = json['blur'] ?? 0.0;

    return layer;
  }
}

/// A layer representing a geometric shape.
class ShapeLayer extends LayerModel {
  /// The type of shape ('rectangle', 'circle').
  String shapeType; // 'rectangle', 'circle'

  /// The fill color of the shape.
  Color color;

  /// The border radius (for rectangles).
  double? borderRadius;

  ShapeLayer({
    super.id,
    required this.shapeType,
    this.color = Colors.blue,
    this.borderRadius,
    super.width,
    super.height,
    super.position,
    super.rotation,
    super.scale,
  }) : super(type: LayerType.shape);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'type': 'shape',
        'shapeType': shapeType,
        // ignore: deprecated_member_use
        'color': color.value.toRadixString(16).padLeft(8, '0'),
        'borderRadius': borderRadius,
        'dx': position.dx,
        'dy': position.dy,
        'rotation': rotation,
        'scale': scale,
        'opacity': opacity,
        'isLocked': isLocked,
        'width': width,
        'height': height,
      };

  factory ShapeLayer.fromJson(Map<String, dynamic> json) {
    final layer = ShapeLayer(
      id: json['id'],
      shapeType: json['shapeType'],
      color: json['color'] is String
          ? Color(int.parse(json['color'], radix: 16))
          : Color(json['color']),
      borderRadius: json['borderRadius'],
      width: json['width'],
      height: json['height'],
      position: Offset(json['dx'], json['dy']),
      rotation: json['rotation'],
      scale: json['scale'],
    );
    layer.opacity = json['opacity'] ?? 1.0;
    layer.isLocked = json['isLocked'] ?? false;
    return layer;
  }
}

/// Represents the entire poster, containing layers and background settings.
class PosterModel {
  /// Unique identifier for the poster.
  String id;

  /// List of layers in the poster.
  List<LayerModel> layers;

  /// Background color of the poster.
  Color backgroundColor;

  /// Optional background image path.
  String? backgroundImage;

  /// Size of the poster.
  Size size;

  PosterModel({
    String? id,
    List<LayerModel>? layers,
    this.backgroundColor = Colors.white,
    this.backgroundImage,
    this.size = const Size(1080, 1920), // Default vertical poster
  })  : id = id ?? const Uuid().v4(),
        layers = layers ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'layers': layers.map((l) => l.toJson()).toList(),
        'backgroundColor':
            // ignore: deprecated_member_use
            backgroundColor.value.toRadixString(16).padLeft(8, '0'),
        'backgroundImage': backgroundImage,
        'width': size.width,
        'height': size.height,
      };

  factory PosterModel.fromJson(Map<String, dynamic> json) {
    return PosterModel(
      id: json['id'],
      layers:
          (json['layers'] as List).map((l) => LayerModel.fromJson(l)).toList(),
      backgroundColor: json['backgroundColor'] is String
          ? Color(int.parse(json['backgroundColor'], radix: 16))
          : Color(json['backgroundColor']),
      backgroundImage: json['backgroundImage'],
      size: Size(json['width'], json['height']),
    );
  }
}
