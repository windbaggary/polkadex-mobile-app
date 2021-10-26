import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/dummy_providers/balance_chart_dummy_provider.dart';
import 'package:polkadex/features/balance/screens/balance_deposit_screen_1.dart';
import 'package:polkadex/features/balance/screens/coin_withdraw_screen.dart';
import 'package:polkadex/features/notifications/screens/notif_deposit_screen.dart';
import 'package:polkadex/features/trade/screens/coin_trade_screen.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/build_methods.dart';
import 'package:polkadex/common/widgets/chart/_app_line_chart_widget.dart';
import 'package:polkadex/common/widgets/custom_app_bar.dart';
import 'package:polkadex/common/widgets/custom_date_range_picker.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

/// The screen enum menus only accessing inside this file.
/// The enum represent the first top 3 menu of the screen
///
enum _EnumMenus {
  deposit,
  withdraw,
  trade,
}

/// XD_PAGE: 20
/// XD_PAGE: 31
class BalanceCoinPreviewScreen extends StatefulWidget {
  @override
  _BalanceCoinPreviewScreenState createState() =>
      _BalanceCoinPreviewScreenState();
}

class _BalanceCoinPreviewScreenState extends State<BalanceCoinPreviewScreen>
    with TickerProviderStateMixin {
  final _isShowGraphNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<_ThisListDataProvider>(
          create: (_) => _ThisListDataProvider(),
        ),
        ChangeNotifierProvider<BalanceChartDummyProvider>(
          create: (_) => BalanceChartDummyProvider(),
        ),
      ],
      builder: (context, _) => Scaffold(
        backgroundColor: color1C2023,
        body: SafeArea(
          child: CustomAppBar(
            title: 'Polkadex (DEX)',
            titleStyle: tsS19W700CFF,
            onTapBack: () => Navigator.of(context).pop(),
            child: Container(
              decoration: BoxDecoration(
                color: color1C2023,
                borderRadius: BorderRadius.only(topRight: Radius.circular(40)),
              ),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 30, bottom: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InkWell(
                        onTap: () {
                          _isShowGraphNotifier.value =
                              !_isShowGraphNotifier.value;
                        },
                        child: _TopCoinTitleWidget()),
                    ValueListenableBuilder<bool>(
                      valueListenable: _isShowGraphNotifier,
                      builder: (context, isShowGraph, child) {
                        Widget child = Container();
                        if (isShowGraph) {
                          child = Column(
                            children: [
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
                                      yAxisBottomPaddingRatio: 0.00,
                                      chartScale: provider.chartScale,
                                      lineColor: colorE6007A,
                                      yAxisLabelPrefix: "",
                                      areaGradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: <Color>[
                                          colorE6007A.withOpacity(0.50),
                                          color8BA1BE.withOpacity(0.0),
                                        ],
                                        // stops: [0.0, 0.40],
                                      ),
                                      gridColor: color8BA1BE.withOpacity(0.15),
                                      gridStroke: 1,
                                      yLabelTextStyle: TextStyle(
                                        fontSize: 08,
                                        fontFamily: "WorkSans",
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              _ThisGraphOptionWidget(),
                              // SizedBox(height: 0),
                            ],
                          );
                        }
                        return AnimatedSize(
                          duration: AppConfigs.animDurationSmall,
                          child: child,
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(21, 42, 21, 0.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: buildInkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BalanceDepositScreenOne())),
                              child: _ThisMenuItemWidget(
                                menu: _EnumMenus.deposit,
                              ),
                            ),
                          ),
                          SizedBox(
                              width: math.min(16.0,
                                  MediaQuery.of(context).size.width * 0.025)),
                          Expanded(
                            child: buildInkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        CoinWithdrawScreen()));
                              },
                              child: _ThisMenuItemWidget(
                                menu: _EnumMenus.withdraw,
                              ),
                            ),
                          ),
                          SizedBox(
                              width: math.min(16.0,
                                  MediaQuery.of(context).size.width * 0.025)),
                          Expanded(
                            child: buildInkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => CoinTradeScreen()));
                              },
                              child: _ThisMenuItemWidget(
                                menu: _EnumMenus.trade,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 21, bottom: 12, top: 42),
                      child: Text(
                        "Trade Pairs",
                        style: tsS20W600CFF,
                      ),
                    ),
                    SizedBox(
                      height: 108,
                      child: ListView.builder(
                        itemBuilder: (context, index) =>
                            _ThisTopPairsItemWidget(),
                        itemCount: 20,
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(left: 21),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(21, 52, 21, 20.0),
                      child: Row(
                        children: [
                          Text(
                            "History",
                            style: tsS20W600CFF,
                          ),
                          Spacer(),
                          ..._EnumListTypes.values
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: InkWell(
                                    onTap: () {
                                      context
                                          .read<_ThisListDataProvider>()
                                          .filterType = e;
                                    },
                                    child: Consumer<_ThisListDataProvider>(
                                      builder: (context, thisProvider, child) {
                                        String svg;
                                        Color color =
                                            color8BA1BE.withOpacity(0.2);
                                        switch (e) {
                                          case _EnumListTypes.buy:
                                            if (thisProvider.filterType == e) {
                                              svg = "buysel";
                                              color = Colors.white;
                                            } else {
                                              svg = "buy";
                                            }
                                            break;
                                          case _EnumListTypes.sell:
                                            if (thisProvider.filterType == e) {
                                              svg = "sellsel";
                                              color = Colors.white;
                                            } else {
                                              svg = "sell";
                                            }
                                            break;
                                          case _EnumListTypes.deposit:
                                            if (thisProvider.filterType == e) {
                                              svg = "Depositsel";
                                              color = Colors.white;
                                            } else {
                                              svg = "Deposit";
                                            }
                                            break;
                                          case _EnumListTypes.withdraw:
                                            if (thisProvider.filterType == e) {
                                              svg = "Withdrawsel";
                                              color = Colors.white;
                                            } else {
                                              svg = "Withdraw";
                                            }
                                            break;
                                        }

                                        return Container(
                                          width: 36,
                                          height: 36,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 7.0, horizontal: 9),
                                          decoration: BoxDecoration(
                                              color: color,
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: SvgPicture.asset(
                                            svg.asAssetSvg(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          SizedBox(width: 14),
                          Theme(
                            data: Theme.of(context).copyWith(
                                primaryColor: color1C2023,
                                cardColor: Colors.red,
                                colorScheme: ColorScheme.fromSwatch()
                                    .copyWith(secondary: colorE6007A),
                                buttonTheme: ButtonThemeData(
                                    highlightColor: Colors.green,
                                    buttonColor: Colors.green,
                                    textTheme: ButtonTextTheme.accent)),
                            child: Builder(
                              builder: (context) => InkWell(
                                onTap: () async {
                                  final provider =
                                      context.read<_ThisListDataProvider>();
                                  await CustomDateRangePicker.call(
                                          filterStartDate:
                                              provider.filterStartDate,
                                          filterEndDate: provider.filterEndDate,
                                          context: context)
                                      .then((dates) {
                                    if (dates != null) {
                                      provider.setFilterDates(
                                          dates.start, dates.end);
                                    }
                                  });
                                },
                                child: Consumer<_ThisListDataProvider>(
                                  builder: (context, provider, child) =>
                                      Container(
                                    width: 36,
                                    height: 36,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 7.0, horizontal: 9),
                                    decoration: BoxDecoration(
                                        color: provider.hasFilterDate
                                            ? colorE6007A
                                            : color8BA1BE.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: SvgPicture.asset(
                                      'calendar'.asAssetSvg(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: color2E303C,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: <BoxShadow>[bsDefault],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Consumer<_ThisListDataProvider>(
                        builder: (context, provider, child) {
                          String? fromToDate;
                          if (provider.filterStartDate != null &&
                              provider.filterEndDate != null) {
                            fromToDate =
                                "${DateFormat("MMM dd, yyyy").format(provider.filterStartDate!)} to ${DateFormat("MMM dd, yyyy").format(provider.filterEndDate!)}";
                          }
                          if (provider.dummyList.isEmpty) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(18, 26.0, 18, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    fromToDate ?? "",
                                    style: tsS16W500CFF,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 36, bottom: 36),
                                    child: Text(
                                      "There are no transactions",
                                      style: tsS16W500CABB2BC,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: provider.dummyList.length,
                            padding: const EdgeInsets.only(top: 13),
                            itemBuilder: (context, index) {
                              String? title;
                              if (index == 0) {
                                if (provider.filterStartDate != null) {
                                  title = fromToDate!;
                                } else {
                                  title = _getDateTitle(
                                      provider.dummyList[index].date);
                                }
                              } else {
                                final previousModel =
                                    provider.dummyList[index - 1];
                                final model = provider.dummyList[index];
                                if (DateFormat.yMd()
                                        .format(previousModel.date) !=
                                    DateFormat.yMd().format(model.date)) {
                                  title = _getDateTitle(model.date);
                                }
                              }
                              return _ThisItemWidget(
                                model: provider.dummyList[index],
                                dateTitle: title,
                              );
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getDateTitle(DateTime date) {
    final today = DateTime.now();
    if (date.day == today.day &&
        date.month == today.month &&
        date.year == today.year) {
      return "Today";
    } else if (date.day == today.day - 1 &&
        date.month == today.month &&
        date.year == today.year) {
      return "Yesterday";
    } else {
      return DateFormat("dd MMMM, yyyy").format(date);
    }
  }
}

/// The base class for the list item
class _ThisItemWidget extends StatelessWidget {
  final _IBaseModel model;
  final String? dateTitle;

  const _ThisItemWidget({
    required this.model,
    required this.dateTitle,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Container();
    switch (model.type) {
      case _EnumListTypes.buy:
        child = _buildBuyWidget(model as _ThisBuyModel);
        break;
      case _EnumListTypes.sell:
        child = _buildSellWidget(model as _ThisSellModel);
        break;
      case _EnumListTypes.deposit:
        child = _buildDepositWidget(model as _ThisDepositModel);
        break;
      case _EnumListTypes.withdraw:
        child = _buildWithdrawWidget(model as _ThisWithdrawModel);
        break;
    }

    final cardWidget = Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: buildInkWell(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.fromLTRB(14, 17, 14, 17),
            child: child,
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => NotifDepositScreen(
                      screenType: EnumDepositScreenTypes.deposit,
                    )));
          }),
    );

    if (dateTitle?.isNotEmpty ?? false) {
      final double topPadding =
          ['Today', 'Yesterday'].contains(dateTitle) ? 7.0 : 26.0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(18, topPadding, 18, 10),
            child: Text(
              dateTitle ?? "",
              style: tsS16W500CFF,
            ),
          ),
          cardWidget,
        ],
      );
    }

    return cardWidget;
  }

  Widget _buildBuyWidget(_ThisBuyModel iModel) {
    return Row(
      children: [
        Container(
          width: 47,
          height: 47,
          margin: const EdgeInsets.only(right: 4.2),
          padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 13),
          decoration: BoxDecoration(
              color: color8BA1BE.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12)),
          child: SvgPicture.asset(
            'buy'.asAssetSvg(),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                iModel.name ?? "",
                style: tsS15W500CFF,
              ),
              SizedBox(height: 1),
              Text(
                DateFormat("hh:mm:ss aa").format(iModel.date).toUpperCase(),
                style: tsS13W400CFFOP60.copyWith(color: colorABB2BC),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Text(
                  iModel.fromUnit ?? "",
                  style: tsS14W500CFF.copyWith(
                    color: color0CA564,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 4.0,
                  ),
                  child: SvgPicture.asset(
                    'Arrow-Green'.asAssetSvg(),
                    width: 10,
                    height: 6.0,
                  ),
                ),
                Text(
                  iModel.fromUnit ?? "",
                  style: tsS14W500CFF,
                ),
              ],
            ),
            SizedBox(height: 1),
            Text(
              iModel.fromUnit ?? "",
              style: tsS13W400CFFOP60.copyWith(
                color: colorABB2BC,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSellWidget(_ThisSellModel iModel) {
    return Row(
      children: [
        Container(
          width: 47,
          height: 47,
          margin: const EdgeInsets.only(right: 4.2),
          padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 13),
          decoration: BoxDecoration(
              color: color8BA1BE.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12)),
          child: SvgPicture.asset(
            'sell'.asAssetSvg(),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                iModel.name ?? "",
                style: tsS15W500CFF,
              ),
              SizedBox(height: 1),
              Text(
                DateFormat("hh:mm:ss aa").format(iModel.date).toUpperCase(),
                style: tsS13W400CFFOP60.copyWith(color: colorABB2BC),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Text(
                  iModel.fromUnit ?? "",
                  style: tsS14W500CFF.copyWith(
                    color: colorE6007A,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 4.0,
                  ),
                  child: SvgPicture.asset(
                    'Arrow-Red'.asAssetSvg(),
                    width: 10,
                    height: 6.0,
                  ),
                ),
                Text(
                  iModel.fromUnit ?? "",
                  style: tsS14W500CFF,
                ),
              ],
            ),
            SizedBox(height: 1),
            Text(
              iModel.point ?? "",
              style: tsS13W400CFFOP60.copyWith(
                color: colorABB2BC,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDepositWidget(_ThisDepositModel iModel) {
    return Row(
      children: [
        Container(
          width: 47,
          height: 47,
          margin: const EdgeInsets.only(right: 4.2),
          padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 13),
          decoration: BoxDecoration(
              color: color8BA1BE.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12)),
          child: SvgPicture.asset(
            'Deposit'.asAssetSvg(),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                iModel.name ?? "",
                style: tsS15W500CFF,
              ),
              SizedBox(height: 1),
              Text(
                DateFormat("hh:mm:ss aa").format(iModel.date).toUpperCase(),
                style: tsS13W400CFFOP60.copyWith(color: colorABB2BC),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              iModel.unit ?? "",
              style: tsS14W500CFF.copyWith(
                color: color0CA564,
              ),
            ),
            SizedBox(height: 1),
            Text(
              iModel.amount ?? "",
              style: tsS13W400CFFOP60.copyWith(
                color: colorABB2BC,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWithdrawWidget(_ThisWithdrawModel iModel) {
    return Row(
      children: [
        Container(
          width: 47,
          height: 47,
          margin: const EdgeInsets.only(right: 4.2),
          padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 13),
          decoration: BoxDecoration(
              color: color8BA1BE.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12)),
          child: SvgPicture.asset(
            'Withdraw'.asAssetSvg(),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                iModel.name ?? "",
                style: tsS15W500CFF,
              ),
              SizedBox(height: 1),
              Text(
                DateFormat("hh:mm:ss aa").format(iModel.date).toUpperCase(),
                style: tsS13W400CFFOP60.copyWith(color: colorABB2BC),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              iModel.unit ?? "",
              style: tsS14W500CFF.copyWith(
                color: colorE6007A,
              ),
            ),
            SizedBox(height: 1),
            Text(
              iModel.amount ?? "",
              style: tsS13W400CFFOP60.copyWith(
                color: colorABB2BC,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// The item widget for the top menu
/// [_EnumMenus] are represented in this widget
class _ThisMenuItemWidget extends StatelessWidget {
  const _ThisMenuItemWidget({
    required this.menu,
  });

  final _EnumMenus menu;

  @override
  Widget build(BuildContext context) {
    String text;
    String svgAssets;
    switch (menu) {
      case _EnumMenus.deposit:
        text = "Deposit";
        svgAssets = "Deposit".asAssetSvg();

        break;
      case _EnumMenus.withdraw:
        text = "Withdraw";
        svgAssets = "Withdraw".asAssetSvg();
        break;
      case _EnumMenus.trade:
        text = "Trade";
        svgAssets = "trade_selected".asAssetSvg();
        break;
    }
    return Container(
      decoration: BoxDecoration(
        color: color2E303C.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[bsDefault],
      ),
      padding: const EdgeInsets.fromLTRB(0, 17, 0.0, 21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 47,
              height: 47,
              padding:
                  const EdgeInsets.symmetric(vertical: 9.0, horizontal: 12),
              decoration: BoxDecoration(
                  color: color8BA1BE.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12)),
              child: SvgPicture.asset(
                svgAssets,
              ),
            ),
          ),
          SizedBox(height: 36),
          Text(text, style: tsS16W500CFF),
        ],
      ),
    );
  }
}

/// The content widget for the Top Pairs
class _ThisTopPairsItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: buildInkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => CoinTradeScreen()));
        },
        child: Container(
          decoration: BoxDecoration(
            color: color2E303C.withOpacity(0.30),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.fromLTRB(16, 16, 14, 16.0),
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RichText(
                    text: TextSpan(style: tsS14W400CFF, children: <TextSpan>[
                  TextSpan(
                      text: 'DEX/',
                      style: TextStyle(
                        fontFamily: 'WorkSans',
                      )),
                  TextSpan(
                    text: 'USDT',
                    style: tsS16W700CFF,
                  ),
                ])),
                SizedBox(height: 16),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price',
                          style: tsS14W400CFFOP50,
                        ),
                        SizedBox(height: 4),
                        Text(
                          '42.50',
                          style: tsS16W600CFF,
                        ),
                      ],
                    ),
                    SizedBox(width: 36),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price',
                          style: tsS14W400CFFOP50,
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: SvgPicture.asset(
                                'gain_graph'.asAssetSvg(),
                                width: 11,
                                height: 8,
                                color: color0CA564,
                              ),
                            ),
                            Text(
                              ' 12.47%',
                              style: tsS17W600C0CA564,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The very top top widget includes the icon, name, value, price, etc
class _TopCoinTitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: colorFFFFFF,
            ),
            width: 52,
            height: 52,
            padding: const EdgeInsets.all(3),
            child: Image.asset(
              'trade_open/trade_open_2.png'.asAssetImg(),
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '2.0000',
                  style: tsS25W500CFF,
                ),
                SizedBox(height: 1),
                Row(
                  children: [
                    Text(
                      '~\$76.12',
                      style: tsS15W400CFF.copyWith(color: colorABB2BC),
                    ),
                    SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: color0CA564,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 1.5,
                        horizontal: 3.5,
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'gain_graph'.asAssetSvg(),
                            width: 8,
                            height: 7,
                            color: colorFFFFFF,
                          ),
                          SizedBox(width: 2),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: "12.57",
                                  style: tsS13W600CFF,
                                ),
                                TextSpan(
                                  text: "%",
                                  style: tsS13W600CFF.copyWith(fontSize: 9),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$42.50',
                style: tsS13W600CFF,
              ),
              SizedBox(height: 02),
              Text(
                'Market Price',
                style: tsS13W500CFF.copyWith(color: colorABB2BC),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The widget displays the options under the graph
class _ThisGraphOptionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 10, 16, 14),
      child: Wrap(
        children: EnumBalanceChartDataTypes.values
            .map<Widget>((item) => Consumer<BalanceChartDummyProvider>(
                  builder: (context, appChartProvider, child) {
                    String? text;
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

enum _EnumListTypes {
  buy,
  sell,
  deposit,
  withdraw,
}

/// The base class for the items in the screen. This model is inherited for the
/// types like Buy, Sell, Deposit, Withdraw models
abstract class _IBaseModel {
  final DateTime date;
  final _EnumListTypes type;

  const _IBaseModel({required this.date, required this.type});
}

class _ThisBuyModel extends _IBaseModel {
  final String? name;
  final String? fromUnit;
  final String? toUnit;
  final String? point;

  const _ThisBuyModel({
    required this.name,
    required this.fromUnit,
    required this.toUnit,
    required this.point,
    required DateTime dateTime,
  }) : super(
          date: dateTime,
          type: _EnumListTypes.buy,
        );
}

class _ThisSellModel extends _IBaseModel {
  final String? name;
  final String? fromUnit;
  final String? toUnit;
  final String? point;

  const _ThisSellModel({
    required this.name,
    required this.fromUnit,
    required this.toUnit,
    required this.point,
    required DateTime dateTime,
  }) : super(
          date: dateTime,
          type: _EnumListTypes.sell,
        );
}

class _ThisDepositModel extends _IBaseModel {
  final String? unit;
  final String? amount;

  const _ThisDepositModel({
    required this.unit,
    required this.amount,
    required DateTime dateTime,
  }) : super(
          date: dateTime,
          type: _EnumListTypes.deposit,
        );

  String? get name => "Deposit";
}

class _ThisWithdrawModel extends _IBaseModel {
  final String? unit;
  final String? amount;

  const _ThisWithdrawModel({
    required this.unit,
    required this.amount,
    required DateTime dateTime,
  }) : super(
          date: dateTime,
          type: _EnumListTypes.withdraw,
        );

  String? get name => "Withdraw";
}

final _dummyList = <_IBaseModel>[
  _ThisDepositModel(
    unit: '+ 1.0000 DOT',
    amount: '~\$42.50',
    dateTime: DateTime.now().add(
      const Duration(
        hours: -1,
      ),
    ),
  ),
  _ThisWithdrawModel(
    unit: '- 1.0000 DOT',
    amount: '~\$42.50',
    dateTime: DateTime.now().add(
      const Duration(
        hours: -1,
      ),
    ),
  ),
  _ThisBuyModel(
    name: 'DOT/BTC',
    fromUnit: '0.431 DOT',
    toUnit: '0.486 BTC',
    point: '0.036820',
    dateTime: DateTime.now().add(
      const Duration(
        hours: -1,
      ),
    ),
  ),
  _ThisSellModel(
    name: 'DOT/BTC',
    fromUnit: '0.451 DOT',
    toUnit: '0.436 BTC',
    point: '0.0320',
    dateTime: DateTime.now().add(
      const Duration(
        hours: -1,
      ),
    ),
  ),
  _ThisDepositModel(
    unit: '+ 1.000 DOT',
    amount: '~\$42.50',
    dateTime: DateTime.now().add(
      const Duration(
        hours: -1,
        days: -1,
        minutes: -10,
      ),
    ),
  ),
  _ThisWithdrawModel(
    unit: '- 1.000 DOT',
    amount: '~\$42.50',
    dateTime: DateTime.now().add(
      const Duration(
        hours: -1,
        days: -1,
        minutes: -10,
      ),
    ),
  ),
  _ThisBuyModel(
    name: 'DOT/BTC',
    fromUnit: '0.431 DOT',
    toUnit: '0.486 BTC',
    point: '0.6820',
    dateTime: DateTime.now().add(
      const Duration(
        hours: -1,
        days: -2,
        minutes: -10,
      ),
    ),
  ),
  _ThisSellModel(
    name: 'DOT/BTC',
    fromUnit: '0.461 DOT',
    toUnit: '0.896 BTC',
    point: '0.0820',
    dateTime: DateTime.now().add(
      const Duration(
        hours: -1,
        days: -2,
        minutes: -10,
      ),
    ),
  ),
]..sort((c, p) => p.date.toIso8601String().compareTo(c.date.toIso8601String()));

/// The provider handle the bottom list.
class _ThisListDataProvider extends ChangeNotifier {
  DateTime? _filterStartDate, _filterEndDate;
  _EnumListTypes? _filterType;

  _EnumListTypes? get filterType => _filterType;
  DateTime? get filterStartDate => _filterStartDate;
  DateTime? get filterEndDate => _filterEndDate;

  bool get hasFilterDate =>
      (filterStartDate != null) && (filterEndDate != null);

  set filterType(_EnumListTypes? value) {
    if (_filterType == value) {
      _filterType = null;
    } else {
      _filterType = value;
    }
    notifyListeners();
  }

  /// The method set the filter date for list.
  void setFilterDates(DateTime start, DateTime end) {
    _filterStartDate = DateTime(start.year, start.month, start.day);
    _filterEndDate = DateTime(end.year, end.month, end.day);
    notifyListeners();
  }

  List<_IBaseModel> get dummyList {
    final list = List<_IBaseModel>.from(_dummyList);
    if (filterStartDate != null) {
      list.removeWhere((m) {
        final compare = DateTime(m.date.year, m.date.month, m.date.day)
            .compareTo(filterStartDate!);
        return compare < 0;
      });
    }
    if (filterEndDate != null) {
      list.removeWhere((m) {
        final compare = DateTime(m.date.year, m.date.month, m.date.day)
            .compareTo(filterEndDate!);

        return compare > 0;
      });
    }

    if (_filterType != null) {
      list.removeWhere((model) => model.type != _filterType);
    }

    return list;
  }
}
