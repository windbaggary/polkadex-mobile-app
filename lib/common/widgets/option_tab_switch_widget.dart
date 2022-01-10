import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';

class OptionTabSwitchWidget extends StatelessWidget {
  const OptionTabSwitchWidget({
    required this.svgAsset,
    required this.title,
    required this.description,
    required this.isChecked,
    required this.onSwitchChanged,
    this.loading = false,
    this.enabled = true,
  });

  final String svgAsset;
  final String? title;
  final String? description;
  final bool isChecked;
  final ValueChanged<bool> onSwitchChanged;
  final bool loading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.4,
      child: IgnorePointer(
        ignoring: !enabled || loading,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.color8BA1BE.withOpacity(0.2),
                ),
                padding: const EdgeInsets.all(14),
                child: SvgPicture.asset(svgAsset),
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
              SizedBox(width: MediaQuery.of(context).size.width * 0.01800),
              Opacity(
                opacity: loading ? 0.4 : 1.0,
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: FittedBox(
                    child: Switch(
                      value: isChecked,
                      onChanged: onSwitchChanged,
                      inactiveTrackColor: Colors.white.withOpacity(0.15),
                      activeColor: AppColors.colorE6007A,
                      activeTrackColor: Colors.white.withOpacity(0.15),
                      inactiveThumbColor: AppColors.colorABB2BC,
                    ),
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
