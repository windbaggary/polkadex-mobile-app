import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/widgets/polkadex_progress_error_widget.dart';
import 'package:shimmer/shimmer.dart';

class QuantityInputWidget extends StatelessWidget {
  const QuantityInputWidget({
    this.hintText,
    this.controller,
    this.onChanged,
    this.isLoading = false,
    this.onError,
  });

  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool isLoading;
  final Future<void> Function()? onError;

  @override
  Widget build(BuildContext context) {
    if (onError != null) {
      return Row(
        children: [
          PolkadexErrorRefreshWidget(
            textSize: 16,
            onRefresh: onError,
          ),
        ],
      );
    } else {
      return isLoading
          ? Shimmer.fromColors(
              highlightColor: AppColors.color8BA1BE,
              baseColor: AppColors.color2E303C,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black,
                ),
                child: Text('placeholder'),
              ),
            )
          : Row(
              children: [
                GestureDetector(
                  onTapUp: (_) => _onIncrementButtonPressed(-1.0),
                  child: Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: controller,
                      style: tsS15W600CFF,
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: tsS15W600CABB2BC,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        errorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                        signed: false,
                      ),
                      onChanged: onChanged,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,4}'))
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTapUp: (_) => _onIncrementButtonPressed(1.0),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            );
    }
  }

  void _onIncrementButtonPressed(double valueToIncrement) {
    final double currentValue = double.tryParse(controller?.text ?? '') ?? 0.0;

    if (onChanged != null) {
      final newValue = currentValue + valueToIncrement >= 0
          ? currentValue + valueToIncrement
          : 0.0;

      controller?.text = newValue.toString();
      onChanged!(newValue.toString());
    }
  }
}
