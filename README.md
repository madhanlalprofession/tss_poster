# 🎨 TSS Poster: The Ultimate Flutter Image Editor

[![pub package](https://img.shields.io/pub/v/tss_poster.svg)](https://pub.dev/packages/tss_poster)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**Turn your Flutter app into a Canva-like design studio.**

`tss_poster` is a powerful, highly customizable, and easy-to-use Flutter package for creating posters, flyers, social media graphics, and more. With drag-and-drop capabilities, rich text editing, and shape management, it's the perfect solution for any app needing image generation.

---

## ✨ Key Features

*   **👆 Drag & Drop Interface**: Intuitively move, resize, and rotate text, images, and shapes.
*   **📝 Advanced Text Editing**: Change fonts, colors, alignment, and spacing with a built-in property panel.
*   **🖼️ Image Management**: Upload images from device or network, resize, and position them perfectly.
*   **🔺 Shape Support**: Add circles, rectangles, and other shapes to enhance your designs.
*   **🎨 Layer Management**: Reorder layers (bring to front, send to back), lock layers, and duplicate items.
*   **💾 High-Quality Export**: Export designs as high-resolution PNG or JPG files.
*   **📱 Cross-Platform**: Works seamlessly on Android, iOS, Web, macOS, Windows, and Linux.
*   **🛠️ Fully Customizable**: Hide specific tools, use your own controller, or build a completely custom UI around the core engine.

---

## 📦 Installation

Add `tss_poster` to your `pubspec.yaml`:

```yaml
dependencies:
  tss_poster: ^1.4.2
```

Then run:

```bash
flutter pub get
```

---

## 💻 Usage

### 1. Basic Editor
The simplest way to use `tss_poster` is to drop the `PosterEditor` widget into your app.

```dart
import 'package:flutter/material.dart';
import 'package:tss_poster/tss_poster.dart';

class CreatePosterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PosterEditor(),
    );
  }
}
```

### 2. Customizing the Toolbar
You can control which tools are visible to the user.

```dart
PosterEditor(
  showImage: true,  // Enable image tool
  showShape: false, // Disable shape tool
  showText: true,   // Enable text tool
  showExport: true, // Show built-in export button
)
```

### 3. Programmatic Control with `PosterController`
Use `PosterController` to manipulate the editor from outside the widget.

```dart
class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final _controller = PosterController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Custom Toolbar
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.text_fields),
              onPressed: () => _controller.addLayer(TextLayer(text: "New Text")),
            ),
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
                final image = await _controller.exportAsPNG();
                // Handle the image (e.g., save to gallery, upload to server)
              },
            ),
          ],
        ),
        // Editor
        Expanded(
          child: PosterEditor(controller: _controller),
        ),
      ],
    );
  }
}
```

### 4. Handling Exports Manually
If you want to handle the export process yourself (e.g., upload to a server instead of saving to device), use the `onExport` callback.

```dart
PosterEditor(
  showExport: false, // Hide default button
  onExport: (Uint8List imageBytes) async {
    // Upload 'imageBytes' to your server
    await myApiService.uploadPoster(imageBytes);
  },
)
```

---

## 📚 API Documentation

### `PosterEditor`
The main widget.
*   `controller`: (Optional) `PosterController` to control the editor.
*   `initialPoster`: (Optional) `PosterModel` to load an existing design.
*   `showText`, `showImage`, `showShape`: Booleans to toggle tools.
*   `onExport`: Callback when export is triggered.

### `PosterController`
Manages the state of the poster.
*   `addLayer(LayerModel layer)`: Adds a new layer.
*   `removeLayer(String id)`: Removes a layer.
*   `exportAsPNG({double pixelRatio})`: Returns `ui.Image` of the poster.
*   `updateBackground(Color color)`: Sets background color.

---

## 🤝 Contributing

Contributions are welcome! If you find a bug or want a feature, please open an issue.

## 📄 License

MIT License - see the [LICENSE](LICENSE) file for details.
