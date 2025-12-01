import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'platform_service.dart';

PlatformService getPlatformService() => PlatformServiceIO();

class PlatformServiceIO implements PlatformService {
  @override
  Future<String?> saveFile({
    required Uint8List bytes,
    required String filename,
    required String mimeType,
  }) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        // Use SharePlus to allow user to save or share the image
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$filename');
        await tempFile.writeAsBytes(bytes);

        final xFile = XFile(tempFile.path, mimeType: mimeType);

        await SharePlus.instance.share(
          ShareParams(
            files: [xFile],
            text: 'Check out my poster!',
          ),
        );

        return 'Image shared successfully';
      }

      // On desktop, save to 'poster' folder in downloads or documents
      final baseDir = await getDownloadsDirectory() ??
          await getApplicationDocumentsDirectory();

      final posterDir = Directory('${baseDir.path}/poster');
      if (!await posterDir.exists()) {
        await posterDir.create(recursive: true);
      }

      final filePath = '${posterDir.path}/$filename';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      return filePath;
    } catch (e) {
      debugPrint('File save failed: $e');
      return null;
    }
  }

  @override
  ImageProvider getLocalImageProvider(String source) {
    return FileImage(File(source));
  }
}
