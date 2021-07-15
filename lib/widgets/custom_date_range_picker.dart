import 'package:flutter/material.dart';
import 'package:polkadex/utils/colors.dart';

abstract class CustomDateRangePicker {
  static Future<DateTimeRange?> call({
    required DateTime? filterStartDate,
    required DateTime? filterEndDate,
    required BuildContext context,
  }) =>
      showDateRangePicker(
        context: context,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        initialDateRange: DateTimeRange(
          start: filterStartDate ?? new DateTime.now(),
          end: filterEndDate ?? DateTime.now(),
        ),
        firstDate: new DateTime(2015),
        lastDate: new DateTime(DateTime.now().year + 2),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: colorE6007A,
                onPrimary: Colors.white,
                surface: color2E303C,
                onSurface: Colors.white,
              ),
            ),
            child: child!,
          );
        },
      );
}
