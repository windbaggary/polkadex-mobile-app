import 'package:polkadex/common/utils/enums.dart';

abstract class TimeUtils {
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
        return "1H";
      case EnumAppChartTimestampTypes.fourHours:
        return "4H";
      case EnumAppChartTimestampTypes.twelveHours:
        return "12H";
      case EnumAppChartTimestampTypes.oneDay:
        return "1D";
      case EnumAppChartTimestampTypes.oneWeek:
        return "1W";
      case EnumAppChartTimestampTypes.oneMonth:
        return "1M";
    }
  }

  static String timerIntervalTypeToString(
      EnumTimerIntervalTypes timestampType) {
    switch (timestampType) {
      case EnumTimerIntervalTypes.oneMinute:
        return "1m";
      case EnumTimerIntervalTypes.twoMinutes:
        return "2m";
      case EnumTimerIntervalTypes.threeMinutes:
        return "3m";
      case EnumTimerIntervalTypes.fiveMinutes:
        return "5m";
      case EnumTimerIntervalTypes.tenMinutes:
        return "10m";
      case EnumTimerIntervalTypes.thirtyMinutes:
        return "1h";
    }
  }

  static int timerIntervalTypeToInt(EnumTimerIntervalTypes timestampType) {
    switch (timestampType) {
      case EnumTimerIntervalTypes.oneMinute:
        return 1;
      case EnumTimerIntervalTypes.twoMinutes:
        return 2;
      case EnumTimerIntervalTypes.threeMinutes:
        return 3;
      case EnumTimerIntervalTypes.fiveMinutes:
        return 5;
      case EnumTimerIntervalTypes.tenMinutes:
        return 10;
      case EnumTimerIntervalTypes.thirtyMinutes:
        return 60;
    }
  }
}
