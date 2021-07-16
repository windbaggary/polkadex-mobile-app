import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:polkadex/utils/enums.dart';
import 'package:polkadex/widgets/chart/app_charts.dart';

/// The provider create a dummy data for line chart
class AppChartDummyProvider extends ChangeNotifier {
  final List<LineChartModel> _list = List<LineChartModel>.empty(growable: true);

  AppChartDummyProvider() : super() {
    _list.addAll(_createHourDummyList());
    startTimer();
  }

  /// The timer is used to generate new data periodically
  Timer? _timer;

  /// The default scale between each points
  double _scale = 0.004;

  /// The filter dates to sort out the chart data
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;

  EnumAppChartDataTypes _chartDataType = EnumAppChartDataTypes.hour;
  EnumBalanceChartDataTypes _balanceChartDataTypes =
      EnumBalanceChartDataTypes.hour;

  double get chartScale => _scale;

  EnumAppChartDataTypes get chartDataType => _chartDataType;
  EnumBalanceChartDataTypes get balanceChartDataType => _balanceChartDataTypes;

  List<LineChartModel> get list {
    if (filterStartDate != null || _filterEndDate != null) {
      return _list.where((item) {
        bool hasThisItem = true;
        if (_filterStartDate != null) {
          final compare =
              DateTime(item.date.year, item.date.month, item.date.day)
                  .compareTo(filterStartDate!);
          hasThisItem = compare >= 0;
        }

        if (!hasThisItem) {
          return false;
        }
        if (_filterEndDate != null) {
          final compare =
              DateTime(item.date.year, item.date.month, item.date.day)
                  .compareTo(filterEndDate!);
          hasThisItem = compare <= 0;
        }

        return hasThisItem;
      }).toList();
    }

    return _list;
  }

  DateTime? get filterStartDate => _filterStartDate == null
      ? null
      : DateTime(_filterStartDate!.year, _filterStartDate!.month,
          _filterStartDate!.day);
  DateTime? get filterEndDate => _filterEndDate == null
      ? null
      : DateTime(
          _filterEndDate!.year, _filterEndDate!.month, _filterEndDate!.day);

  set chartDataType(EnumAppChartDataTypes val) {
    stopTimer();
    _list.clear();
    switch (val) {
      case EnumAppChartDataTypes.hour:
        _list.addAll(_createHourDummyList());
        _scale = 0.004;
        break;

      case EnumAppChartDataTypes.week:
        _list.addAll(_createWeekDummyList());
        _scale = 0.000025;
        break;

      case EnumAppChartDataTypes.day:
        _list.addAll(_createDayDummyList());
        _scale = 0.00017;
        break;

      case EnumAppChartDataTypes.month:
        _list.addAll(_createMonthDummyList());
        _scale = 0.000007;
        break;
    }
    _chartDataType = val;
    notifyListeners();
    startTimer();
  }

  set balanceChartDataType(EnumBalanceChartDataTypes val) {
    stopTimer();
    _list.clear();
    switch (val) {
      case EnumBalanceChartDataTypes.hour:
        _list.addAll(_createHourDummyList());
        _scale = 0.004;
        break;

      case EnumBalanceChartDataTypes.week:
        _list.addAll(_createWeekDummyList());
        _scale = 0.000025;
        break;

      case EnumBalanceChartDataTypes.month:
        _list.addAll(_createMonthDummyList());
        _scale = 0.000007;
        break;

      case EnumBalanceChartDataTypes.threeMonth:
        // Handle this case.
        _list.addAll(_createDayDummyList());
        _scale = 0.00017;
        break;

      case EnumBalanceChartDataTypes.sixMonth:
        // Handle this case.
        _list.addAll(_createDayDummyList());
        _scale = 0.00017;
        break;

      case EnumBalanceChartDataTypes.year:
        //  Handle this case.
        _list.addAll(_createDayDummyList());
        _scale = 0.00017;
        break;

      case EnumBalanceChartDataTypes.all:
        // Handle this case.
        _list.addAll(_createDayDummyList());
        _scale = 0.00017;
        break;
    }
    _balanceChartDataTypes = val;
    notifyListeners();
    startTimer();
  }

  void setFilterDates(DateTime startDate, DateTime endDate) {
    _filterStartDate = startDate;
    _filterEndDate = endDate;
    notifyListeners();
  }

  void startTimer() {
    // stopTimer();
    // _timer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
    //   DateTime date = this._list.last.date;
    //   switch (this._chartDataType) {
    //     case EnumAppChartDataTypes.Hour:
    //       date = date.add(const Duration(hours: 1));
    //       break;

    //     case EnumAppChartDataTypes.Week:
    //       date = date.add(const Duration(days: 6));
    //       break;

    //     case EnumAppChartDataTypes.Day:
    //       date = date.add(const Duration(days: 1));
    //       break;

    //     case EnumAppChartDataTypes.Month:
    //       date = date.add(const Duration(days: 30));
    //       break;
    //   }
    //   _list.add(LineChartModel(date, _generateRandomNumber()));

    // if (_list.length > 333) {
    //   _list.removeAt(0);
    // }

    //   notifyListeners();
    // });
  }

  void stopTimer() {
    try {
      if (_timer != null) {
        _timer!.cancel();
        _timer = null;
      }
    } catch (ex) {
      print(ex);
    }
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  List<LineChartModel> _createHourDummyList() {
    return List<LineChartModel>.generate(
      333,
      (index) => LineChartModel(
        DateTime.now().add(Duration(hours: -index)),
        _generateRandomNumber(),
      ),
    ).reversed.toList();
  }

  List<LineChartModel> _createWeekDummyList() {
    return List<LineChartModel>.generate(
      333,
      (index) => LineChartModel(
        DateTime.now().add(Duration(days: -index - 6 * index)),
        _generateRandomNumber(),
      ),
    ).reversed.toList();
  }

  List<LineChartModel> _createDayDummyList() {
    return List<LineChartModel>.generate(
      333,
      (index) => LineChartModel(
        DateTime.now().add(Duration(days: -index)),
        _generateRandomNumber(),
      ),
    ).reversed.toList();
  }

  List<LineChartModel> _createMonthDummyList() {
    return List<LineChartModel>.generate(
      333,
      (index) => LineChartModel(
        DateTime.now().add(Duration(days: -index * 30)),
        _generateRandomNumber(),
      ),
    ).reversed.toList();
  }

  double _generateRandomNumber() =>
      (1000.0 + Random().nextDouble() * 5999.00).clamp(0.0, 5999.0) + 4000;
}
