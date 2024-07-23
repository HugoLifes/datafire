import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0xff36618e),
      surfaceTint: Color(4280444040),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffd1e4ff),
      onPrimaryContainer: Color(0xff001d36),
      secondary: Color(0xff535f70),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd7e3f7),
      onSecondaryContainer: Color(0xff101c2b),
      tertiary: Color(0xff6b5778),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xfff2daff),
      onTertiaryContainer: Color(0xff251431),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      background: Color(4294376190),
      onBackground: Color(4279770144),
      surface: Color(0xfff8f9ff),
      onSurface: Color(0xff191c20),
      surfaceVariant: Color(4292731882),
      onSurfaceVariant: Color(0xff43474e),
      outline: Color(0xff73777f),
      outlineVariant: Color(4290889678),
      shadow: Color(0xff000000),
      scrim: Color(4278190080),
      inverseSurface: Color(0xff2e3135),
      inverseOnSurface: Color(0xffeff0f7),
      inversePrimary: Color(0xffa0cafd),
      primaryFixed: Color(0xffd1e4ff),
      onPrimaryFixed: Color(0xff001d36),
      primaryFixedDim: Color(0xffa0cafd),
      onPrimaryFixedVariant: Color(0xff194975),
      secondaryFixed: Color(0xffd7e3f7),
      onSecondaryFixed: Color(0xff101c2b),
      secondaryFixedDim: Color(0xffbbc7db),
      onSecondaryFixedVariant: Color(0xff3b4858),
      tertiaryFixed: Color(0xfff2daff),
      onTertiaryFixed: Color(0xff251431),
      tertiaryFixedDim: Color(0xffd6bee4),
      onTertiaryFixedVariant: Color(0xff523f5f),
      surfaceDim: Color(0xffd8dae0),
      surfaceBright: Color(0xfff8f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f3fa),
      surfaceContainer: Color(0xffeceef4),
      surfaceContainerHigh: Color(0xffe6e8ee),
      surfaceContainerHighest: Color(0xffe1e2e8),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4278208615),
      surfaceTint: Color(4280444040),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4282284959),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4281615697),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4284839813),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4282859103),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4286148499),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      background: Color(4294376190),
      onBackground: Color(4279770144),
      surface: Color(4294376190),
      onSurface: Color(4279770144),
      surfaceVariant: Color(4292731882),
      onSurfaceVariant: Color(4282205257),
      outline: Color(4284047462),
      outlineVariant: Color(4285889410),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281151797),
      inverseOnSurface: Color(4293849590),
      inversePrimary: Color(4287876598),
      primaryFixed: Color(4282284959),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4280246917),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4284839813),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4283260523),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4286148499),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4284503929),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292336351),
      surfaceBright: Color(4294376190),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294046969),
      surfaceContainer: Color(4293652211),
      surfaceContainerHigh: Color(4293257453),
      surfaceContainerHighest: Color(4292862951),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4278199608),
      surfaceTint: Color(4280444040),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4278208615),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4279378992),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4281615697),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4280622396),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4282859103),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      background: Color(4294376190),
      onBackground: Color(4279770144),
      surface: Color(4294376190),
      onSurface: Color(4278190080),
      surfaceVariant: Color(4292731882),
      onSurfaceVariant: Color(4280165674),
      outline: Color(4282205257),
      outlineVariant: Color(4282205257),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281151797),
      inverseOnSurface: Color(4294967295),
      inversePrimary: Color(4292603903),
      primaryFixed: Color(4278208615),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4278202439),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4281615697),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4280102714),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4282859103),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4281346119),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292336351),
      surfaceBright: Color(4294376190),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4294046969),
      surfaceContainer: Color(4293652211),
      surfaceContainerHigh: Color(4293257453),
      surfaceContainerHighest: Color(4292862951),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa0cafd),
      surfaceTint: Color(0xff003258),
      onPrimary: Color(0xff194975),
      primaryContainer: Color(0xff194975),
      onPrimaryContainer: Color(0xffd1e4ff),
      secondary: Color(0xffbbc7db),
      onSecondary: Color(0xff253140),
      secondaryContainer: Color(0xff3b4858),
      onSecondaryContainer: Color(0xffd7e3f7),
      tertiary: Color(0xffd6bee4),
      onTertiary: Color(0xff3b2948),
      tertiaryContainer: Color(0xff523f5f),
      onTertiaryContainer: Color(0xfff2daff),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      background: Color(4279243799),
      onBackground: Color(4292862951),
      surface: Color(0xff111418),
      onSurface: Color(0xffe1e2e8),
      surfaceVariant: Color(4282468429),
      onSurfaceVariant: Color(0xffc3c7cf),
      outline: Color(0xff8d9199),
      outlineVariant: Color(4282468429),
      shadow: Color(0xff000000),
      scrim: Color(4278190080),
      inverseSurface: Color(0xffe1e2e8),
      inverseOnSurface: Color(0xff2e3135),
      inversePrimary: Color(0xff36618e),
      primaryFixed: Color(0xffd1e4ff),
      onPrimaryFixed: Color(0xff001d36),
      primaryFixedDim: Color(0xffa0cafd),
      onPrimaryFixedVariant: Color(0xff194975),
      secondaryFixed: Color(0xffd7e3f7),
      onSecondaryFixed: Color(0xff101c2b),
      secondaryFixedDim: Color(0xffbbc7db),
      onSecondaryFixedVariant: Color(0xff3b4858),
      tertiaryFixed: Color(0xfff2daff),
      onTertiaryFixed: Color(0xff251431),
      tertiaryFixedDim: Color(0xffd6bee4),
      onTertiaryFixedVariant: Color(0xff523f5f),
      surfaceDim: Color(0xff111418),
      surfaceBright: Color(0xff36393e),
      surfaceContainerLowest: Color(0xff0b0e13),
      surfaceContainerLow: Color(0xff191c20),
      surfaceContainer: Color(0xff1d2024),
      surfaceContainerHigh: Color(0xff272a2f),
      surfaceContainerHighest: Color(0xff32353a),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4288140026),
      surfaceTint: Color(4287876598),
      onPrimary: Color(4278196262),
      primaryContainer: Color(4284258237),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4290498013),
      onSecondary: Color(4278523939),
      secondaryContainer: Color(4286682017),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4291937773),
      onTertiary: Color(4279832879),
      tertiaryContainer: Color(4288056241),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      background: Color(4279243799),
      onBackground: Color(4292862951),
      surface: Color(4279243799),
      onSurface: Color(4294507519),
      surfaceVariant: Color(4282468429),
      onSurfaceVariant: Color(4291152850),
      outline: Color(4288521386),
      outlineVariant: Color(4286416010),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292862951),
      inverseOnSurface: Color(4280691502),
      inversePrimary: Color(4278209902),
      primaryFixed: Color(4291291135),
      onPrimaryFixed: Color(4278194975),
      primaryFixedDim: Color(4287876598),
      onPrimaryFixedVariant: Color(4278205012),
      secondaryFixed: Color(4292011509),
      onSecondaryFixed: Color(4278326046),
      secondaryFixedDim: Color(4290169304),
      onSecondaryFixedVariant: Color(4280760388),
      tertiaryFixed: Color(4293516799),
      onTertiaryFixed: Color(4279503658),
      tertiaryFixedDim: Color(4291674345),
      onTertiaryFixedVariant: Color(4282003793),
      surfaceDim: Color(4279243799),
      surfaceBright: Color(4281678397),
      surfaceContainerLowest: Color(4278849298),
      surfaceContainerLow: Color(4279770144),
      surfaceContainer: Color(4280033316),
      surfaceContainerHigh: Color(4280691246),
      surfaceContainerHighest: Color(4281414969),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4294507519),
      surfaceTint: Color(4287876598),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4288140026),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4294507519),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4290498013),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294965759),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4291937773),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      background: Color(4279243799),
      onBackground: Color(4292862951),
      surface: Color(4279243799),
      onSurface: Color(4294967295),
      surfaceVariant: Color(4282468429),
      onSurfaceVariant: Color(4294507519),
      outline: Color(4291152850),
      outlineVariant: Color(4291152850),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292862951),
      inverseOnSurface: Color(4278190080),
      inversePrimary: Color(4278201667),
      primaryFixed: Color(4291881727),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4288140026),
      onPrimaryFixedVariant: Color(4278196262),
      secondaryFixed: Color(4292340217),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4290498013),
      onSecondaryFixedVariant: Color(4278523939),
      tertiaryFixed: Color(4293780223),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4291937773),
      onTertiaryFixedVariant: Color(4279832879),
      surfaceDim: Color(4279243799),
      surfaceBright: Color(4281678397),
      surfaceContainerLowest: Color(4278849298),
      surfaceContainerLow: Color(4279770144),
      surfaceContainer: Color(4280033316),
      surfaceContainerHigh: Color(4280691246),
      surfaceContainerHighest: Color(4281414969),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      background: background,
      onBackground: onBackground,
      surface: surface,
      onSurface: onSurface,
      surfaceVariant: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
