import 'package:polkadex/common/utils/enums.dart';

abstract class TimestampUtils {
  static String timestampTypeToString(
      EnumAppChartTimestampTypes timestampType) {
    switch (timestampType) {
      case EnumAppChartTimestampTypes.oneMinute:
        return "1m";
      case EnumAppChartTimestampTypes.fiveMinutes:
        return "5m";
      case EnumAppChartTimestampTypes.thirtyMinutes:
        return "30m";
      case EnumAppChartTimestampTypes.oneHour:
        return "1h";
      case EnumAppChartTimestampTypes.fourHours:
        return "4h";
      case EnumAppChartTimestampTypes.twelveHours:
        return "12h";
      case EnumAppChartTimestampTypes.oneDay:
        return "1D";
      case EnumAppChartTimestampTypes.oneWeek:
        return "1w";
      case EnumAppChartTimestampTypes.oneMonth:
        return "1M";
    }
  }
}
