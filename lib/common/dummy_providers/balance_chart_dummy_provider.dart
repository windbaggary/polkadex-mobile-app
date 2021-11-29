import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:polkadex/common/graph/data/models/line_chart_model.dart';
import 'package:polkadex/common/graph/domain/entities/line_chart_entity.dart';
import 'package:polkadex/common/utils/enums.dart';

/// The provider create a dummy data for line chart
class BalanceChartDummyProvider extends ChangeNotifier {
  final List<LineChartEntity> _list = List<LineChartEntity>.empty(growable: true);

  BalanceChartDummyProvider() : super() {
    _list.addAll(_createHourDummyList());
    startTimer();
  }

  Timer? _timer;
  double _scale = 0.004;

  EnumBalanceChartDataTypes _balanceChartDataTypes =
      EnumBalanceChartDataTypes.hour;

  double get chartScale => _scale;

  EnumBalanceChartDataTypes get balanceChartDataType => _balanceChartDataTypes;

  List<LineChartEntity> get list => _list;

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
        //  Handle this case.
        _list.addAll(_createDayDummyList());
        _scale = 0.00017;
        break;

      case EnumBalanceChartDataTypes.sixMonth:
        //Handle this case.
        _list.addAll(_createDayDummyList());
        _scale = 0.00017;
        break;

      case EnumBalanceChartDataTypes.year:
        //Handle this case.
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
        _timer?.cancel();
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

  List<LineChartEntity> _createHourDummyList() {
    return List<LineChartEntity>.generate(
      333,
      (index) => LineChartModel(
        date: DateTime.now().add(Duration(hours: -index)),
        pointY: _generateRandomNumber(),
      ),
    ).reversed.toList();
  }

  List<LineChartEntity> _createWeekDummyList() {
    return List<LineChartEntity>.generate(
      333,
      (index) => LineChartModel(
        date: DateTime.now().add(Duration(days: -index - 6 * index)),
        pointY: _generateRandomNumber(),
      ),
    ).reversed.toList();
  }

  List<LineChartEntity> _createDayDummyList() {
    return List<LineChartEntity>.generate(
      333,
      (index) => LineChartModel(
        date: DateTime.now().add(Duration(days: -index)),
        pointY: _generateRandomNumber(),
      ),
    ).reversed.toList();
  }

  List<LineChartEntity> _createMonthDummyList() {
    return List<LineChartEntity>.generate(
      333,
      (index) => LineChartModel(
        date: DateTime.now().add(Duration(days: -index * 30)),
        pointY: _generateRandomNumber(),
      ),
    ).reversed.toList();
  }

  double _generateRandomNumber() =>
      (1000.0 + Random().nextDouble() * 5999.00).clamp(0.0, 5999.0) + 4000;
}
