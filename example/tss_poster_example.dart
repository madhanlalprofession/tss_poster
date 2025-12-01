import 'package:flutter/foundation.dart';
import 'package:tss_poster/tss_poster.dart';

void main() {
  // Only static, non-UI, non-IO demonstration.
  final controller = PosterController();
  controller.addLayer(TextLayer(text: "Sample text"));
  debugPrint('Poster Editor Example');
}
