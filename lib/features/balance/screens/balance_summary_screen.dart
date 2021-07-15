import 'package:flutter/material.dart';
import 'package:polkadex/configs/app_config.dart';
import 'package:polkadex/features/balance/widgets/app_circle_chart_graph_widget.dart';
import 'package:polkadex/utils/colors.dart';
import 'package:polkadex/utils/extensions.dart';
import 'package:polkadex/utils/styles.dart';
import 'package:polkadex/widgets/custom_app_bar.dart';

/// XD_PAGE: 30
/// XD_PAGE: 32
class BalanceSummaryScreen extends StatelessWidget {
  final _selIndexNotifier = ValueNotifier<int?>(null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1C2023,
      body: SafeArea(
        child: CustomAppBar(
          title: 'Summary',
          titleStyle: tsS19W700CFF,
          onTapBack: () => Navigator.of(context).pop(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ValueListenableBuilder<int?>(
                valueListenable: _selIndexNotifier,
                builder: (context, selIndex, child) =>
                    AppCircleChartGraphWidget(
                  child: _ThisProgressContentWidget(
                    selIndex: selIndex,
                  ),
                  list: _DUMMY_LIST,
                  selectedIndex: selIndex,
                ),
              ),
              SizedBox(height: 24),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: color1C2023,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(21, 22, 21, 0),
                  child: ListView.builder(
                    itemBuilder: (context, index) =>
                        ValueListenableBuilder<int?>(
                      valueListenable: this._selIndexNotifier,
                      builder: (context, selIndex, child) => InkWell(
                        onTap: () {
                          if (selIndex == index) {
                            _selIndexNotifier.value = null;
                          } else {
                            _selIndexNotifier.value = index;
                          }
                        },
                        child: _ThisItemWidget(
                          model: _DUMMY_LIST[index],
                          isSelected: selIndex == index,
                        ),
                      ),
                    ),
                    itemCount: _DUMMY_LIST.length,
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

class _ThisProgressContentWidget extends StatelessWidget {
  const _ThisProgressContentWidget({
    required this.selIndex,
  });

  final int? selIndex;

  @override
  Widget build(BuildContext context) {
    final crossFadeState = this.selIndex != null
        ? CrossFadeState.showSecond
        : CrossFadeState.showFirst;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: color1C2023,
              child: AnimatedSwitcher(
                child: crossFadeState == CrossFadeState.showFirst
                    ? _ThisSummaryTopWidget()
                    : _ThisSummaryTopSelWidget(selIndex: selIndex!),
                duration: AppConfigs.animDurationSmall,
                layoutBuilder: (currentChild, previousChildren) =>
                    currentChild!,
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.black.withOpacity(0.550),
              child: AnimatedSwitcher(
                child: crossFadeState == CrossFadeState.showFirst
                    ? _ThisSummaryBottomWidget()
                    : _ThisCummaryBottomSelWidget(selIndex: selIndex),
                duration: AppConfigs.animDurationSmall,
                layoutBuilder: (currentChild, previousChildren) =>
                    currentChild!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The widget will be shown on the bottom section of summary cart in pie chart
/// This widge is visible when user has any selection of index [selIndex]
class _ThisCummaryBottomSelWidget extends StatelessWidget {
  const _ThisCummaryBottomSelWidget({
    required this.selIndex,
  });

  final int? selIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 2),
        Text(
          "DEX/BTC",
          style: tsS13W500CFF.copyWith(color: colorABB2BC),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 2),
        Text(
          "0.7662",
          style: tsS22W500CFF.copyWith(color: color0CA564),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Align(
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              color: color0CA564,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(3),
            child: Text(
              "+54.09%",
              style: tsS13W600CFF,
            ),
          ),
        ),
      ],
    );
  }
}

/// The widget will be shown on the top section of summary cart in pie chart
/// This widge is visible when user has any selection of index [selIndex]
class _ThisSummaryTopSelWidget extends StatelessWidget {
  const _ThisSummaryTopSelWidget({
    required this.selIndex,
  });
  final int selIndex;

  @override
  Widget build(BuildContext context) {
    final iModel = _DUMMY_LIST[selIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 16),
        Text(
          "${((iModel.iPerc) * 100).toStringAsFixed(0)}%",
          style: tsS14W500CFF,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          iModel.name ?? "",
          style: tsS26W500CFF,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          "${iModel.unit ?? ""} ${iModel.code ?? ""}",
          style: tsS14W500CFF.copyWith(color: colorABB2BC),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// The widget in summary pie chart card.
/// This widget is as the content of the bottom part when no selection are made
class _ThisSummaryBottomWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: tsS22W600CFF,
            children: <TextSpan>[
              TextSpan(
                text: '0.8713 ',
                style: TextStyle(
                  fontFamily: 'WorkSans',
                ),
              ),
              TextSpan(
                text: 'BTC',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'WorkSans',
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: tsS14W400CFF.copyWith(color: colorABB2BC),
            children: <TextSpan>[
              TextSpan(
                text: '~437.50 ',
                style: TextStyle(
                  fontFamily: 'WorkSans',
                ),
              ),
              TextSpan(
                text: 'BTC',
                style: TextStyle(
                  fontSize: 9,
                  fontFamily: 'WorkSans',
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

/// This is the content widget on the summary pie chart
/// This is shown on the top section of th pie chart when no selection are made
class _ThisSummaryTopWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 16),
        Text(
          '5',
          style: tsS31W500CFF,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text(
          'Tokens',
          style: tsS15W500CFF.copyWith(color: colorABB2BC),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// The widget represents the each items in the list of the screen
class _ThisItemWidget extends StatelessWidget {
  final _ThisModel model;
  final bool isSelected;
  const _ThisItemWidget({
    required this.model,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = color1F1F1F.withOpacity(0.80);
    Color codeColor = colorFFFFFF.withOpacity(0.5);
    if (isSelected) {
      bgColor = colorE6007A;
      codeColor = colorFFFFFF;
    }
    return AnimatedContainer(
      duration: AppConfigs.animDurationSmall,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(13, 14, 20, 16),
      child: Row(
        children: [
          Center(
            child: Container(
              width: 11,
              height: 11,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: model.color,
              ),
            ),
          ),
          SizedBox(width: 6),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: colorFFFFFF,
            ),
            width: 42,
            height: 42,
            padding: const EdgeInsets.all(3),
            child: Image.asset(
              model.imgAsset.asAssetImg(),
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  model.name ?? "",
                  style: tsS16W500CFF,
                ),
                SizedBox(height: 1.5),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "${model.unit} ",
                        style: tsS13W500CFF,
                      ),
                      TextSpan(
                        text: model.code ?? "",
                        style: tsS13W500CFF.copyWith(
                          color: codeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Text(
              "${model.perc.toStringAsFixed(0)}%",
              style: tsS16W500CFF,
            ),
          ),
        ],
      ),
    );
  }
}

// Remove the dummy data below
class _ThisModel implements IAppCircleChartModel {
  final String imgAsset;
  final String? name;
  final String? code;
  final String? unit;
  final double perc;
  final Color color;

  const _ThisModel({
    required this.imgAsset,
    required this.name,
    required this.code,
    required this.unit,
    required this.perc,
    required this.color,
  });

  @override
  Color get iColor => this.color;

  @override
  double get iPerc => this.perc / 100;
}

const _DUMMY_LIST = <_ThisModel>[
  _ThisModel(
    imgAsset: 'trade_open/trade_open_1.png',
    name: 'Ethereum',
    code: 'ETH',
    unit: '0.8621',
    perc: 60,
    color: const Color(0xFFFFB100),
  ),
  _ThisModel(
    imgAsset: 'trade_open/trade_open_2.png',
    name: 'Polkadex',
    code: 'DEX',
    unit: '2.0000',
    perc: 22,
    color: const Color(0xFF11A564),
  ),
  _ThisModel(
    imgAsset: 'trade_open/trade_open_8.png',
    name: 'Bitcoin',
    code: 'BTC',
    unit: '0.8621',
    perc: 10,
    color: Color(0xFF2785F2),
  ),
  _ThisModel(
    imgAsset: 'trade_open/trade_open_6.png',
    name: 'Litecoin',
    code: 'LTC',
    unit: '0.7739',
    perc: 6,
    color: Color(0xFF7B1EE8),
  ),
  _ThisModel(
    imgAsset: 'trade_open/trade_open_1.png',
    name: 'Ethereum',
    code: 'ETH',
    unit: '0.8621',
    perc: 2,
    color: const Color(0xFFABB2BC),
  ),
];
