import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/features/landing/presentation/widgets/quantity_input_widget.dart';
import 'package:polkadex/common/widgets/polkadex_progress_error_widget.dart';
import 'package:polkadex/features/landing/utils/token_utils.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:shimmer/shimmer.dart';

class OrderQuantityWidget extends StatelessWidget {
  const OrderQuantityWidget({
    required this.hintText,
    required this.tokenId,
    required this.controller,
    required this.onChanged,
    this.isLoading = false,
    this.onError,
  });

  final String hintText;
  final String tokenId;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool isLoading;
  final Future<void> Function()? onError;

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
          Expanded(child: _mainWidget()),
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
                SvgPicture.asset(
                  TokenUtils.tokenIdToAssetSvg(tokenId),
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

  Widget _mainWidget() {
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
          : QuantityInputWidget(
              hintText: hintText,
              controller: controller,
              onChanged: onChanged,
            );
    }
  }
}
