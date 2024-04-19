import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ButtonStyle get buttonStyle => ButtonStyle(
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      textStyle: MaterialStatePropertyAll(textStyleBody),
    );

ButtonStyle controlsButtonStyle(bool rounded) => ButtonStyle(
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(rounded ? 100 : 16)),
      ),
      textStyle: MaterialStatePropertyAll(textStyleBody),
    );

TextStyle get themeFontFamily => GoogleFonts.jetBrainsMono();

TextStyle get textStyleTitle => themeFontFamily.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );

TextStyle get textStyleHeader => themeFontFamily.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

TextStyle get textStyleBody => themeFontFamily.copyWith(
      fontSize: 14,
    );

textStyleBodyGray(context) => themeFontFamily.copyWith(
      fontSize: 14,
      color: Theme.of(context).colorScheme.onBackground.withOpacity(.5),
    );

textStyleSubtitle(context) => themeFontFamily.copyWith(
      fontSize: 18,
      color: Theme.of(context).colorScheme.primary,
    );

textStyleSmallGray(context) => themeFontFamily.copyWith(
      fontSize: 12,
      color: Theme.of(context).colorScheme.onBackground.withOpacity(.5),
    );

TextStyle get textStyleSmall => themeFontFamily.copyWith(
      fontSize: 12,
    );

MenuStyle get dropdownItemsStyle => const MenuStyle(
      alignment: Alignment.bottomLeft,
    );

  
