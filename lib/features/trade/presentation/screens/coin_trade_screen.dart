import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:k_chart/chart_style.dart';
import 'package:k_chart/k_chart_widget.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/dummy_providers/app_chart_dummy_provider.dart';
import 'package:polkadex/common/market_asset/domain/entities/asset_entity.dart';
import 'package:polkadex/common/utils/time_utils.dart';
import 'package:polkadex/common/widgets/polkadex_progress_error_widget.dart';
import 'package:polkadex/features/landing/domain/entities/ticker_entity.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
import 'package:polkadex/features/landing/presentation/cubits/ticker_cubit/ticker_cubit.dart';
import 'package:polkadex/features/landing/utils/token_utils.dart';
import 'package:polkadex/features/trade/presentation/cubits/coin_graph_cubit.dart';
import 'package:polkadex/features/trade/presentation/cubits/coin_graph_state.dart';
import 'package:polkadex/features/trade/presentation/widgets/card_flip_widgett.dart';
import 'package:polkadex/features/trade/presentation/widgets/coin_graph_shimmer_widget.dart';
import 'package:polkadex/common/orderbook/presentation/widgets/order_book_widget.dart';
import 'package:polkadex/common/orderbook/presentation/cubit/orderbook_cubit.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:polkadex/injection_container.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class CoinTradeScreen extends StatefulWidget {
  const CoinTradeScreen({
    required this.leftToken,
    required this.rightToken,
    this.enumInitalCardFlipState = EnumCardFlipState.showFirst,
  });

  final EnumCardFlipState enumInitalCardFlipState;
  final AssetEntity leftToken;
  final AssetEntity rightToken;

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
      builder: (context, _) => MultiBlocProvider(
        providers: [
          BlocProvider<CoinGraphCubit>(
            create: (_) => dependency<CoinGraphCubit>()
              ..loadGraph(
                widget.leftToken.assetId,
                widget.rightToken.assetId,
              ),
          ),
          BlocProvider<OrderbookCubit>(
            create: (_) => dependency<OrderbookCubit>()
              ..fetchOrderbookData(
                leftTokenId: widget.leftToken.assetId,
                rightTokenId: widget.rightToken.assetId,
              ),
          ),
        ],
        child: Scaffold(
          backgroundColor: AppColors.color1C2023,
          body: SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.color2E303C,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: _ThisAppBar(
                      leftToken: widget.leftToken,
                      rightToken: widget.rightToken,
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.color2E303C,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                        ),
                        child: Consumer<_ThisOrderDisplayProvider>(
                          builder: (context, orderDisplayProvider, _) =>
                              CardFlipAnimation(
                            duration: AppConfigs.animDuration,
                            firstChild: _ThisGraphCard(
                              leftToken: widget.leftToken,
                              rightToken: widget.rightToken,
                            ),
                            secondChild: _ThisDetailCard(
                              leftToken: widget.leftToken,
                              rightToken: widget.rightToken,
                            ),
                            cardState: orderDisplayProvider.enumCoinDisplay,
                          ),
                        ),
                      ),
                    ],
                  ),
                  OrderBookWidget(
                    amountToken: widget.leftToken,
                    priceToken: widget.rightToken,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The detail card on top that flip. This card list the details about the coin
class _ThisDetailCard extends StatelessWidget {
  const _ThisDetailCard({
    required this.leftToken,
    required this.rightToken,
  });

  final AssetEntity leftToken;
  final AssetEntity rightToken;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.color2E303C,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.color1C2023,
              borderRadius: BorderRadius.circular(35),
            ),
            padding: const EdgeInsets.fromLTRB(25, 22, 22, 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TopCoinWidget(
                  leftToken: leftToken,
                  rightToken: rightToken,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 21.0,
                    bottom: 8,
                  ),
                  child: Text(
                    'About Polkadex'.toUpperCase(),
                    style: tsS12W500CFF.copyWith(
                      color: AppColors.colorFFFFFF.withOpacity(0.6),
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
                      color: AppColors.colorFFFFFF.withOpacity(0.6),
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
                      color: AppColors.colorFFFFFF.withOpacity(0.6),
                    ),
                  ),
                ),
                Row(
                  children: [
                    _buildLinkItem(
                      title: "Website",
                      svgIcon: "browser".asAssetSvg(),
                      onTap: () => _navigateToLink(
                          Uri.parse('https://www.polkadex.trade')),
                    ),
                    SizedBox(width: 12),
                    _buildLinkItem(
                      title: "Twitter",
                      svgIcon: "twitter".asAssetSvg(),
                      onTap: () =>
                          _navigateToLink(Uri.parse('https://twitter.com')),
                    ),
                    SizedBox(width: 12),
                    _buildLinkItem(
                      title: "Telegram",
                      svgIcon: "telegram".asAssetSvg(),
                      onTap: () =>
                          _navigateToLink(Uri.parse('https://telegram.org')),
                    ),
                    SizedBox(width: 12),
                    _buildLinkItem(
                      title: "Discord",
                      svgIcon: "discord".asAssetSvg(),
                      onTap: () =>
                          _navigateToLink(Uri.parse('https://discord.com/')),
                    ),
                    SizedBox(width: 12),
                    _buildLinkItem(
                      title: "Reddit",
                      svgIcon: "reddit".asAssetSvg(),
                      onTap: () =>
                          _navigateToLink(Uri.parse('https://reddit.com/')),
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
                    color: AppColors.colorE6007A,
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
                color: AppColors.color8BA1BE.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 8),
              child: SvgPicture.asset(svgIcon),
            ),
            Text(
              title ?? "",
              style: tsS12W400CFF.copyWith(
                color: AppColors.colorFFFFFF.withOpacity(0.60),
              ),
            ),
          ],
        ),
      );

  /// navigate to link on app browser
  void _navigateToLink(Uri link) async {
    try {
      if (await url_launcher.canLaunchUrl(link)) {
        url_launcher.launchUrl(link);
      }
    } catch (ex) {
      print(ex);
    }
  }
}

/// The card shows the graph on top section
class _ThisGraphCard extends StatelessWidget {
  _ThisGraphCard({
    required this.leftToken,
    required this.rightToken,
  });

  final AssetEntity leftToken;
  final AssetEntity rightToken;

  final ValueNotifier<EnumAppChartDataTypes> _dataTypeNotifier =
      ValueNotifier<EnumAppChartDataTypes>(EnumAppChartDataTypes.average);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.color2E303C,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.color1C2023,
              borderRadius: BorderRadius.circular(35),
            ),
            padding: const EdgeInsets.only(top: 22, bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 22),
                  child: BlocBuilder<TickerCubit, TickerState>(
                    builder: (context, state) {
                      return _TopCoinWidget(
                        leftToken: leftToken,
                        rightToken: rightToken,
                        ticker: state is TickerLoaded
                            ? state.ticker[
                                '${leftToken.assetId}-${rightToken.assetId}']
                            : null,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12.0,
                    bottom: 2,
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: double.infinity,
                    child: BlocBuilder<CoinGraphCubit, CoinGraphState>(
                      builder: (context, state) {
                        if (state is CoinGraphLoaded) {
                          return ValueListenableBuilder<EnumAppChartDataTypes>(
                              valueListenable: _dataTypeNotifier,
                              builder: (context, dataType, _) {
                                return Material(
                                    type: MaterialType.transparency,
                                    child: KChartWidget(
                                      state.dataList,
                                      ChartStyle(),
                                      ChartColors()
                                        ..upColor = AppColors.color0CA564
                                        ..dnColor = AppColors.colorE6007A,
                                      mainState: MainState.NONE,
                                      secondaryState: SecondaryState.NONE,
                                      isTrendLine: false,
                                      volHidden: true,
                                      fixedLength: 6,
                                      timeFormat:
                                          TimeFormat.YEAR_MONTH_DAY_WITH_HOUR,
                                      isTapShowInfoDialog: true,
                                      maDayList: [1, 100, 1000],
                                    ));
                              });
                        }

                        if (state is CoinGraphError) {
                          return PolkadexErrorRefreshWidget(
                              onRefresh: () =>
                                  context.read<CoinGraphCubit>().loadGraph(
                                        leftToken.assetId,
                                        rightToken.assetId,
                                      ));
                        }

                        return CoinGraphShimmerWidget();
                      },
                    ),
                  ),
                ),
                _ThisGraphOptionWidget(
                  leftToken: leftToken,
                  rightToken: rightToken,
                  dataTypeNotifier: _dataTypeNotifier,
                ),
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
                    color: AppColors.color8BA1BE.withOpacity(0.3),
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

class _ThisGraphOptionWidget extends StatelessWidget {
  _ThisGraphOptionWidget({
    required this.leftToken,
    required this.rightToken,
    required this.dataTypeNotifier,
  });

  final AssetEntity leftToken;
  final AssetEntity rightToken;
  final ValueNotifier<EnumAppChartDataTypes> dataTypeNotifier;

  @override
  Widget build(BuildContext context) {
    double containerWidth = 38;
    if (MediaQuery.of(context).size.width <= 385) {
      containerWidth = 30;
    }

    return Center(
      child: SizedBox(
        height: 36 + 10 + 14.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [Colors.white, Colors.white.withOpacity(0.05)],
                    stops: [0.9, 1],
                    tileMode: TileMode.mirror,
                  ).createShader(bounds);
                },
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 10, 16, 14),
                    child: BlocBuilder<CoinGraphCubit, CoinGraphState>(
                      builder: (context, state) {
                        return Row(
                          children: [
                            ...EnumAppChartTimestampTypes.values.map<Widget>(
                              (item) {
                                return InkWell(
                                  onTap: () =>
                                      context.read<CoinGraphCubit>().loadGraph(
                                            leftToken.assetId,
                                            rightToken.assetId,
                                            timestampSelected: item,
                                          ),
                                  child: AnimatedContainer(
                                    duration: AppConfigs.animDurationSmall,
                                    width: containerWidth,
                                    height: containerWidth,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: state.timestampSelected == item
                                          ? AppColors.colorE6007A
                                          : null,
                                    ),
                                    child: Text(
                                      _timestampToUiString(item),
                                      style: tsS13W600CFF,
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _timestampToUiString(EnumAppChartTimestampTypes timestamp) {
    String timestampString = TimeUtils.timestampTypeToString(timestamp);

    if (timestamp != EnumAppChartTimestampTypes.oneMonth) {
      timestampString = timestampString.toLowerCase();
    }

    return timestampString;
  }
}

class _ThisAppBar extends StatelessWidget {
  const _ThisAppBar({
    required this.leftToken,
    required this.rightToken,
  });

  final AssetEntity leftToken;
  final AssetEntity rightToken;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<_ThisOrderDisplayProvider>();
    List<Widget> actions = <Widget>[];
    switch (provider.enumCoinDisplay) {
      case EnumCardFlipState.showFirst:
        actions = [
          Icon(
            Icons.more_vert,
            color: AppColors.colorFFFFFF,
          ),
          SizedBox(width: 8),
        ];
        break;
      case EnumCardFlipState.showSecond:
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
            color: AppColors.colorFFFFFF,
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
              text: leftToken.symbol,
              style: tsS19W700CFF,
            ),
            TextSpan(
              text: " /${rightToken.symbol}",
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
  const _TopCoinWidget({
    required this.leftToken,
    required this.rightToken,
    this.ticker,
  });

  final AssetEntity leftToken;
  final AssetEntity rightToken;
  final TickerEntity? ticker;

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
              child: SvgPicture.asset(
                TokenUtils.tokenIdToAssetSvg(leftToken.assetId),
              ),
            ),
            SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    leftToken.name,
                    style: tsS13W400CFFOP60,
                  ),
                  BlocBuilder<BalanceCubit, BalanceState>(
                    builder: (context, state) {
                      return state is BalanceLoaded
                          ? Text(
                              '${state.free.getBalance(leftToken.assetId)}',
                              style: tsS26W500CFF,
                            )
                          : _amountCoinTradeShimmer();
                    },
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
                        color: AppColors.colorFFFFFF.withOpacity(0.6)),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'HIGH ',
                        style: TextStyle(
                          fontFamily: 'WorkSans',
                        ),
                      ),
                      TextSpan(
                          text: ticker?.high.toStringAsFixed(2),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.color0CA564,
                            fontFamily: 'WorkSans',
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: tsS12W500CFF.copyWith(
                      color: AppColors.colorFFFFFF.withOpacity(
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
                          text: ticker?.low.toStringAsFixed(2),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorE6007A,
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
              ticker?.priceChange24Hr.toStringAsFixed(2) ?? '',
              style: tsS20W500CFF,
            ),
            Container(
              decoration: BoxDecoration(
                  color: AppColors.color0CA564,
                  borderRadius: BorderRadius.circular(4)),
              padding: const EdgeInsets.fromLTRB(4, 3, 6, 4),
              margin: const EdgeInsets.only(left: 4),
              child: RichText(
                text: TextSpan(
                  style: tsS10W600CFF,
                  children: [
                    TextSpan(
                      text: ticker?.priceChangePercent24Hr.toStringAsFixed(2),
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
                      color: AppColors.colorFFFFFF.withOpacity(0.6),
                      fontFamily: 'WorkSans',
                    ),
                  ),
                  TextSpan(
                      text: ticker?.volumeBase24hr.toStringAsFixed(4),
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

  Widget _amountCoinTradeShimmer() {
    return Shimmer.fromColors(
      highlightColor: AppColors.color8BA1BE,
      baseColor: AppColors.color2E303C,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black,
        ),
        child: Text(
          '0.0',
          style: tsS26W500CFF,
        ),
      ),
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
