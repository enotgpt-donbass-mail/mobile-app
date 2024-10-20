import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.primaryColor,
    required this.secondaryColor,
    required this.iconColor,
  });

  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? iconColor;

  @override
  ThemeExtension<CustomColors> copyWith(
      {Color? primaryColor, Color? secondaryColor, Color? iconColor}) {
    return CustomColors(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      iconColor: iconColor ?? this.iconColor,
    );
  }

  @override
  ThemeExtension<CustomColors> lerp(
      ThemeExtension<CustomColors>? other, double t) {
    if (other is CustomColors) {
      return CustomColors(
        primaryColor: Color.lerp(primaryColor, other.primaryColor, t),
        secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t),
        iconColor: Color.lerp(iconColor, other.iconColor, t),
      );
    } else {
      // If other is not MyColors, return this or a default value
      return this;
    }
  }

  @override
  String toString() {
    return 'MyColors(customColor: $primaryColor)';
  }
}
