import 'dart:ui';

import 'package:aves/widgets/aves_app.dart';
import 'package:aves_utils/aves_utils.dart';
import 'package:flutter/material.dart';

class Themes {
  static const _titleTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    fontFeatures: [FontFeature.enable('smcp')],
  );

  static TextStyle searchFieldStyle(BuildContext context) => Theme.of(context).textTheme.bodyLarge!;

  static Color overlayBackgroundColor({
    required Brightness brightness,
    required bool blurred,
  }) {
    switch (brightness) {
      case Brightness.dark:
        return blurred ? Colors.black26 : Colors.black45;
      case Brightness.light:
        return blurred ? Colors.white54 : const Color(0xCCFFFFFF);
    }
  }

  static Color _schemeCardLayer(ColorScheme colors) => ElevationOverlay.applySurfaceTint(colors.surface, colors.surfaceTint, 1);

  static Color secondLayerColor(BuildContext context) => _schemeSecondLayer(Theme.of(context).colorScheme);

  // `DialogTheme` M3 defaults use `6.0` elevation
  static Color _schemeSecondLayer(ColorScheme colors) => ElevationOverlay.applySurfaceTint(colors.surface, colors.surfaceTint, 6);

  static Color thirdLayerColor(BuildContext context) => _schemeThirdLayer(Theme.of(context).colorScheme);

  static Color _schemeThirdLayer(ColorScheme colors) => ElevationOverlay.applySurfaceTint(colors.surface, colors.surfaceTint, 12);

  static Color _unselectedWidgetColor(ColorScheme colors) => colors.onSurface.withOpacity(0.6);

  static Color backgroundTextColor(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Color.alphaBlend(colors.surfaceTint, colors.onSurface).withOpacity(.5);
  }

  static final _typography = Typography.material2021(platform: TargetPlatform.android);

  static ThemeData _baseTheme(ColorScheme colors, bool deviceInitialized) {
    return ThemeData(
      // COLOR
      brightness: colors.brightness,
      canvasColor: _schemeSecondLayer(colors),
      cardColor: _schemeCardLayer(colors),
      colorScheme: colors,
      dividerColor: colors.outlineVariant,
      indicatorColor: colors.primary,
      scaffoldBackgroundColor: colors.background,
      // TYPOGRAPHY & ICONOGRAPHY
      typography: _typography,
      // COMPONENT THEMES
      checkboxTheme: _checkboxTheme(colors),
      floatingActionButtonTheme: _floatingActionButtonTheme(colors),
      radioTheme: _radioTheme(colors),
      sliderTheme: _sliderTheme(colors),
      tooltipTheme: _tooltipTheme,
    );
  }

  static CheckboxThemeData _checkboxTheme(ColorScheme colors) => CheckboxThemeData(
        side: BorderSide(width: 2.0, color: _unselectedWidgetColor(colors)),
      );

  static const _listTileTheme = ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(horizontal: 16),
  );

  static PopupMenuThemeData _popupMenuTheme(ColorScheme colors, TextTheme textTheme) {
    return PopupMenuThemeData(
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        // adapted from M3 defaults
        final TextStyle style = textTheme.labelLarge!;
        if (states.contains(MaterialState.disabled)) {
          return style.apply(color: colors.onSurface.withOpacity(0.38));
        }
        return style.apply(color: colors.onSurface);
      }),
      iconColor: colors.onSurface,
    );
  }

  static FloatingActionButtonThemeData _floatingActionButtonTheme(ColorScheme colors) {
    return FloatingActionButtonThemeData(
      foregroundColor: colors.onPrimary,
      backgroundColor: colors.primary,
    );
  }

  // adapted from M3 defaults
  static RadioThemeData _radioTheme(ColorScheme colors) => RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            if (states.contains(MaterialState.disabled)) {
              return colors.onSurface.withOpacity(0.38);
            }
            return colors.primary;
          }
          if (states.contains(MaterialState.disabled)) {
            return colors.onSurface.withOpacity(0.38);
          }
          if (states.contains(MaterialState.pressed)) {
            return colors.onSurface;
          }
          if (states.contains(MaterialState.hovered)) {
            return colors.onSurface;
          }
          if (states.contains(MaterialState.focused)) {
            return colors.onSurface;
          }
          return _unselectedWidgetColor(colors);
        }),
      );

  static SliderThemeData _sliderTheme(ColorScheme colors) => SliderThemeData(
        inactiveTrackColor: colors.primary.withOpacity(0.24),
      );

  static SnackBarThemeData _snackBarTheme(ColorScheme colors) => SnackBarThemeData(
        actionTextColor: colors.primary,
        behavior: SnackBarBehavior.floating,
      );

  static const _tooltipTheme = TooltipThemeData(
    verticalOffset: 32,
  );

  // light

  static final _lightThemeTypo = _typography.black;
  static final _lightTitleColor = _lightThemeTypo.titleMedium!.color!;
  static final _lightLabelColor = _lightThemeTypo.labelMedium!.color!;
  static const _lightActionIconColor = Color(0xAA000000);
  static const _lightOnSurface = Colors.black;

  static ThemeData lightTheme(Color accentColor, bool deviceInitialized) {
    final onAccent = ColorUtils.textColorOn(accentColor);
    final colors = ColorScheme.fromSeed(
      seedColor: accentColor,
      brightness: Brightness.light,
      primary: accentColor,
      onPrimary: onAccent,
      secondary: accentColor,
      onSecondary: onAccent,
      onSurface: _lightOnSurface,
    );
    final textTheme = _lightThemeTypo;
    return _baseTheme(colors, deviceInitialized).copyWith(
      // TYPOGRAPHY & ICONOGRAPHY
      textTheme: textTheme,
      // COMPONENT THEMES
      appBarTheme: AppBarTheme(
        // `foregroundColor` is used by icons
        foregroundColor: _lightActionIconColor,
        // `titleTextStyle.color` is used by text
        titleTextStyle: _titleTextStyle.copyWith(color: _lightTitleColor),
        systemOverlayStyle: deviceInitialized ? AvesApp.systemUIStyleForBrightness(colors.brightness, colors.background) : null,
      ),
      dialogTheme: DialogTheme(
        titleTextStyle: _titleTextStyle.copyWith(color: _lightTitleColor),
      ),
      listTileTheme: _listTileTheme.copyWith(
        iconColor: _lightActionIconColor,
      ),
      popupMenuTheme: _popupMenuTheme(colors, textTheme),
      snackBarTheme: _snackBarTheme(colors),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _lightLabelColor,
        ),
      ),
    );
  }

  // dark

  static final _darkThemeTypo = _typography.white;
  static final _darkTitleColor = _darkThemeTypo.titleMedium!.color!;
  static final _darkBodyColor = _darkThemeTypo.bodyMedium!.color!;
  static final _darkLabelColor = _darkThemeTypo.labelMedium!.color!;
  static const _darkOnSurface = Colors.white;

  static ColorScheme _darkColorScheme(Color accentColor) {
    final onAccent = ColorUtils.textColorOn(accentColor);
    final colors = ColorScheme.fromSeed(
      seedColor: accentColor,
      brightness: Brightness.dark,
      primary: accentColor,
      onPrimary: onAccent,
      secondary: accentColor,
      onSecondary: onAccent,
      onSurface: _darkOnSurface,
    );
    return colors;
  }

  static ThemeData _baseDarkTheme(ColorScheme colors, bool deviceInitialized) {
    final textTheme = _darkThemeTypo;
    return _baseTheme(colors, deviceInitialized).copyWith(
      // TYPOGRAPHY & ICONOGRAPHY
      textTheme: textTheme,
      // COMPONENT THEMES
      appBarTheme: AppBarTheme(
        // `foregroundColor` is used by icons
        foregroundColor: _darkTitleColor,
        // `titleTextStyle.color` is used by text
        titleTextStyle: _titleTextStyle.copyWith(color: _darkTitleColor),
        systemOverlayStyle: deviceInitialized ? AvesApp.systemUIStyleForBrightness(colors.brightness, colors.background) : null,
      ),
      dialogTheme: DialogTheme(
        titleTextStyle: _titleTextStyle.copyWith(color: _darkTitleColor),
      ),
      listTileTheme: _listTileTheme,
      popupMenuTheme: _popupMenuTheme(colors, textTheme),
      snackBarTheme: _snackBarTheme(colors).copyWith(
        backgroundColor: _schemeSecondLayer(colors),
        contentTextStyle: TextStyle(
          color: _darkBodyColor,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _darkLabelColor,
        ),
      ),
    );
  }

  static ThemeData darkTheme(Color accentColor, bool deviceInitialized) {
    final colors = _darkColorScheme(accentColor);
    return _baseDarkTheme(colors, deviceInitialized);
  }

  // black

  static ThemeData blackTheme(Color accentColor, bool deviceInitialized) {
    final colors = _darkColorScheme(accentColor).copyWith(
      background: Colors.black,
    );
    final baseTheme = _baseDarkTheme(colors, deviceInitialized);
    return baseTheme.copyWith(
      appBarTheme: baseTheme.appBarTheme.copyWith(
        backgroundColor: colors.background,
      ),
    );
  }
}
