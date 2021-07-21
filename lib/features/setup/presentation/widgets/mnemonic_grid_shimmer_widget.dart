import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:shimmer/shimmer.dart';

class MnemonicGridShimmerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: color8BA1BE,
      baseColor: color2E303C,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: GridView.count(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          primary: false,
          childAspectRatio: (120 / (AppConfigs.size!.height * 0.0572)),
          crossAxisSpacing: 7,
          mainAxisSpacing: 7,
          crossAxisCount: 3,
          children: List<Widget>.generate(
            24,
            (_) => Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
