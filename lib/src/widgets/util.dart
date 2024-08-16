import 'package:flutter/material.dart';

TextTheme createTextTheme(
    BuildContext context, String bodyFontString, String displayFontString) {
  TextTheme baseTextTheme = Theme.of(context).textTheme;
  TextTheme bodyTextTheme = const TextTheme(
    bodyLarge: TextStyle(fontFamily: 'GoogleSans-Regular'),
    bodyMedium: TextStyle(fontFamily: 'GoogleSans-Medium'),
    bodySmall: TextStyle(
      fontFamily: 'GoogleSans',
    ),
    labelSmall: TextStyle(
      fontFamily: 'GoogleSans',
    ),
    labelMedium: TextStyle(
      fontFamily: 'GoogleSans',
    ),
    labelLarge: TextStyle(
      fontFamily: 'GoogleSans',
    ),
  );
  TextTheme displayTextTheme = const TextTheme(
    bodyLarge: TextStyle(fontFamily: 'GoogleSans-Regular'),
    bodyMedium: TextStyle(fontFamily: 'GoogleSans-Medium'),
    bodySmall: TextStyle(
      fontFamily: 'GoogleSans',
    ),
    labelSmall: TextStyle(
      fontFamily: 'GoogleSans',
    ),
    labelMedium: TextStyle(
      fontFamily: 'GoogleSans',
    ),
    labelLarge: TextStyle(
      fontFamily: 'GoogleSans',
    ),
  );
  TextTheme textTheme = displayTextTheme.copyWith(
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );
  return textTheme;
}
