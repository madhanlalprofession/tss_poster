import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tss_poster/src/core/controller.dart';

import 'package:tss_poster/src/ui/canvas.dart';

void main() {
  testWidgets('PosterCanvas scales to fit viewport',
      (WidgetTester tester) async {
    // Set screen size to ensure deterministic constraints
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final controller = PosterController();
    // Default poster size is 1080x1920

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PosterCanvas(controller: controller),
        ),
      ),
    );

    // Allow post frame callback to run
    await tester.pumpAndSettle();

    final interactiveViewerFinder = find.byType(InteractiveViewer);
    expect(interactiveViewerFinder, findsOneWidget);

    final InteractiveViewer viewer = tester.widget(interactiveViewerFinder);
    final transformation = viewer.transformationController!.value;

    // Check scale
    // Scale should be min(400/1080, 800/1920) * 0.9
    // 400/1080 = 0.37037
    // 800/1920 = 0.41666
    // Min is 0.37037
    // 0.37037 * 0.9 = 0.333333
    final scale = transformation.getMaxScaleOnAxis();
    expect(scale, closeTo(0.333, 0.001));
  });
}
