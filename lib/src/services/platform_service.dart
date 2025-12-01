import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

import 'platform_service_io.dart'
    if (dart.library.js_interop) 'platform_service_web.dart';

/// Abstract interface for platform-specific operations
abstract class PlatformService {
  static final PlatformService _instance = getPlatformService();

  static PlatformService get instance => _instance;

  /// Save a file to the device
  Future<String?> saveFile({
    required Uint8List bytes,
    required String filename,
    required String mimeType,
  });

  /// Get an image provider from a local path or source
  ImageProvider getLocalImageProvider(String source);
}
