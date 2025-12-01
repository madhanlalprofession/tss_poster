import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tss_poster/src/core/models.dart';
import 'package:tss_poster/src/ui/layer_widget.dart';

void main() {
  testWidgets('Image layer bytes loading test', (WidgetTester tester) async {
    // 1. Create dummy image bytes (1x1 transparent PNG)
    final Uint8List pngBytes = Uint8List.fromList([
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // Header
      0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, // IHDR
      0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, // 1x1
      0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, // ...
      0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41, 0x54, // IDAT
      0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D, 0x0A,
      0x2D, 0xB4,
      0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60,
      0x82, // IEND
    ]);

    // 2. Create an ImageLayer with bytes
    final layer = ImageLayer(
      source: 'dummy_path.png', // Path shouldn't matter if bytes are present
      bytes: pngBytes,
    );
    layer.width = 200;
    layer.height = 200;
    layer.isSelected = true;

    // 3. Pump the LayerWidget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              LayerWidget(
                layer: layer,
                onTap: () {},
                onDoubleTap: () {},
                onMove: (_) {},
                onResize: (_) {},
                onRotate: (_) {},
              ),
            ],
          ),
        ),
      ),
    );

    // 4. Verify Image widget is present
    expect(find.byType(Image), findsOneWidget);

    // 5. Wait for image to "load"
    await tester.pumpAndSettle();

    // 6. Verify NO Error widget (meaning bytes loaded successfully)
    expect(find.text('Error loading image'), findsNothing);
  });
}
