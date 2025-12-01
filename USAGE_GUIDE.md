# TSS Poster - Complete Usage Guide

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  tss_poster: ^1.1.0
```

Run:
```bash
flutter pub get
```

## Basic Usage

### 1. Simple Poster Editor

```dart
import 'package:flutter/material.dart';
import 'package:tss_poster/tss_poster.dart';

class MyPosterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PosterEditor(
          initialPoster: PosterModel(
            backgroundColor: Colors.white,
            size: Size(1080, 1920), // Instagram story size
          ),
        ),
      ),
    );
  }
}
```

### 2. Using Templates

```dart
import 'package:tss_poster/tss_poster.dart';

class TemplateExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PosterEditor(
      initialPoster: TemplateFactory.fitnessPost(),
      // Or use other templates:
      // TemplateFactory.musicFestival()
      // TemplateFactory.productLaunch()
      // TemplateFactory.restaurantMenu()
      // TemplateFactory.realEstate()
      // TemplateFactory.businessCard()
      // TemplateFactory.quotePost()
      // TemplateFactory.flashSale()
      // TemplateFactory.weddingInvitation()
      // TemplateFactory.rockConcert()
    );
  }
}
```

## Advanced Features

### 3. Creating Custom Layers

#### Text Layer with Advanced Typography
```dart
final textLayer = TextLayer(
  text: 'Hello World',
  style: TextStyle(
    fontSize: 48,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  ),
  align: TextAlign.center,
  position: Offset(100, 100),
  
  // Advanced typography (v1.1.0+)
  letterSpacing: 2.0,        // Character spacing
  lineHeight: 1.5,           // Line spacing
  shadowColor: Colors.black.withOpacity(0.5),
  shadowBlur: 10.0,          // Shadow blur radius
  shadowOffset: Offset(4, 4), // Shadow position
  strokeWidth: 3.0,          // Outline width
  strokeColor: Colors.black, // Outline color
);
```

#### Image Layer with Filters
```dart
final imageLayer = ImageLayer(
  source: 'assets/photo.jpg',
  isNetwork: false, // Set true for network images
  position: Offset(0, 0),
  
  // Image filters (v1.1.0+)
  brightness: 0.2,    // -1.0 to 1.0
  contrast: 1.3,      // 0.0 to 2.0
  saturation: 1.5,    // 0.0 to 2.0 (0=grayscale)
  sepia: 0.0,         // 0.0 to 1.0 (vintage effect)
);
```

#### Shape Layer
```dart
final shapeLayer = ShapeLayer(
  shapeType: 'rectangle', // or 'circle'
  color: Colors.blue,
  borderRadius: 20.0,     // For rectangles
  width: 200,
  height: 100,
  position: Offset(50, 50),
);
```

### 4. Using the Controller

```dart
class ControllerExample extends StatefulWidget {
  @override
  _ControllerExampleState createState() => _ControllerExampleState();
}

class _ControllerExampleState extends State<ControllerExample> {
  late PosterController controller;

  @override
  void initState() {
    super.initState();
    controller = PosterController(
      poster: PosterModel(
        backgroundColor: Colors.white,
        size: Size(1080, 1920),
      ),
    );
  }

  void addCustomText() {
    final textLayer = TextLayer(
      text: 'Custom Text',
      style: TextStyle(fontSize: 32, color: Colors.black),
      position: Offset(100, 100),
    );
    controller.addLayer(textLayer);
  }

  void addImageFromDevice() async {
    await controller.addImageFromFile();
  }

  void duplicateSelected() {
    final selected = controller.selectedLayer;
    if (selected != null) {
      controller.duplicateLayer(selected.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PosterEditor(
        controller: controller,
        initialPoster: controller.poster,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: addCustomText,
            child: Icon(Icons.text_fields),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            onPressed: addImageFromDevice,
            child: Icon(Icons.image),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            onPressed: duplicateSelected,
            child: Icon(Icons.content_copy),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
```

### 5. Exporting Posters

```dart
import 'package:tss_poster/tss_poster.dart';

Future<void> exportPoster(PosterController controller) async {
  final exportService = ExportService();
  
  await exportService.exportPoster(
    controller.poster,
    format: ExportFormat.png,  // or ExportFormat.jpg
    quality: ExportQuality.high, // low, medium, high, ultra
    filename: 'my_poster',
  );
}
```

### 6. Layer Manipulation

```dart
// Select a layer
controller.selectLayer(layerId);

// Move layer
controller.updateLayer(layerId, layer..position = Offset(200, 300));

// Resize layer
controller.resizeLayer(layerId, Size(400, 300));

// Rotate layer
controller.rotateLayer(layerId, 0.5); // radians

// Scale layer
controller.scaleLayer(layerId, 1.5);

// Change opacity
controller.updateLayerOpacity(layerId, 0.8);

// Lock/unlock layer
controller.lockLayer(layerId, true);

// Layer ordering
controller.bringToFront(layerId);
controller.sendToBack(layerId);

// Delete layer
controller.removeLayer(layerId);

// Retrieve Poster Data (JSON)
final posterJson = controller.poster.toJson();

// Export Image Programmatically
final ui.Image? image = await controller.exportAsPNG(pixelRatio: 3.0);
if (image != null) {
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final pngBytes = byteData!.buffer.asUint8List();
  // Upload pngBytes to server or save to file
}
```

## Complete Example App

```dart
import 'package:flutter/material.dart';
import 'package:tss_poster/tss_poster.dart';

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
    // Start with a template
    controller = PosterController(
      poster: TemplateFactory.fitnessPost(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Poster Editor'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () => _exportPoster(),
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
    final exportService = ExportService();
    await exportService.exportPoster(
      controller.poster,
      format: ExportFormat.png,
      quality: ExportQuality.high,
      filename: 'my_awesome_poster',
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Poster exported successfully!')),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
```

## Platform-Specific Notes

### Web
- Image export uses browser download
- File picker works with web file input

### Mobile (iOS/Android)
- Requires camera/photo permissions for image upload
- Files saved to device storage
- Uses native file picker

### Desktop (Windows/macOS/Linux)
- Uses native file dialogs
- Full file system access

## Tips & Best Practices

1. **Performance**: Use `ExportQuality.medium` for faster exports during development
2. **Mobile UX**: The editor automatically adapts to mobile with bottom sheets
3. **Layer Management**: Lock layers you don't want to accidentally modify
4. **Templates**: Start with templates and customize rather than building from scratch
5. **Typography**: Use letter spacing and line height for professional text layouts
6. **Filters**: Combine multiple filters for creative effects (e.g., sepia + brightness)

## Troubleshooting

**Issue**: Images not loading
- **Solution**: Ensure images are in `assets/` and declared in `pubspec.yaml`

**Issue**: Export not working on mobile
- **Solution**: Add required permissions to `AndroidManifest.xml` and `Info.plist`

**Issue**: Layer not selectable
- **Solution**: Check if layer is locked (`isLocked` property)

## API Reference

For complete API documentation, visit: [pub.dev/packages/tss_poster](https://pub.dev/packages/tss_poster)

## Support

- **Issues**: [GitHub Issues](https://github.com/madhanlalprofession/tss_poster/issues)
- **Documentation**: [pub.dev](https://pub.dev/packages/tss_poster)
- **Examples**: See `/example` folder in the package

---

**Version**: 1.1.0  
**License**: MIT
