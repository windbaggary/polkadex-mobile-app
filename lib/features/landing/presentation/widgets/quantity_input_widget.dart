import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polkadex/common/utils/styles.dart';

class QuantityInputWidget extends StatelessWidget {
  const QuantityInputWidget({
    this.hintText,
    this.controller,
    this.onChanged,
  });

  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
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
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,4}'))
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

  void _onIncrementButtonPressed(double valueToIncrement) {
    final double currentValue = double.tryParse(controller?.text ?? '') ?? 0.0;

    if (onChanged != null && currentValue + valueToIncrement >= 0) {
      controller?.text = (currentValue + valueToIncrement).toString();
      onChanged!((currentValue + valueToIncrement).toString());
    }
  }
}
