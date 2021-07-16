import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/widgets/chart/app_charts.dart';

/// The provider create a dummy data for line chart
class BalanceChartDummyProvider extends ChangeNotifier {
  final List<LineChartModel> _list = List<LineChartModel>.empty(growable: true);

  BalanceChartDummyProvider() : super() {
    _list.addAll(_createHourDummyList());
    startTimer();
  }

  Timer _timer;
  double _scale = 0.004;

  EnumBalanceChartDataTypes _balanceChartDataTypes =
      EnumBalanceChartDataTypes.Hour;

  double get chartScale => this._scale;

  EnumBalanceChartDataTypes get balanceChartDataType =>
      this._balanceChartDataTypes;

  List<LineChartModel> get list => this._list;

  set balanceChartDataType(EnumBalanceChartDataTypes val) {
    stopTimer();
    _list.clear();
    switch (val) {
      case EnumBalanceChartDataTypes.Hour:
        _list.addAll(_createHourDummyList());
        this._scale = 0.004;
        break;

      case EnumBalanceChartDataTypes.Week:
        _list.addAll(_createWeekDummyList());
        this._scale = 0.000025;
        break;

      case EnumBalanceChartDataTypes.Month:
        _list.addAll(_createMonthDummyList());
        this._scale = 0.000007;
        break;

      case EnumBalanceChartDataTypes.ThreeMonth:
        //  Handle this case.
        _list.addAll(_createDayDummyList());
        this._scale = 0.00017;
        break;

      case EnumBalanceChartDataTypes.SixMonth:
        //Handle this case.
        _list.addAll(_createDayDummyList());
        this._scale = 0.00017;
        break;

      case EnumBalanceChartDataTypes.Year:
        //Handle this case.
        _list.addAll(_createDayDummyList());
        this._scale = 0.00017;
        break;

      case EnumBalanceChartDataTypes.All:
        // Handle this case.
        _list.addAll(_createDayDummyList());
        this._scale = 0.00017;
        break;
    }
    this._balanceChartDataTypes = val;
    notifyListeners();
    startTimer();
  }

  void startTimer() {
    // stopTimer();
    // _timer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
    //   DateTime date = this._list.last.date;
    //   switch (this._balanceChartDataTypes) {
    //     case EnumBalanceChartDataTypes.Hour:
    //       date = date.add(const Duration(hours: 1));
    //       break;

    //     case EnumBalanceChartDataTypes.Week:
    //       date = date.add(const Duration(days: 6));
    //       break;

    //     case EnumBalanceChartDataTypes.Month:
    //       date = date.add(const Duration(days: 30));
    //       break;
    //     case EnumBalanceChartDataTypes.ThreeMonth:
    //     case EnumBalanceChartDataTypes.SixMonth:
    //     case EnumBalanceChartDataTypes.Year:
    //     case EnumBalanceChartDataTypes.All:
    //       // Handle this case.
    //       date = date.add(const Duration(days: 1));
    //       break;
    //   }
    //   _list.add(LineChartModel(date, _generateRandomNumber()));
    //   notifyListeners();
    // });
  }

  void stopTimer() {
    try {
      if (_timer != null) {
        _timer.cancel();
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
