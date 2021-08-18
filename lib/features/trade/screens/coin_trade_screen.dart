import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/dummy_providers/app_chart_dummy_provider.dart';
import 'package:polkadex/features/landing/screens/landing_screen.dart';
import 'package:polkadex/features/trade/widgets/card_flip_widgett.dart';
import 'package:polkadex/features/trade/widgets/order_book_widget.dart';
import 'package:polkadex/common/providers/bottom_navigation_provider.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/common/widgets/build_methods.dart';
import 'package:polkadex/common/widgets/custom_date_range_picker.dart';
import 'package:provider/provider.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'dart:math' as math;
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:polkadex/common/widgets/chart/app_charts.dart' as app_charts;

/// XD_PAGE: 24
/// XD_PAGE: 25
/// XD_PAGE: 26
/// XD_PAGE: 27
/// XD_PAGE: 33
class CoinTradeScreen extends StatefulWidget {
  final EnumCardFlipState enumInitalCardFlipState;

  const CoinTradeScreen({
    this.enumInitalCardFlipState = EnumCardFlipState.showFirst,
  });
  @override
  _CoinTradeScreenState createState() => _CoinTradeScreenState();
}

class _CoinTradeScreenState extends State<CoinTradeScreen> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<OrderBookWidgetFilterProvider>(
            create: (context) => OrderBookWidgetFilterProvider()),
        ChangeNotifierProvider<_ThisOrderDisplayProvider>(
          create: (context) => _ThisOrderDisplayProvider(
            onEnumCoinDisplayListener: (enumState) {
              _scrollController.animateTo(0.0,
                  duration: AppConfigs.animDurationSmall,
                  curve: Curves.decelerate);
            },
            enumCoinDisplay: widget.enumInitalCardFlipState,
          ),
          lazy: false,
        ),
        ChangeNotifierProvider<AppChartDummyProvider>(
          create: (context) => AppChartDummyProvider(),
        ),
      ],
      builder: (context, _) => Scaffold(
        backgroundColor: color1C2023,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: color2E303C,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: _ThisAppBar(),
                    ),
                    ListView(
                      padding: const EdgeInsets.only(bottom: 88),
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: color2E303C,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                          ),
                          child: Consumer<_ThisOrderDisplayProvider>(
                            builder: (context, orderDisplayProvider, _) =>
                                CardFlipAnimation(
                              duration: AppConfigs.animDuration,
                              firstChild:
                                  // false
                                  //     ? InkWell(
                                  //         onTap: () {
                                  //           orderDisplayProvider.enumCoinDisplay =
                                  //               EnumCardFlipState.showSecond;
                                  //         },
                                  //         child: Container(
                                  //           margin: const EdgeInsets.all(32),
                                  //           key: ValueKey("one"),
                                  //           height: 250,
                                  //           color: colorE6007A,
                                  //         ),
                                  //       )
                                  //     :
                                  _ThisGrpahCard(),
                              secondChild:
                                  // false
                                  // ? InkWell(
                                  //     onTap: () {
                                  //       orderDisplayProvider.enumCoinDisplay =
                                  //           EnumCardFlipState.showFirst;
                                  //     },
                                  //     child: Container(
                                  //       margin: const EdgeInsets.all(32),
                                  //       key: ValueKey("two"),
                                  //       height: 250,
                                  //       color: color0CA564,
                                  //     ),
                                  //   )
                                  // :
                                  _ThisDetailCard(),
                              cardState: orderDisplayProvider.enumCoinDisplay,
                            ),
                          ),
                        ),
                        OrderBookHeadingWidget(),
                        OrderBookWidget(),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _ThisBottomNavigationBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The detail card on top that flip. This card list the details about the coin
class _ThisDetailCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color2E303C,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color1C2023,
              borderRadius: BorderRadius.circular(35),
            ),
            padding: const EdgeInsets.fromLTRB(25, 22, 22, 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TopCoinWidget(),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 21.0,
                    bottom: 8,
                  ),
                  child: Text(
                    'About Polkadex'.toUpperCase(),
                    style: tsS12W500CFF.copyWith(
                      color: colorFFFFFF.withOpacity(0.6),
                    ),
                  ),
                ),
                Text(
                  'We introduce Polkadex’s FSP (Fluid Switch Protocol). Polkadex is a hybrid DEX with an orderbook supported by an AMM pool. The first of its kind in the industry. Someone had to innovate. We are happy to do the dirty work. It may not be perfect, but we are sure that once implemented, it can solve the problem faced by DEXs paving the way for near-boundless liquidity and high guarantee of trades if supported by an efficient trading engine. The trading engine itself needs a separate look and it is a whole dedicated project in itself; hence it is covered in another medium article. Let’s stick to the core protocol here.',
                  style: tsS14W400CFF.copyWith(height: 1.5),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 29.0,
                    bottom: 12,
                  ),
                  child: Text(
                    'market stats'.toUpperCase(),
                    style: tsS12W500CFF.copyWith(
                      color: colorFFFFFF.withOpacity(0.6),
                    ),
                  ),
                ),
                _buildItem(title: "Marketcap", value: "\$1.78 Bn"),
                SizedBox(height: 12),
                _buildItem(title: "Circulation Supply", value: "\$1.8 mi"),
                SizedBox(height: 12),
                _buildItem(title: "Max Supply", value: "\$20 mi"),
                SizedBox(height: 12),
                _buildItem(title: "Rank", value: "5"),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 29.0,
                    bottom: 9,
                  ),
                  child: Text(
                    'Links'.toUpperCase(),
                    style: tsS12W500CFF.copyWith(
                      color: colorFFFFFF.withOpacity(0.6),
                    ),
                  ),
                ),
                Row(
                  children: [
                    _buildLinkItem(
                      title: "Website",
                      svgIcon: "browser".asAssetSvg(),
                      onTap: () =>
                          _navigateToLink("https://www.polkadex.trade"),
                    ),
                    SizedBox(width: 12),
                    _buildLinkItem(
                      title: "Twitter",
                      svgIcon: "twitter".asAssetSvg(),
                      onTap: () => _navigateToLink('http://twitter.com'),
                    ),
                    SizedBox(width: 12),
                    _buildLinkItem(
                      title: "Telegram",
                      svgIcon: "telegram".asAssetSvg(),
                      onTap: () => _navigateToLink('https://telegram.org'),
                    ),
                    SizedBox(width: 12),
                    _buildLinkItem(
                      title: "Discord",
                      svgIcon: "discord".asAssetSvg(),
                      onTap: () => _navigateToLink('http://discord.com/'),
                    ),
                    SizedBox(width: 12),
                    _buildLinkItem(
                      title: "Reddit",
                      svgIcon: "reddit".asAssetSvg(),
                      onTap: () => _navigateToLink('http://reddit.com/'),
                    ),
                    SizedBox(width: 12),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              final provider = context.read<_ThisOrderDisplayProvider>();
              provider.enumCoinDisplay = EnumCardFlipState.showFirst;
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: colorE6007A,
                  ),
                  child: Text(
                    "Coin Info",
                    style: tsS15W500CFF,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Build the item widget for Detaisl card
  Widget _buildItem({String? title, String? value}) => Row(
        children: [
          Expanded(
            child: Text(
              title ?? "",
              style: tsS14W400CFFOP50,
            ),
          ),
          Text(
            value ?? "",
            style: tsS14W600CFF,
          ),
          SizedBox(width: 16),
        ],
      );

  /// Build the item widget for social media links
  Widget _buildLinkItem({
    String? title,
    required String svgIcon,
    VoidCallback? onTap,
  }) =>
      InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color8BA1BE.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 8),
              child: SvgPicture.asset(svgIcon),
            ),
            Text(
              title ?? "",
              style: tsS12W400CFF.copyWith(
                color: colorFFFFFF.withOpacity(0.60),
              ),
            ),
          ],
        ),
      );

  /// navigate to link on app browser
  void _navigateToLink(String link) async {
    try {
      if (await url_launcher.canLaunch(link)) {
        url_launcher.launch(link);
      }
    } catch (ex) {
      print(ex);
    }
  }
}

/// The card shows the graph on top section
class _ThisGrpahCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color2E303C,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: color1C2023,
              borderRadius: BorderRadius.circular(35),
            ),
            padding: const EdgeInsets.only(top: 22, bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 22),
                  child: _TopCoinWidget(),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(25, 12, 22, 0.0),
                    child: _GraphHeadingWidget()),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12.0,
                    bottom: 2,
                  ),
                  child: SizedBox(
                    height: math.min(
                        250, MediaQuery.of(context).size.width * 0.450),
                    child: Consumer<AppChartDummyProvider>(
                      builder: (context, provider, _) =>
                          app_charts.AppLineChartWidget(
                        data: provider.list,
                        options: app_charts.AppLineChartOptions.withDefaults(
                          chartScale: provider.chartScale,
                          areaGradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              color8BA1BE.withOpacity(0.50),
                              color8BA1BE.withOpacity(0.0710),
                            ],
                          ),
                        ),
                        context: context,
                      ),
                    ),
                  ),
                ),
                _ThisGraphOptionWidget(),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              final provider = context.read<_ThisOrderDisplayProvider>();
              provider.enumCoinDisplay = EnumCardFlipState.showSecond;
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: color8BA1BE.withOpacity(0.3),
                  ),
                  child: Text(
                    "Coin Info",
                    style: tsS15W500CFF,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _GraphHeadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildItemWidget(title: "O:", value: "1243.0"),
        Spacer(),
        _buildItemWidget(title: "H:", value: "1500.0"),
        Spacer(),
        _buildItemWidget(title: "L:", value: "1600.0"),
        Spacer(),
        _buildItemWidget(title: "C:", value: "1700.0"),
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
            style: tsS12W500CFF.copyWith(
              color: color0CA564,
            ),
          ),
        ],
      );
}

class _ThisGraphOptionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double containerWidth = 38;
    double calendarPaddingRight = 16;
    if (MediaQuery.of(context).size.width <= 385) {
      containerWidth = 30;
      calendarPaddingRight = 12;
    }
    return Center(
      child: SizedBox(
        height: 36 + 10 + 14.0,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 16, 14),
            child: Row(
              children: [
                ...EnumAppChartDataTypes.values
                    .map<Widget>((item) => Consumer<AppChartDummyProvider>(
                          builder: (context, appChartProvider, child) {
                            String text;
                            switch (item) {
                              case EnumAppChartDataTypes.hour:
                                text = "1h";
                                break;
                              case EnumAppChartDataTypes.week:
                                text = "7d";
                                break;
                              case EnumAppChartDataTypes.day:
                                text = "1d";
                                break;
                              case EnumAppChartDataTypes.month:
                                text = "1m";
                                break;
                            }
                            return InkWell(
                              onTap: () {
                                appChartProvider.chartDataType = item;
                              },
                              child: AnimatedContainer(
                                duration: AppConfigs.animDurationSmall,
                                width: containerWidth,
                                height: containerWidth,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: item == appChartProvider.chartDataType
                                      ? colorE6007A
                                      : null,
                                ),
                                child: Text(
                                  text,
                                  style: tsS13W600CFF,
                                ),
                              ),
                            );
                          },
                        ))
                    .toList(),
                SizedBox(width: 8),
                InkWell(
                  onTap: () => _onDateTapped(context),
                  child: SizedBox(
                      width: 15,
                      height: 15,
                      child: SvgPicture.asset('calendar'.asAssetSvg())),
                ),
                SizedBox(width: calendarPaddingRight),
                // Spacer(),
                Container(
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: color8BA1BE.withOpacity(0.2),
                  ),
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: [
                      SvgPicture.asset('trade-candle'.asAssetSvg()),
                      SizedBox(width: 5),
                      Container(
                        width: 65,
                        child: ButtonTheme(
                          alignedDropdown: false,
                          child: DropdownButton<String>(
                            items: ['Trading', 'Trade 1', 'Trade 3']
                                .map((e) => DropdownMenuItem<String>(
                                      child: Text(
                                        e,
                                        style: tsS13W400CFF,
                                        textAlign: TextAlign.start,
                                      ),
                                      value: e,
                                    ))
                                .toList(),
                            value: 'Trading',
                            style: tsS13W400CFF,
                            underline: Container(),
                            onChanged: (val) {},
                            iconEnabledColor: Colors.white,
                            icon: Padding(
                              padding: const EdgeInsets.only(left: 2.0),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: colorFFFFFF,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: color8BA1BE.withOpacity(0.2),
                  ),
                  padding: const EdgeInsets.all(9),
                  child: SizedBox(
                      width: 15,
                      height: 15,
                      child: SvgPicture.asset('setting'.asAssetSvg())),
                ),
                SizedBox(width: 8),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: color8BA1BE.withOpacity(0.2),
                  ),
                  padding: const EdgeInsets.all(11),
                  child: SizedBox(
                      width: 15,
                      height: 15,
                      child: SvgPicture.asset('expand-screen'.asAssetSvg())),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onDateTapped(BuildContext context) async {
    final provider = context.read<AppChartDummyProvider>();
    await CustomDateRangePicker.call(
            filterStartDate: provider.filterStartDate,
            filterEndDate: provider.filterEndDate,
            context: context)
        .then((dates) {
      if (dates != null) {
        provider.setFilterDates(dates.start, dates.end);
      }
    });
  }
}

class _ThisBottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color2E303C,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0.0, -9.0),
          ),
        ],
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          // bottomLeft: Radius.circular(30),
          // bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(flex: 2),
          Center(
            child: buildInkWell(
              highlightColor: color0CA564,
              splashColor: color0CA564,
              borderRadius: BorderRadius.circular(17),
              onTap: () {
                BottomNavigationProvider().enumBottomBarItem =
                    EnumBottonBarItem.trade;
                Navigator.popUntil(
                    context, ModalRoute.withName(LandingScreen.routeName));
              },
              child: Container(
                width: math.max(MediaQuery.of(context).size.width * 0.30, 110),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(17),
                ),
                padding: const EdgeInsets.only(
                  left: 8,
                  top: 7,
                  bottom: 7,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 47,
                      height: 47,
                      decoration: BoxDecoration(
                        color: color8BA1BE.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        'tradeArrowsBuy'.asAssetSvg(),
                      ),
                    ),
                    Spacer(),
                    Text(
                      "Buy",
                      style: tsS16W500CFF,
                    ),
                    Spacer(flex: 2),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: buildInkWell(
                highlightColor: colorE6007A,
                splashColor: colorE6007A,
                borderRadius: BorderRadius.circular(17),
                onTap: () {
                  BottomNavigationProvider().enumBottomBarItem =
                      EnumBottonBarItem.trade;
                  Navigator.popUntil(
                      context, ModalRoute.withName(LandingScreen.routeName));
                },
                child: Container(
                  width:
                      math.max(MediaQuery.of(context).size.width * 0.30, 110),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  padding: const EdgeInsets.only(
                    left: 8,
                    top: 7,
                    bottom: 7,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 47,
                        height: 47,
                        decoration: BoxDecoration(
                          color: color8BA1BE.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: SvgPicture.asset(
                          'tradeArrows'.asAssetSvg(),
                        ),
                      ),
                      Spacer(),
                      Text(
                        "Sell",
                        style: tsS16W500CFF,
                      ),
                      Spacer(flex: 2),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Spacer(flex: 3),
          SizedBox(
            width: 23,
            height: 23,
            child: SvgPicture.asset(
              'trade'.asAssetSvg(),
              fit: BoxFit.contain,
            ),
          ),
          Spacer(flex: 3),
          SizedBox(
            width: 20,
            height: 20,
            child: SvgPicture.asset(
              'notification-on'.asAssetSvg(),
            ),
          ),
          Spacer(flex: 3),
          SizedBox(
            width: 20,
            height: 20,
            child: Opacity(
              opacity: 0.5,
              child: SvgPicture.asset(
                'star-filled'.asAssetSvg(),
              ),
            ),
          ),
          Spacer(flex: 3),
        ],
      ),
    );
  }
}

class _ThisAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<_ThisOrderDisplayProvider>();
    List<Widget> actions = <Widget>[];
    String text = "PDEX";
    switch (provider.enumCoinDisplay) {
      case EnumCardFlipState.showFirst:
        text = "PDEX";
        actions = [
          Icon(
            Icons.more_vert,
            color: colorFFFFFF,
          ),
          SizedBox(width: 8),
        ];
        break;
      case EnumCardFlipState.showSecond:
        text = "DEX";
        actions = [
          SizedBox(
            width: 20,
            height: 20,
            child: SvgPicture.asset(
              'notification-on'.asAssetSvg(),
            ),
          ),
          SizedBox(width: 14),
          SizedBox(
            width: 20,
            height: 20,
            child: Opacity(
              opacity: 0.5,
              child: SvgPicture.asset(
                'star-filled'.asAssetSvg(),
              ),
            ),
          ),
          SizedBox(width: 8),
          Icon(
            Icons.more_vert,
            color: colorFFFFFF,
          ),
          SizedBox(width: 8),
        ];
        break;
    }
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: _buildBackButton(context, () => Navigator.of(context).pop()),
      centerTitle: true,
      title: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: text,
              style: tsS19W700CFF,
            ),
            TextSpan(
              text: " /BTC",
              style: tsS13W500CFFOP50,
            ),
          ],
        ),
      ),
      actions: actions,
    );
  }

  Widget _buildBackButton(BuildContext context, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AppBackButton(
          onTap: onTap,
        ),
      ),
    );
  }
}

class _TopCoinWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: Image.asset(
                'trade_open/trade_open_2.png'.asAssetImg(),
              ),
            ),
            SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Polkadex',
                    style: tsS13W400CFFOP60,
                  ),
                  Text(
                    '0.0425',
                    style: tsS26W500CFF,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RichText(
                  text: TextSpan(
                    style: tsS12W500CFF.copyWith(
                        color: colorFFFFFF.withOpacity(0.6)),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'HIGH ',
                        style: TextStyle(
                          fontFamily: 'WorkSans',
                        ),
                      ),
                      TextSpan(
                          text: '\$34.31',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: color0CA564,
                            fontFamily: 'WorkSans',
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: tsS12W500CFF.copyWith(
                      color: colorFFFFFF.withOpacity(
                        0.6,
                      ),
                      fontFamily: 'WorkSans',
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'LOW ',
                        style: TextStyle(
                          fontFamily: 'WorkSans',
                        ),
                      ),
                      TextSpan(
                          text: '\$27.31',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: colorE6007A,
                            fontFamily: 'WorkSans',
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "\$0.0451",
              style: tsS20W500CFF,
            ),
            Container(
              decoration: BoxDecoration(
                  color: color0CA564, borderRadius: BorderRadius.circular(4)),
              padding: const EdgeInsets.fromLTRB(4, 3, 6, 4),
              margin: const EdgeInsets.only(left: 4),
              child: RichText(
                text: TextSpan(
                  style: tsS10W600CFF,
                  children: [
                    TextSpan(
                      text: '+53.47',
                      style: TextStyle(
                        fontFamily: 'WorkSans',
                      ),
                    ),
                    TextSpan(
                      text: '%',
                      style: TextStyle(
                        fontSize: 7,
                        fontFamily: 'WorkSans',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            RichText(
              text: TextSpan(
                style: tsS12W500CFF,
                children: [
                  TextSpan(
                    text: 'VOL(24h) ',
                    style: TextStyle(
                      color: colorFFFFFF.withOpacity(0.6),
                      fontFamily: 'WorkSans',
                    ),
                  ),
                  TextSpan(
                      text: '\$71,459.80',
                      style: TextStyle(
                        fontFamily: 'WorkSans',
                      )),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ThisOrderDisplayProvider extends ChangeNotifier {
  final OnEnumCoinDisplayListener? onEnumCoinDisplayListener;
  EnumCardFlipState _enumCoinDisplay = EnumCardFlipState.showFirst;

  _ThisOrderDisplayProvider({
    this.onEnumCoinDisplayListener,
    EnumCardFlipState enumCoinDisplay = EnumCardFlipState.showFirst,
  }) : super() {
    _enumCoinDisplay = enumCoinDisplay;
  }

  EnumCardFlipState get enumCoinDisplay => _enumCoinDisplay;

  set enumCoinDisplay(EnumCardFlipState val) {
    _enumCoinDisplay = val;
    if (onEnumCoinDisplayListener != null) {
      onEnumCoinDisplayListener!(val);
    }
    notifyListeners();
  }
}

typedef OnEnumCoinDisplayListener = void Function(EnumCardFlipState state);
