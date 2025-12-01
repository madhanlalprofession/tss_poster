import 'dart:js_interop';
import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;
import 'package:flutter/foundation.dart';
import 'platform_service.dart';

PlatformService getPlatformService() => PlatformServiceWeb();

class PlatformServiceWeb implements PlatformService {
  @override
  Future<String?> saveFile({
    required Uint8List bytes,
    required String filename,
    required String mimeType,
  }) async {
    try {
      final blob = web.Blob(
        [bytes.toJS].toJS,
        web.BlobPropertyBag(type: mimeType),
      );

      final url = web.URL.createObjectURL(blob);

      final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
      anchor.href = url;
      anchor.download = filename;
      anchor.click();

      web.URL.revokeObjectURL(url);

      return filename;
    } catch (e) {
      debugPrint('Web download failed: $e');
      return null;
    }
  }

  @override
  ImageProvider getLocalImageProvider(String source) {
    // On web, local paths are usually blob URLs or relative paths
    return NetworkImage(source);
  }
}
