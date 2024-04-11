import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ppp2/ui/vms/vm.dart';

final themeViewmodel = ChangeNotifierProvider((ref) => ThemeViewmodel());

class ThemeViewmodel extends Vm {
  // Color? _primaryColor;

  getAppTheme(Brightness brightness) => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: brightness,
        ),
      );

  setPrimaryColor(String? imageUrl) async {
    // if (imageUrl != null) {
    //   final palette = await PaletteGenerator.fromImageProvider(Image.network(imageUrl).image);
    //   _primaryColor = palette.dominantColor?.color;
    //   notifyListeners();
    // }
  }
}
