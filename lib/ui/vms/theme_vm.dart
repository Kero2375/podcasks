import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podcasks/ui/vms/vm.dart';

final themeViewmodel = ChangeNotifierProvider((ref) => ThemeViewmodel());

class ThemeViewmodel extends Vm {
  // Color? _primaryColor;

  getAppTheme(ColorScheme? color) =>
      ThemeData(useMaterial3: true, colorScheme: color);

  setPrimaryColor(String? imageUrl) async {
    // if (imageUrl != null) {
    //   final palette = await PaletteGenerator.fromImageProvider(Image.network(imageUrl).image);
    //   _primaryColor = palette.dominantColor?.color;
    //   notifyListeners();
    // }
  }
}
