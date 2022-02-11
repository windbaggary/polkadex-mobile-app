import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/colors.dart';

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
          start: filterStartDate ?? DateTime.now(),
          end: filterEndDate ?? DateTime.now(),
        ),
        firstDate: DateTime(2015),
        lastDate: DateTime(DateTime.now().year + 2),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: AppColors.colorE6007A,
                onPrimary: Colors.white,
                surface: AppColors.color2E303C,
                onSurface: Colors.white,
              ),
            ),
            child: child!,
          );
        },
      );
}
