import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/dummy_providers/balance_chart_dummy_provider.dart';
import 'package:polkadex/common/widgets/check_box_widget.dart';
import 'package:polkadex/features/balance/screens/balance_coin_preview_screen.dart';
import 'package:polkadex/features/balance/screens/balance_summary_screen.dart';
import 'package:polkadex/features/landing/providers/home_scroll_notif_provider.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/chart/_app_line_chart_widget.dart';
import 'package:provider/provider.dart';

/// XD_PAGE: 18
/// XD_PAGE: 19
class BalanceTabView extends StatefulWidget {
  @override
  _BalanceTabViewState createState() => _BalanceTabViewState();
}

class _BalanceTabViewState extends State<BalanceTabView>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_onScrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<_ThisIsChartVisibleProvider>(
            create: (_) => _ThisIsChartVisibleProvider()),
        ChangeNotifierProvider<_ThisProvider>(
          create: (_) => _ThisProvider(),
        ),
        ChangeNotifierProvider<BalanceChartDummyProvider>(
          create: (_) => BalanceChartDummyProvider(),
        ),
      ],
      builder: (context, _) => NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 24),
                  _ThisTopBalanceWidget(),
                  SizedBox(height: 36),
                  InkWell(
                      onTap: () {
                        context
                            .read<_ThisIsChartVisibleProvider>()
                            .toggleVisible();
                      },
                      child: _ThisHoldingWidget()),
                  Consumer<_ThisIsChartVisibleProvider>(
                    builder: (context, isChartVisbileProvider, _) =>
                        AnimatedSize(
                      vsync: this,
                      duration: AppConfigs.animDurationSmall,
                      alignment: Alignment.topCenter,
                      child: isChartVisbileProvider.isChartVisible
                          ? Column(
                              children: [
                                _ThisGraphHeadingWidget(),
                                SizedBox(height: 8),
                                SizedBox(
                                  height: 250,
                                  child: Consumer<BalanceChartDummyProvider>(
                                    builder: (context, provider, child) =>
                                        AppLineChartWidget(
                                      data: provider.list,
                                      options: AppLineChartOptions(
                                        yLabelCount: 3,
                                        yAxisTopPaddingRatio: 0.05,
                                        yAxisBottomPaddingRatio: 0.15,
                                        chartScale: provider.chartScale,
                                        lineColor: colorE6007A,
                                        yAxisLabelPrefix: "\$ ",
                                        areaGradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: <Color>[
                                            colorE6007A.withOpacity(0.50),
                                            color8BA1BE.withOpacity(0.0),
                                          ],
                                          // stops: [0.0, 0.40],
                                        ),
                                        gridColor:
                                            color8BA1BE.withOpacity(0.15),
                                        gridStroke: 1,
                                        yLabelTextStyle: TextStyle(
                                          fontSize: 08,
                                          fontFamily: "WorkSans",
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      context: context,
                                    ),
                                  ),
                                ),
                                _ThisGraphOptionWidget(),
                                SizedBox(height: 30),
                              ],
                            )
                          : Container(),
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: color2E303C,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: Offset(0.0, 20.0),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(12.5, 19.0, 12.5, 0.0),
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                floating: false,
                pinned: true,
                delegate: _SliverPersistentHeaderDelegate(
                  height: 115,
                  child: Container(
                    color: color2E303C,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 13),
                            decoration: BoxDecoration(
                              color: color1C2023,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 3,
                            width: 51,
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            height: 35,
                            child: DropdownButton<String>(
                              items: ['Main Wallet', 'Spot', 'Margin']
                                  .map((e) => DropdownMenuItem<String>(
                                        child: Text(
                                          e,
                                          style: tsS20W600CFF,
                                        ),
                                        value: e,
                                      ))
                                  .toList(),
                              value: 'Main Wallet',
                              style: tsS20W600CFF,
                              underline: Container(),
                              onChanged: (value) {},
                              isExpanded: false,
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: colorFFFFFF,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 12,
                            left: 10,
                            right: 10,
                          ),
                          child: Row(
                            children: [
                              Consumer<_ThisProvider>(
                                builder: (context, thisProvider, child) =>
                                    CheckBoxWidget(
                                  checkColor: colorFFFFFF,
                                  backgroundColor: colorE6007A,
                                  isChecked: thisProvider.isHideSmallBalance,
                                  isBackTransparentOnUnchecked: true,
                                  onTap: (val) =>
                                      thisProvider.isHideSmallBalance = val,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Hide small balances',
                                style: tsS14W400CFF,
                              ),
                              Spacer(),
                              InkWell(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 12, 6, 12),
                                  child: Opacity(
                                    opacity: 1.0,
                                    child: Text(
                                      'Tokens',
                                      style: tsS15W600CFF,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  final thisProvider =
                                      context.read<_ThisProvider>();
                                  thisProvider.isHideFiat =
                                      !thisProvider.isHideFiat;
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(6, 12, 12, 12),
                                  child: Consumer<_ThisProvider>(
                                    builder: (context, thisProvider, child) =>
                                        Opacity(
                                      opacity:
                                          thisProvider.isHideFiat ? 1.0 : 0.3,
                                      child: child,
                                    ),
                                    child: Text(
                                      'Fiat',
                                      style: tsS15W600CFF,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Consumer<_ThisProvider>(
                  builder: (context, thisProvider, child) => ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemBuilder: (context, index) => InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BalanceCoinPreviewScreen())),
                      child: _ThisItemWidget(
                        model: thisProvider.listCoins[index],
                      ),
                    ),
                    itemCount: thisProvider.listCoins.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onScrollListener() {
    context.read<HomeScrollNotifProvider>().scrollOffset =
        _scrollController.offset;
  }
}

/// The holding row widget handles the click event for graph
class _ThisHoldingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
        left: 21,
        right: 21,
      ),
      child: Row(
        children: [
          Text(
            'Holding: ',
            style: tsS13W500CFF.copyWith(
              color: colorABB2BC,
            ),
          ),
          DropdownButton<String>(
            items: ['24 hour', '1 week', '1 month']
                .map((e) => DropdownMenuItem<String>(
                      child: Text(
                        e,
                        style: tsS13W500CFF,
                      ),
                      value: e,
                    ))
                .toList(),
            value: '24 hour',
            style: tsS13W500CFF,
            underline: Container(),
            onChanged: (value) {},
            isExpanded: false,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: colorFFFFFF,
              size: 16,
            ),
          ),
          // Text(
          //   '24 hour ',
          //   style: tsS13W500CFF,
          // ),
          Spacer(),
          Text(
            'Change ',
            style: tsS13W500CFF.copyWith(
              color: colorABB2BC,
            ),
          ),
          Text(
            '+\$224',
            style: tsS13W500CFF,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: color0CA564,
            ),
            margin: const EdgeInsets.only(left: 8),
            padding: const EdgeInsets.symmetric(
              horizontal: 4.5,
              vertical: 2.5,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'gain_graph'.asAssetSvg(),
                  width: 8,
                  height: 8,
                ),
                SizedBox(width: 2),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '52.47',
                        style: tsS11W600CFF,
                      ),
                      TextSpan(
                        text: '%',
                        style: tsS8W600CFF,
                      ),
                    ],
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

/// The heading part of the graph.
class _ThisGraphHeadingWidget extends StatelessWidget {
  Widget _buildItemWidget(
      {required String? imgAsset,
      required String title,
      required String value}) {
    return Row(
      children: [
        Container(
          width: 23,
          height: 23,
          decoration: BoxDecoration(
            color: (imgAsset == null)
                ? color8BA1BE.withOpacity(0.20)
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.only(right: 6),
          padding: const EdgeInsets.all(2),
          child: (imgAsset == null) ? null : Image.asset(imgAsset),
        ),
        Expanded(
            child: Text(
          title,
          style: tsS13W500CFF.copyWith(color: colorABB2BC),
        )),
        Text(
          value,
          style: tsS12W500CFF,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(21, 0, 21, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Summary",
            style: tsS20W500CFF,
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            flex: 5,
                            child: _buildItemWidget(
                                imgAsset:
                                    'trade_open/trade_open_1.png'.asAssetImg(),
                                title: 'BTC',
                                value: "60%")),
                        Spacer(),
                        Expanded(
                            flex: 5,
                            child: _buildItemWidget(
                                imgAsset:
                                    'trade_open/trade_open_2.png'.asAssetImg(),
                                title: 'DEX',
                                value: "22%")),
                        Spacer(),
                      ],
                    ),
                    SizedBox(height: 7),
                    Row(
                      children: [
                        Expanded(
                            flex: 5,
                            child: _buildItemWidget(
                                imgAsset:
                                    'trade_open/trade_open_3.png'.asAssetImg(),
                                title: 'USDT',
                                value: "10%")),
                        Spacer(),
                        Expanded(
                            flex: 5,
                            child: _buildItemWidget(
                                imgAsset: null, title: 'Others', value: "8%")),
                        Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BalanceSummaryScreen(),
                  ));
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color8BA1BE.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset('pie-chart-18'.asAssetSvg()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The list item for the main wallet
class _ThisItemWidget extends StatelessWidget {
  final _ThisModel model;
  const _ThisItemWidget({
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(15, 14, 10, 14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
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
          SizedBox(width: 9),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name,
                style: tsS16W500CFF,
              ),
              Text(
                model.code,
                style: tsS13W500CFF.copyWith(color: colorABB2BC),
              ),
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                model.unit,
                style: tsS16W500CFF,
              ),
              Text(
                model.iPrice,
                style: tsS13W500CFF.copyWith(color: colorABB2BC),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The top balance widget showing the balance amount and wallet icon
class _ThisTopBalanceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: 42,
            height: 42,
            margin: const EdgeInsets.only(bottom: 9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: color8BA1BE.withOpacity(0.30),
            ),
            padding: const EdgeInsets.all(11),
            child: SvgPicture.asset('wallet_selected'.asAssetSvg()),
          ),
        ),
        Text(
          'Total Balance',
          style: tsS15W400CFF.copyWith(color: colorABB2BC),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: '0.8713 ',
                  style: tsS32W600CFF,
                ),
                TextSpan(
                  text: 'BTC ',
                  style: tsS15W600CFF,
                ),
              ],
            ),
          ),
        ),
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: '~437.50 ',
                style: tsS19W400CFF,
              ),
              TextSpan(
                text: 'USD',
                style: tsS12W400CFF,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The provider to maintain the hide and visible of charts
class _ThisIsChartVisibleProvider extends ChangeNotifier {
  bool _isChartVisible = false;

  bool get isChartVisible => _isChartVisible;

  set isChartVisible(bool value) {
    _isChartVisible = value;
    notifyListeners();
  }

  void toggleVisible() {
    _isChartVisible = !_isChartVisible;
    notifyListeners();
  }
}

/// The provider to handle the list filter on this screen.
class _ThisProvider extends ChangeNotifier {
  bool _isHideSmallBalance = true;
  bool _isHideFiat = false;

  bool get isHideFiat => _isHideFiat;

  bool get isHideSmallBalance => _isHideSmallBalance;

  set isHideSmallBalance(bool val) {
    _isHideSmallBalance = val;
    notifyListeners();
  }

  set isHideFiat(bool val) {
    _isHideFiat = val;
    notifyListeners();
  }

  List<_ThisModel> get listCoins {
    final list = List<_ThisModel>.from(_dummyList);
    if (isHideFiat) {
      list.removeWhere((e) => !e.iIsFiat);
    }
    if (isHideSmallBalance) {
      list.removeWhere((e) => !e.isSmallBalance);
    }
    return list;
  }
}

/// The bottom option menu unnder the graph
class _ThisGraphOptionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 16, 14),
      child: Wrap(
        children: EnumBalanceChartDataTypes.values
            .map<Widget>((item) => Consumer<BalanceChartDummyProvider>(
                  builder: (context, appChartProvider, child) {
                    String text;
                    switch (item) {
                      case EnumBalanceChartDataTypes.hour:
                        text = "24h";
                        break;
                      case EnumBalanceChartDataTypes.week:
                        text = "7d";
                        break;
                      case EnumBalanceChartDataTypes.month:
                        text = "1m";
                        break;
                      case EnumBalanceChartDataTypes.threeMonth:
                        text = "3m";

                        break;
                      case EnumBalanceChartDataTypes.sixMonth:
                        text = "6m";
                        break;
                      case EnumBalanceChartDataTypes.year:
                        text = "1y";
                        break;
                      case EnumBalanceChartDataTypes.all:
                        text = "All";
                        break;
                    }
                    return InkWell(
                      onTap: () {
                        appChartProvider.balanceChartDataType = item;
                      },
                      child: AnimatedContainer(
                        duration: AppConfigs.animDurationSmall,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 11.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: item == appChartProvider.balanceChartDataType
                              ? colorE6007A
                              : null,
                        ),
                        child: Text(
                          text,
                          style: item == appChartProvider.balanceChartDataType
                              ? tsS13W600CFF
                              : tsS12W400CFF.copyWith(color: colorABB2BC),
                        ),
                      ),
                    );
                  },
                ))
            .toList(),
      ),
    );
  }
}

/// The sliver widget to maintain the wallet heading persistent on scroll
class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _SliverPersistentHeaderDelegate({
    required this.child,
    required this.height,
  }) : super();
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant _SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}

// Remove the dummy data below

/// The model class for list item
class _ThisModel {
  final String imgAsset;
  final String name;
  final String code;
  final String unit;
  final double price;
  final bool isFiat;

  const _ThisModel({
    required this.imgAsset,
    required this.name,
    required this.code,
    required this.unit,
    required this.price,
    required this.isFiat,
  });

  bool get iIsFiat => isFiat;

  bool get isSmallBalance => price < 100.0;

  String get iPrice => '~\$${price.toStringAsFixed(2)}';
}

/// Creates the dummy data for the list
const _dummyList = <_ThisModel>[
  _ThisModel(
    imgAsset: 'trade_open/trade_open_1.png',
    name: 'Ethereum',
    code: 'ETH',
    unit: '0.8621',
    price: 182.29,
    isFiat: false,
  ),
  _ThisModel(
    imgAsset: 'trade_open/trade_open_2.png',
    name: 'Polkadex',
    code: 'DEX',
    unit: '2.0000',
    price: 76.29,
    isFiat: true,
  ),
  _ThisModel(
    imgAsset: 'trade_open/trade_open_8.png',
    name: 'Bitcoin',
    code: 'BTC',
    unit: '0.621',
    price: 12.29,
    isFiat: false,
  ),
  _ThisModel(
    imgAsset: 'trade_open/trade_open_6.png',
    name: 'Litecoin',
    code: 'LTC',
    unit: '0.7739',
    price: 134.29,
    isFiat: true,
  ),
  _ThisModel(
    imgAsset: 'trade_open/trade_open_1.png',
    name: 'Ethereum',
    code: 'ETH',
    unit: '0.62d1',
    price: 182.29,
    isFiat: false,
  ),
  _ThisModel(
    imgAsset: 'trade_open/trade_open_2.png',
    name: 'Polkadex',
    code: 'DEX',
    unit: '2.0000',
    price: 76.29,
    isFiat: true,
  ),
  _ThisModel(
    imgAsset: 'trade_open/trade_open_8.png',
    name: 'Bitcoin',
    code: 'BTC',
    unit: '0.6211',
    price: 12.29,
    isFiat: false,
  ),
  _ThisModel(
    imgAsset: 'trade_open/trade_open_6.png',
    name: 'Litecoin',
    code: 'LTC',
    unit: '0.7739',
    price: 134.29,
    isFiat: true,
  ),
];
