import 'dart:math';

abstract class MathUtils {
  static double floorDecimalPrecision(double value, int precision) {
    num mod = pow(10, precision);
    return (value * mod).floorToDouble() / mod;
  }
}
