import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'models.dart';

/// Controller for managing the state of the poster.
class PosterController extends ChangeNotifier {
  PosterModel _poster;

  /// GlobalKey for the RepaintBoundary used for exporting.
  final GlobalKey repaintBoundaryKey = GlobalKey();

  // Undo/Redo stacks (storing JSON snapshots for simplicity)
  final List<String> _undoStack = [];
  final List<String> _redoStack = [];

  PosterController({PosterModel? poster}) : _poster = poster ?? PosterModel();

  /// The current poster model.
  PosterModel get poster => _poster;

  void _saveState() {
    _undoStack.add(jsonEncode(_poster.toJson()));
    _redoStack.clear();
    // Limit stack size
    if (_undoStack.length > 20) {
      _undoStack.removeAt(0);
    }
  }

  /// Reverts the last action.
  void undo() {
    if (_undoStack.isNotEmpty) {
      _redoStack.add(jsonEncode(_poster.toJson()));
      final previousState = _undoStack.removeLast();
      _poster = PosterModel.fromJson(jsonDecode(previousState));
      notifyListeners();
    }
  }

  /// Reapplies the last undone action.
  void redo() {
    if (_redoStack.isNotEmpty) {
      _undoStack.add(jsonEncode(_poster.toJson()));
      final nextState = _redoStack.removeLast();
      _poster = PosterModel.fromJson(jsonDecode(nextState));
      notifyListeners();
    }
  }

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  /// Adds a new layer to the poster.
  void addLayer(LayerModel layer) {
    _saveState();
    _poster.layers.add(layer);
    selectLayer(layer.id);
    notifyListeners();
  }

  /// Removes a layer by its ID.
  void removeLayer(String id) {
    _saveState();
    _poster.layers.removeWhere((l) => l.id == id);
    notifyListeners();
  }

  /// Updates an existing layer.
  void updateLayer(String id, LayerModel newLayer) {
    // For granular updates, we might not want to save state on every keystroke
    // But for simplicity:
    final index = _poster.layers.indexWhere((l) => l.id == id);
    if (index != -1) {
      _saveState();
      _poster.layers[index] = newLayer;
      notifyListeners();
    }
  }

  // Layer Reordering
  /// Moves the specified layer to the front of the stack.
  void bringToFront(String id) {
    final index = _poster.layers.indexWhere((l) => l.id == id);
    if (index != -1 && index < _poster.layers.length - 1) {
      _saveState();
      final layer = _poster.layers.removeAt(index);
      _poster.layers.add(layer);
      notifyListeners();
    }
  }

  /// Moves the specified layer to the back of the stack.
  void sendToBack(String id) {
    final index = _poster.layers.indexWhere((l) => l.id == id);
    if (index != -1 && index > 0) {
      _saveState();
      final layer = _poster.layers.removeAt(index);
      _poster.layers.insert(0, layer);
      notifyListeners();
    }
  }

  void reorderLayer(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    _saveState();
    final layer = _poster.layers.removeAt(oldIndex);
    _poster.layers.insert(newIndex, layer);
    notifyListeners();
  }

  /// Selects a layer by its ID. Pass null to deselect all.
  void selectLayer(String? id) {
    for (var layer in _poster.layers) {
      layer.isSelected = (layer.id == id);
    }
    notifyListeners();
  }

  LayerModel? get selectedLayer {
    try {
      return _poster.layers.firstWhere((l) => l.isSelected);
    } catch (e) {
      return null;
    }
  }

  /// Updates the background color of the poster.
  void updateBackground(Color color) {
    _saveState();
    _poster.backgroundColor = color;
    _poster.backgroundImage = null;
    notifyListeners();
  }

  /// Updates the background image of the poster.
  void updateBackgroundImage(String path) {
    _saveState();
    _poster.backgroundImage = path;
    notifyListeners();
  }

  // Basic transformations for selected layer
  /// Moves the currently selected layer by the given delta.
  void moveLayer(Offset delta) {
    final layer = selectedLayer;
    if (layer != null) {
      _saveState();
      layer.position += delta;
      notifyListeners();
    }
  }

  /// Exports the current poster state as a high-quality image.
  Future<ui.Image?> exportAsImage() async {
    // Deselect layer before capturing to avoid showing selection border
    selectLayer(null);
    // Wait for frame to render without selection
    await Future.delayed(const Duration(milliseconds: 50));

    try {
      final boundary = repaintBoundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary != null) {
        return await boundary.toImage(pixelRatio: 3.0); // High quality
      }
    } catch (e) {
      debugPrint('Error exporting image: $e');
    }
    return null;
  }

  /// Exports poster as PNG with specified quality
  Future<ui.Image?> exportAsPNG({double pixelRatio = 3.0}) async {
    selectLayer(null);
    await Future.delayed(const Duration(milliseconds: 50));

    try {
      final boundary = repaintBoundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary != null) {
        return await boundary.toImage(pixelRatio: pixelRatio);
      }
    } catch (e) {
      debugPrint('Error exporting PNG: $e');
    }
    return null;
  }

  /// Resizes a layer to the specified size
  void resizeLayer(String id, Size newSize) {
    final index = _poster.layers.indexWhere((l) => l.id == id);
    if (index != -1) {
      _saveState();
      _poster.layers[index].width = newSize.width;
      _poster.layers[index].height = newSize.height;
      notifyListeners();
    }
  }

  /// Rotates a layer by the specified angle (in radians)
  void rotateLayer(String id, double angle) {
    final index = _poster.layers.indexWhere((l) => l.id == id);
    if (index != -1) {
      _saveState();
      _poster.layers[index].rotation = angle;
      notifyListeners();
    }
  }

  /// Duplicates a layer
  void duplicateLayer(String id) {
    final index = _poster.layers.indexWhere((l) => l.id == id);
    if (index != -1) {
      _saveState();
      final original = _poster.layers[index];

      // Create a copy with offset position
      LayerModel duplicate;
      if (original is TextLayer) {
        duplicate = TextLayer(
          text: original.text,
          style: original.style,
          align: original.align,
          position: original.position + const Offset(20, 20),
          rotation: original.rotation,
          scale: original.scale,
        );
      } else if (original is ImageLayer) {
        duplicate = ImageLayer(
          source: original.source,
          isNetwork: original.isNetwork,
          position: original.position + const Offset(20, 20),
          rotation: original.rotation,
          scale: original.scale,
        );
      } else if (original is ShapeLayer) {
        duplicate = ShapeLayer(
          shapeType: original.shapeType,
          color: original.color,
          borderRadius: original.borderRadius,
          position: original.position + const Offset(20, 20),
          rotation: original.rotation,
          scale: original.scale,
        );
      } else {
        return;
      }

      // Copy common properties
      duplicate.opacity = original.opacity;
      duplicate.isLocked = original.isLocked;
      duplicate.width = original.width;
      duplicate.height = original.height;

      _poster.layers.add(duplicate);
      selectLayer(duplicate.id);
      notifyListeners();
    }
  }

  /// Locks or unlocks a layer
  void lockLayer(String id, bool locked) {
    final index = _poster.layers.indexWhere((l) => l.id == id);
    if (index != -1) {
      _saveState();
      _poster.layers[index].isLocked = locked;
      notifyListeners();
    }
  }

  /// Updates layer opacity
  void updateLayerOpacity(String id, double opacity) {
    final index = _poster.layers.indexWhere((l) => l.id == id);
    if (index != -1) {
      _saveState();
      _poster.layers[index].opacity = opacity.clamp(0.0, 1.0);
      notifyListeners();
    }
  }

  /// Scales a layer
  void scaleLayer(String id, double scale) {
    final index = _poster.layers.indexWhere((l) => l.id == id);
    if (index != -1) {
      _saveState();
      _poster.layers[index].scale = scale;
      notifyListeners();
    }
  }

  /// Adds an image layer from a file path and optional bytes
  void addImageFromFile(String filePath, {Uint8List? bytes}) {
    _saveState();
    final layer = ImageLayer(
      source: filePath,
      bytes: bytes,
      isNetwork: false,
      position: Offset(
        _poster.size.width / 2 - 100,
        _poster.size.height / 2 - 100,
      ),
    );
    _poster.layers.add(layer);
    selectLayer(layer.id);
    notifyListeners();
  }
}
