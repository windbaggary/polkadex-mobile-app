import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/market_asset/domain/entities/asset_entity.dart';
import 'package:polkadex/features/landing/domain/entities/ticker_entity.dart';
import 'package:polkadex/common/market_asset/presentation/cubit/market_asset_cubit.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
import 'package:polkadex/features/landing/presentation/cubits/ticker_cubit/ticker_cubit.dart';
import 'package:polkadex/features/landing/presentation/providers/home_scroll_notif_provider.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_list_animated_widget.dart';
import 'package:polkadex/common/widgets/build_methods.dart';
import 'package:polkadex/common/utils/maps.dart';
import 'package:polkadex/features/landing/utils/token_utils.dart';

/// XD_PAGE: 23
class ExchangeTabView extends StatefulWidget {
  ExchangeTabView({required this.scrollController});

  final ScrollController scrollController;

  @override
  _ExchangeTabViewState createState() => _ExchangeTabViewState();
}

class _ExchangeTabViewState extends State<ExchangeTabView>
    with TickerProviderStateMixin {
  /// The animation controller for screen entry animations
  late AnimationController _animationController;

  /// The animtion controller for hide/expant alt coins on top selection
  late AnimationController _altCoinAnimationController;

  /// A value notifier for hiding the appbar
  late ValueNotifier<double> _scrollHideNotifier;

  /// An animation for the alt section expand hide
  late Animation<double> _altHeightAnimation;

  EnumExchangeFilter _selectedExchangeFilter = EnumExchangeFilter.dex;

  @override
  void initState() {
    _scrollHideNotifier = ValueNotifier<double>(1.0);
    widget.scrollController.addListener(_onScrollChanged);
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
    widget.scrollController.removeListener(_onScrollChanged);
    _scrollHideNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MarketAssetCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: NestedScrollView(
            controller: widget.scrollController,
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
                            color: AppColors.color1C2023,
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
                                      if (val == EnumExchangeFilter.altCoins) {
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
            body: BlocBuilder<TickerCubit, TickerState>(
              builder: (context, state) => ListView.builder(
                itemBuilder: (context, index) {
                  final baseAsset = cubit.listAvailableMarkets[index][0];
                  final quoteAsset = cubit.listAvailableMarkets[index][1];

                  return AppHeightFactorAnimatedWidget(
                    index: index,
                    child: _ThisListItemWidget(
                      baseAsset: baseAsset,
                      quoteAsset: quoteAsset,
                      ticker: state is TickerLoaded
                          ? state.ticker[
                              '${baseAsset.assetId}-${quoteAsset.assetId}']
                          : null,
                    ),
                    animationController: _animationController,
                    interval: Interval(
                      0.35,
                      1.00,
                      curve: Curves.decelerate,
                    ),
                  );
                },
                padding: EdgeInsets.symmetric(horizontal: 12),
                itemCount: cubit.listAvailableMarkets.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// A call back for the scroll controller to hide the appbar
  void _onScrollChanged() {
    _scrollHideNotifier.value =
        1.0 - (widget.scrollController.offset / 60).clamp(0.0, 1.0);
    context.read<HomeScrollNotifProvider>().scrollOffset =
        widget.scrollController.offset;
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
            color: AppColors.color2E303C,
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
        color: AppColors.color24252C,
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
            color: isSelected ? AppColors.colorE6007A : Colors.transparent,
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
          Padding(
            padding: const EdgeInsets.only(right: 22),
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
  const _ThisListItemWidget(
      {required this.baseAsset,
      required this.quoteAsset,
      required this.ticker});

  final AssetEntity baseAsset;
  final AssetEntity quoteAsset;
  final TickerEntity? ticker;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: buildInkWell(
        onTap: () => Coordinator.goToCoinTradeScreen(
          baseToken: baseAsset,
          quoteToken: quoteAsset,
          balanceCubit: context.read<BalanceCubit>(),
        ),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.color2E303C.withOpacity(0.30),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.fromLTRB(11, 17, 0, 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: EdgeInsets.all(3),
                child: SvgPicture.asset(
                  TokenUtils.tokenIdToAssetSvg(baseAsset.assetId),
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
                              text: baseAsset.symbol,
                              style: tsS15W500CFF,
                            ),
                            TextSpan(
                              text: '/${quoteAsset.symbol}',
                              style: tsS11W400CABB2BC,
                            ),
                          ])),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '',
                          style: tsS15W500CFF,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Vol: ${ticker != null ? ticker?.volumeBase24hr.toStringAsFixed(4) : ''}',
                            style: tsS12W400CFF.copyWith(
                              color: AppColors.colorABB2BC.withOpacity(0.70),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.color0CA564,
                  borderRadius: BorderRadius.circular(7),
                ),
                padding: const EdgeInsets.all(5),
                child: RichText(
                    text: TextSpan(children: <TextSpan>[
                  TextSpan(
                    text: ticker?.priceChangePercent24Hr.toStringAsFixed(4),
                    style: tsS15W500CFF,
                  ),
                  TextSpan(
                    text: '%',
                    style: tsS10W500CFF,
                  ),
                ])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
