import 'dart:math';
import 'package:polkadex/common/configs/app_config.dart';

extension ResponsiveUtils on num {
  static final double _designWidth = 414;
  static final double _designHeight = 926;

  static final double? _deviceWidth = AppConfigs.size.width;
  static final double? _deviceHeight = AppConfigs.size.height;

  static final double? _widthRespFactor = _deviceWidth! / _designWidth;
  static final double? _heightRespFactor = _deviceHeight! / _designHeight;

  double get sp => this * min(_widthRespFactor!, _heightRespFactor!);
}
