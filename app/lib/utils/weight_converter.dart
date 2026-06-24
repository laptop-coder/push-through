import 'package:flutter/material.dart';
import 'package:quantify/quantify.dart';

class WeightConverter {
  static double toKg(double weight, Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return Mass(weight, MassUnit.pound).inKilograms;
      default:
        return weight;
    }
  }

  static double fromKg(double weight, Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return double.parse(
          Mass(weight, MassUnit.kilogram).inPounds.toStringAsFixed(1),
        );
      default:
        return weight;
    }
  }
}
