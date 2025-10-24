
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/ui/vms/vm.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

final themeViewmodel = ChangeNotifierProvider((ref) => ThemeViewmodel());

class ThemeViewmodel extends Vm {
  Color? _primaryColor;

  ThemeData getAppTheme(ColorScheme? color) => ThemeData(
        useMaterial3: true,
        colorScheme: _primaryColor != null
            ? ColorScheme.fromSeed(
                seedColor: _primaryColor!,
                brightness: color?.brightness ?? Brightness.light)
            : color,
      );

  Future<void> setPrimaryColor(String? imageUrl) async {
    // if (imageUrl != null) {
    //   final Color? dominantColor = await compute(_computeAverageColor, imageUrl);
    //   _primaryColor = dominantColor;
    //   notifyListeners();
    // }
  }

}

/// This function runs in a separate isolate.
/// It downloads, decodes, and calculates the AVERAGE color.
Future<Color?> computeAverageColor(String imageUrl) async {
  try {
    // 1. Fetch the image data
    final response = await http.get(Uri.parse(imageUrl)).timeout(
      const Duration(seconds: 10),
    );

    if (response.statusCode == 200) {
      // 2. Get the bytes
      final Uint8List imageBytes = response.bodyBytes;

      // 3. Decode the image using the 'image' package
      final img.Image? decodedImage = img.decodeImage(imageBytes);

      if (decodedImage == null) {
        print('Error: Could not decode image bytes.');
        return null;
      }

      // 4. Resize for performance.
      // Calculating the average of 10k pixels is much faster
      // than 4 million pixels and gives the same result.
      final img.Image resizedImage = img.copyResize(
        decodedImage,
        width: 10, // 100x100 is plenty for an average
      );

      // 5. Calculate the average color
      double red = 0;
      double green = 0;
      double blue = 0;
      int pixelCount = 0;

      // Iterate over every pixel
      for (final pixel in resizedImage) {
        // Use pixel.r, pixel.g, pixel.b
        red += pixel.r;
        green += pixel.g;
        blue += pixel.b;
        pixelCount++;
      }

      if (pixelCount == 0) return null;

      // Get the average value for each channel
      int avgRed = (red / pixelCount).round();
      int avgGreen = (green / pixelCount).round();
      int avgBlue = (blue / pixelCount).round();

      // 6. Return the pure, calculated color
      return Color.fromARGB(255, avgRed, avgGreen, avgBlue);

    } else {
      print('Error fetching image: ${response.statusCode}');
      return null;
    }

  } catch (e) {
    print('Error computing average color in isolate: $e');
    return null;
  }
}