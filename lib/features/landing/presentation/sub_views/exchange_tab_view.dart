import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/features/balance/screens/balance_coin_preview_screen.dart';
import 'package:polkadex/features/landing/data/models/home_models.dart';
import 'package:polkadex/features/landing/presentation/providers/exchange_loading_provider.dart';
import 'package:polkadex/features/landing/presentation/providers/exchange_tab_view_provider.dart';
import 'package:polkadex/features/landing/presentation/providers/home_scroll_notif_provider.dart';
import 'package:polkadex/features/trade/screens/coin_trade_screen.dart';
import 'package:polkadex/features/trade/widgets/card_flip_widgett.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_list_animated_widget.dart';
import 'package:polkadex/common/widgets/build_methods.dart';
import 'package:polkadex/common/utils/maps.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

/// XD_PAGE: 23
class ExchangeTabView extends StatefulWidget {
  /// A callback to handle the bottom navigation bar
  final Function(EnumBottonBarItem val) onBottombarItemSel;

  /// The tab controller to maintain the state
  final TabController tabController;

  const ExchangeTabView({
    required this.onBottombarItemSel,
    required this.tabController,
  });

  @override
  _ExchangeTabViewState createState() => _ExchangeTabViewState();
}

class _ExchangeTabViewState extends State<ExchangeTabView>
    with TickerProviderStateMixin {
  /// The animation controller for screen entry animations
  late AnimationController _animationController;

  /// The animtion controller for hide/expant alt coins on top selection
  late AnimationController _altCoinAnimationController;

  /// A scroll controller for the list
  late ScrollController _scrollController;

  /// A value notifier for hiding the appbar
  late ValueNotifier<double> _scrollHideNotifier;

  /// An animation for the alt section expand hide
  late Animation<double> _altHeightAnimation;

  EnumExchangeFilter _selectedExchangeFilter = EnumExchangeFilter.dex;

  @override
  void initState() {
    _scrollHideNotifier = ValueNotifier<double>(1.0);
    _scrollController = ScrollController()..addListener(_onScrollChanged);
    _animationController = AnimationController(
      vsync: this,
      duration: AppConfigs.animDuration,
      reverseDuration: AppConfigs.animReverseDuration,
    );

    _altCoinAnimationController = AnimationController(
      vsync: this,
      duration: AppConfigs.animDurationSmall,
    );
    _altHeightAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _altCoinAnimationController,
        curve: Curves.decelerate,
      ),
    );
    super.initState();
    Future.microtask(() => _animationController.forward().orCancel);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _altCoinAnimationController.dispose();
    _scrollController.removeListener(_onScrollChanged);
    _scrollController.dispose();
    _scrollHideNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ExchangeTabViewProvider>(
          create: (_) => ExchangeTabViewProvider(),
        ),
        ChangeNotifierProvider<ExchangeLoadingProvider>(
          create: (_) => ExchangeLoadingProvider()..initLoadingTimer(),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: NestedScrollView(
              controller: _scrollController,
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                AnimatedBuilder(
                  animation: _altHeightAnimation,
                  builder: (context, _) {
                    return ValueListenableBuilder<double>(
                      valueListenable: _scrollHideNotifier,
                      builder: (context, scrollHideVal, child) {
                        return SliverPersistentHeader(
                          pinned: true,
                          delegate: _SliverPersistentHeaderDelegate(
                            height: 98.0 +
                                (31.0 * _altHeightAnimation.value) +
                                (14.0 * scrollHideVal),
                            child: Container(
                              color: color1C2023,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  AnimatedPadding(
                                    duration: AppConfigs.animDurationSmall,
                                    padding: (const EdgeInsets.fromLTRB(
                                            12, 14, 12, 0)) *
                                        scrollHideVal,
                                    child: _ThisFilterHeadingWidget(
                                      initial: _selectedExchangeFilter,
                                      onSelected: (val) {
                                        _selectedExchangeFilter = val;
                                        if (val ==
                                            EnumExchangeFilter.altCoins) {
                                          if (_altCoinAnimationController
                                                  .status !=
                                              AnimationStatus.completed) {
                                            _altCoinAnimationController
                                              ..reset()
                                              ..forward().orCancel;
                                          }
                                        } else {
                                          _altCoinAnimationController
                                              .reverse()
                                              .orCancel;
                                        }
                                      },
                                    ),
                                  ),
                                  _ThisHeaderWidget(),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
              body: Consumer<ExchangeLoadingProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return Shimmer.fromColors(
                      highlightColor: color8BA1BE,
                      baseColor: color2E303C,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: List.generate(
                                4, (index) => _ThisLoadingItem())),
                      ),
                    );
                  } else {
                    return Consumer<ExchangeTabViewProvider>(
                      builder: (context, provider, child) => ListView.builder(
                        itemBuilder: (context, index) =>
                            AppHeightFactorAnimatedWidget(
                          index: index,
                          child: _ThisListItemWidget(
                            model: provider.list[index],
                          ),
                          animationController: _animationController,
                          interval: Interval(
                            0.35,
                            1.00,
                            curve: Curves.decelerate,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        itemCount: provider.list.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          // Consumer<HomeScrollNotifProvider>(
          //   builder: (context, homeScrollProvider, child) {
          //     return Container(
          //       height: homeScrollProvider.bottombarSize -
          //           homeScrollProvider.bottombarValue,
          //       child: SingleChildScrollView(
          //         physics: NeverScrollableScrollPhysics(),
          //         child: Container(
          //           transform: Matrix4.identity(),
          //           height: homeScrollProvider.bottombarSize,
          //           child: AppBottomNavigationBar(
          //             onSelected: widget.onBottombarItemSel,
          //             initialItem:
          //                 EnumBottonBarItem.values[widget.tabController.index],
          //           ),
          //         ),
          //       ),
          //     );
          //   },
          // )
        ],
      ),
    );
  }

  /// A call back for the scroll controller to hide the appbar
  void _onScrollChanged() {
    _scrollHideNotifier.value =
        1.0 - (_scrollController.offset / 60).clamp(0.0, 1.0);
    context.read<HomeScrollNotifProvider>().scrollOffset =
        _scrollController.offset;
  }
}

/// The persistent widget to maintain the top selettion on top while scrolling
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

/// The top filter selection heading
class _ThisFilterHeadingWidget extends StatelessWidget {
  /// A value notifier for the selection
  final ValueNotifier<EnumExchangeFilter> _selectedNotifier;

  /// A callbadk for the selection
  final Function(EnumExchangeFilter val)? onSelected;

  /// A initial selection
  final EnumExchangeFilter initial;

  /// Set to true to show the submenu under the widget
  final ValueNotifier<bool> _isShowSubMenuNotifier;

  _ThisFilterHeadingWidget({
    required this.initial,
    this.onSelected,
  })  : _selectedNotifier = ValueNotifier<EnumExchangeFilter>(initial),
        _isShowSubMenuNotifier =
            ValueNotifier<bool>(initial == EnumExchangeFilter.altCoins);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: color2E303C,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(22),
              bottomLeft: Radius.circular(22),
              bottomRight: Radius.circular(22),
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04,
            vertical: 15,
          ),
          child: Row(
            children: [
              Row(
                children: EnumExchangeFilter.values
                    .map((e) => _buildItemBuilder(e))
                    .toList(),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  context
                      .read<ExchangeTabViewProvider>()
                      .toggleFavoriteFilter();
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  width: 18,
                  height: 17,
                  child: Consumer<ExchangeTabViewProvider>(
                    builder: (context, provider, child) => Opacity(
                      opacity: provider.isFavoriteFilter ? 1.0 : 0.4,
                      child: child,
                    ),
                    child: SvgPicture.asset(
                      'star-filled'.asAssetSvg(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _isShowSubMenuNotifier,
          builder: (context, isShowSubMenu, child) => AnimatedSwitcher(
            duration: AppConfigs.animDurationSmall,
            reverseDuration: AppConfigs.animDurationSmall,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                child: child,
              ),
            ),
            child: isShowSubMenu ? _ThisSubMenuFilterWidget() : Container(),
          ),
        ),
      ],
    );
  }

  Widget _buildItemBuilder(EnumExchangeFilter e) {
    return ValueListenableBuilder<EnumExchangeFilter>(
        valueListenable: _selectedNotifier,
        builder: (context, selectedValue, child) => InkWell(
              onTap: () {
                _selectedNotifier.value = e;
                _isShowSubMenuNotifier.value =
                    (e == EnumExchangeFilter.altCoins);
                if (onSelected != null) {
                  onSelected!(e);
                }
              },
              child: _ThisFilterItemWidget(
                  item: e, isSelected: e == selectedValue),
            ));
  }
}

/// The sub menu filter wdget. This will be displayed if tapped on alt coins
class _ThisSubMenuFilterWidget extends StatelessWidget {
  final _items = <String>[
    'ETH',
    'TRX',
    'XRP',
    'ADA',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        color: color24252C,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.only(
        left: 22,
        bottom: 8,
        top: 8.0,
      ),
      child: SingleChildScrollView(
        child: Row(
          children: _items
              .map((e) => Padding(
                    padding: const EdgeInsets.only(right: 29),
                    child: Text(
                      e,
                      style: tsS15W400CFFOP50,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

/// The item of the top filter widget
class _ThisFilterItemWidget extends StatelessWidget {
  const _ThisFilterItemWidget({
    required this.isSelected,
    required this.item,
  });

  final bool isSelected;
  final EnumExchangeFilter item;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: AppConfigs.animDurationSmall,
          decoration: BoxDecoration(
            color: isSelected ? colorE6007A : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 9),
          child: AnimatedDefaultTextStyle(
            duration: AppConfigs.animDurationSmall,
            child: Text(enumExchangeToString[item]!),
            style: isSelected ? tsS15W600CFF : tsS15W400CFF,
          ),
        ),
      ],
    );
  }
}

class _ThisHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 22),
            child: Text(
              "Pair",
              style: tsS13W500CFFOP40,
            ),
          ),
          Spacer(),
          Text(
            "Price",
            style: tsS13W500CFFOP40,
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.07),
          Padding(
            padding: const EdgeInsets.only(right: 56, left: 30),
            child: Text(
              "Change",
              style: tsS13W500CFFOP40,
            ),
          ),
        ],
      ),
    );
  }
}

/// The item widget which will be displayed in list view
class _ThisListItemWidget extends StatelessWidget {
  final BasicCoinListModel model;
  const _ThisListItemWidget({required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: buildInkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CoinTradeScreen(
              enumInitalCardFlipState: EnumCardFlipState.showFirst,
            ),
          ));
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: color2E303C.withOpacity(0.30),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.fromLTRB(11, 17, 0, 16),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: colorFFFFFF,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: EdgeInsets.all(3),
                child: Image.asset(
                  model.imgAsset,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                              text: TextSpan(children: <TextSpan>[
                            TextSpan(
                              text: model.code,
                              style: tsS15W500CFF,
                            ),
                            TextSpan(
                              text: '/${model.token}',
                              style: tsS11W400CABB2BC,
                            ),
                          ])),
                        ),
                        SizedBox(width: 8),
                        Text(
                          model.amount,
                          style: tsS15W500CFF,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'VOL \$${model.volume} BTC',
                            style: tsS12W400CFF.copyWith(
                              color: colorABB2BC.withOpacity(0.70),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '1 BTC',
                          style: tsS12W400CFF.copyWith(
                            color: colorABB2BC.withOpacity(0.70),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [],
              // ),
              // Spacer(),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [],
              // ),
              SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  color: model.color,
                  borderRadius: BorderRadius.circular(7),
                ),
                padding: const EdgeInsets.all(5),
                child: RichText(
                    text: TextSpan(children: <TextSpan>[
                  TextSpan(
                    text: model.percentage,
                    style: tsS15W500CFF,
                  ),
                  TextSpan(
                    text: '%',
                    style: tsS10W500CFF,
                  ),
                ])),
              ),
              InkWell(
                onTap: () {
                  context
                      .read<ExchangeTabViewProvider>()
                      .toggleFavoriteItem(model);
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  width: 15 + 17.0,
                  height: 15 + 8.0,
                  padding:
                      const EdgeInsets.only(right: 12, top: 4.0, bottom: 4.0),
                  child: Opacity(
                    opacity: model.isFavorite ? 1.0 : 0.40,
                    child: SvgPicture.asset(
                      'star-filled'.asAssetSvg(),
                    ),
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

class _ThisLoadingItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: buildInkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BalanceCoinPreviewScreen(),
          ));
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: color2E303C.withOpacity(0.30),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.fromLTRB(11, 17, 0, 16),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: colorFFFFFF,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: EdgeInsets.all(3),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 50,
                      height: 15,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 4),
                    Container(
                      width: 50,
                      height: 8,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    color: Colors.grey,
                    height: 15,
                    width: 50,
                  ),
                  SizedBox(height: 4),
                  Container(
                    height: 8,
                    width: 50,
                    color: Colors.grey,
                  ),
                ],
              ),
              SizedBox(width: 16),
              Container(
                width: 50,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(7),
                ),
                padding: const EdgeInsets.all(5),
              ),
              Container(
                margin: const EdgeInsets.only(left: 8),
                width: 15 + 17.0,
                height: 15 + 8.0,
                padding:
                    const EdgeInsets.only(right: 17, top: 4.0, bottom: 4.0),
                child: Opacity(
                  opacity: 1.0,
                  child: SvgPicture.asset(
                    'star-filled'.asAssetSvg(),
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
