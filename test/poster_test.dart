import 'package:flutter_test/flutter_test.dart';
import 'package:tss_poster/src/core/controller.dart';
import 'package:tss_poster/src/core/models.dart';
import 'package:flutter/material.dart';

void main() {
  group('PosterController Tests', () {
    late PosterController controller;

    setUp(() {
      controller = PosterController();
    });

    test('Initial state is empty', () {
      expect(controller.poster.layers, isEmpty);
      expect(controller.selectedLayer, isNull);
    });

    test('Add layer adds to list and selects it', () {
      final layer = TextLayer(text: 'Test');
      controller.addLayer(layer);

      expect(controller.poster.layers, contains(layer));
      expect(controller.selectedLayer, equals(layer));
    });

    test('Remove layer removes from list', () {
      final layer = TextLayer(text: 'Test');
      controller.addLayer(layer);
      controller.removeLayer(layer.id);

      expect(controller.poster.layers, isEmpty);
      expect(controller.selectedLayer, isNull);
    });

    test('Update background color', () {
      controller.updateBackground(Colors.red);
      expect(controller.poster.backgroundColor, equals(Colors.red));
    });

    test('Layer reordering - Bring to Front', () {
      final layer1 = TextLayer(text: '1');
      final layer2 = TextLayer(text: '2');
      controller.addLayer(layer1);
      controller.addLayer(layer2);

      // Initial: [1, 2]
      expect(controller.poster.layers.last, equals(layer2));

      controller.bringToFront(layer1.id);
      // Expected: [2, 1]
      expect(controller.poster.layers.last, equals(layer1));
    });
  });
}
