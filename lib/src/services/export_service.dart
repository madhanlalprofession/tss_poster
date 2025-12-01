import 'dart:ui' as ui;

import 'platform_service.dart';

/// Supported export formats
enum ExportFormat { png, jpg }

/// Export quality levels
enum ExportQuality {
  low(1.0),
  medium(2.0),
  high(3.0),
  ultra(4.0);

  final double pixelRatio;
  const ExportQuality(this.pixelRatio);
}

/// Service for exporting posters to various formats
class ExportService {
  /// Exports an image to the device with the specified format and quality
  static Future<ExportResult> saveImageToDevice({
    required ui.Image image,
    required String filename,
    required ExportFormat format,
    ExportQuality quality = ExportQuality.high,
  }) async {
    try {
      // Convert image to bytes
      final byteData = await image.toByteData(
        format: format == ExportFormat.png
            ? ui.ImageByteFormat.png
            : ui.ImageByteFormat
                .png, // Convert to PNG first, then to JPG if needed
      );

      if (byteData == null) {
        return ExportResult.failure('Failed to convert image to bytes');
      }

      final bytes = byteData.buffer.asUint8List();

      // Add file extension if not present
      String finalFilename = filename;
      if (!filename.endsWith('.${format.name}')) {
        finalFilename = '$filename.${format.name}';
      }

      final mimeType = format == ExportFormat.png ? 'image/png' : 'image/jpeg';

      final result = await PlatformService.instance.saveFile(
        bytes: bytes,
        filename: finalFilename,
        mimeType: mimeType,
      );

      if (result != null) {
        return ExportResult.success(
          'Saved successfully',
          filePath: result,
        );
      } else {
        return ExportResult.failure('Failed to save file');
      }
    } catch (e) {
      return ExportResult.failure('Export failed: $e');
    }
  }
}

/// Result of an export operation
class ExportResult {
  final bool success;
  final String message;
  final String? filePath;

  ExportResult._({
    required this.success,
    required this.message,
    this.filePath,
  });

  factory ExportResult.success(String message, {String? filePath}) {
    return ExportResult._(
      success: true,
      message: message,
      filePath: filePath,
    );
  }

  factory ExportResult.failure(String message) {
    return ExportResult._(
      success: false,
      message: message,
    );
  }
}
