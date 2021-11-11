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
    return TextField(
      controller: controller,
      style: tsS16W500CFF,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: tsS16W500CFF,
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
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\,?\d*'))
      ],
    );
  }
}
