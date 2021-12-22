import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/styles.dart';

class GraphHeadingWidget extends StatelessWidget {
  const GraphHeadingWidget({
    this.open,
    this.high,
    this.low,
    this.close,
  });

  final double? open;
  final double? high;
  final double? low;
  final double? close;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildItemWidget(title: "O:", value: "${open ?? ' - '}"),
        Spacer(),
        _buildItemWidget(title: "H:", value: "${high ?? ' - '}"),
        Spacer(),
        _buildItemWidget(title: "L:", value: "${low ?? ' - '}"),
        Spacer(),
        _buildItemWidget(title: "C:", value: "${close ?? ' - '}"),
      ],
    );
  }

  Widget _buildItemWidget({String? title, String? value}) => Row(
        children: [
          Text(
            "${title ?? ""} ",
            style: tsS12W500CFF,
          ),
          Text(
            value ?? "",
            style: tsS12W500CFF,
          ),
        ],
      );
}
