import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/features/landing/presentation/widgets/quantity_input_widget.dart';
import 'package:polkadex/features/landing/utils/token_utils.dart';

class OrderQuantityWidget extends StatelessWidget {
  const OrderQuantityWidget({
    required this.hintText,
    required this.tokenId,
    required this.controller,
    required this.onChanged,
  });

  final String hintText;
  final String tokenId;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(13, 6.5, 13, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black.withOpacity(0.20),
      ),
      padding: const EdgeInsets.fromLTRB(20, 8, 13, 8),
      child: Row(
        children: [
          Expanded(
            child: QuantityInputWidget(
              hintText: hintText,
              controller: controller,
              onChanged: onChanged,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withOpacity(0.17),
                  blurRadius: 99,
                  offset: Offset(0.0, 100.0),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(13, 12, 13, 10),
            child: Row(
              children: [
                Image.asset(
                  TokenUtils.tokenIdToAssetImg(tokenId),
                  width: 17,
                  height: 17,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    TokenUtils.tokenIdToAcronym(tokenId),
                    style: tsS13W600CFF,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
