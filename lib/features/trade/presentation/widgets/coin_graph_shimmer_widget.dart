import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:shimmer/shimmer.dart';

class CoinGraphShimmerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: AppColors.color8BA1BE,
      baseColor: AppColors.color2E303C,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 12, 22, 12),
            child: Row(
              children: [
                _buildHeadingItemShimmerWidget(),
                Spacer(),
                _buildHeadingItemShimmerWidget(),
                Spacer(),
                _buildHeadingItemShimmerWidget(),
                Spacer(),
                _buildHeadingItemShimmerWidget(),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.color1C2023,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadingItemShimmerWidget() => Container(
        decoration: BoxDecoration(
          color: AppColors.color1C2023,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text('000000000'),
      );
}
