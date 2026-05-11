import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageCompressService {
  /// Compresses the image and returns the compressed File.
  static Future<File?> compressImage(File file) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final path = file.absolute.path;
      final targetPath = '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

      var result = await FlutterImageCompress.compressAndGetFile(
        path, 
        targetPath,
        quality: 80, // 80% quality is usually enough for OCR while saving space
        minWidth: 1024,
        minHeight: 1024,
      );

      if (result != null) {
        debugPrint("Original size: ${file.lengthSync()} bytes");
        final compressedFile = File(result.path);
        debugPrint("Compressed size: ${compressedFile.lengthSync()} bytes");
        return compressedFile;
      }
      return null;
    } catch (e) {
      debugPrint("Error compressing image: $e");
      return file; // fallback to original file if compression fails
    }
  }
}
