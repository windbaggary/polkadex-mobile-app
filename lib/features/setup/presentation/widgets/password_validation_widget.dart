import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';

class PasswordValidationWidget extends StatelessWidget {
  PasswordValidationWidget({
    required this.title,
    this.isValid = false,
  });

  final String title;
  final bool isValid;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 6),
          child: Icon(
            Icons.check,
            size: 16,
            color: isValid
                ? AppColors.color02C076
                : AppColors.colorFFFFFF.withOpacity(0.5),
          ),
        ),
        Flexible(
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              title,
              style: isValid ? tsS14W400CFF : tsS14W400CFFOP50,
            ),
          ),
        ),
      ],
    );
  }
}
