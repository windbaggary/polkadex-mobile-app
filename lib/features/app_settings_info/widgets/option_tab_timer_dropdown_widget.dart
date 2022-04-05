import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/utils/time_utils.dart';

class OptionTabTimerDropdownWidget extends StatelessWidget {
  OptionTabTimerDropdownWidget({
    required this.options,
    required this.activeOption,
    required this.svgAsset,
    required this.title,
    required this.description,
    required this.onChanged,
    this.padding = const EdgeInsets.only(top: 32),
    this.loading = false,
    this.enabled = true,
  });

  final List<EnumTimerIntervalTypes> options;
  final EnumTimerIntervalTypes activeOption;
  final String svgAsset;
  final String? title;
  final String? description;
  final Function(EnumTimerIntervalTypes?) onChanged;
  final EdgeInsets padding;
  final bool loading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: IgnorePointer(
        ignoring: !enabled || loading,
        child: Padding(
          padding: padding,
          child: Row(
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.color8BA1BE.withOpacity(0.2),
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.access_time,
                  color: AppColors.colorFFFFFF,
                ),
              ),
              SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      title ?? "",
                      style: tsS15W400CFF,
                    ),
                    SizedBox(height: 1),
                    Text(
                      description ?? "",
                      style: tsS13W400CFFOP60,
                    ),
                  ],
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              Opacity(
                opacity: loading ? 0.4 : 1.0,
                child: DropdownButton(
                  items: options
                      .map((e) => DropdownMenuItem(
                            child: Text(
                              TimeUtils.timerIntervalTypeToString(e),
                              style: tsS16W600CFF,
                            ),
                            value: e,
                          ))
                      .toList(),
                  value: activeOption,
                  style: tsS16W600CFF,
                  underline: Container(),
                  onChanged: onChanged,
                  isExpanded: false,
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.colorFFFFFF,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
