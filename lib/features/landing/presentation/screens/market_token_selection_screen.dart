import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/market_asset/domain/entities/asset_entity.dart';
import 'package:polkadex/common/market_asset/presentation/cubit/market_asset_cubit.dart';
import 'package:polkadex/common/orderbook/presentation/cubit/orderbook_cubit.dart';
import 'package:polkadex/features/landing/presentation/providers/token_pair_expanded_provider.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/custom_app_bar.dart';
import 'package:polkadex/features/landing/utils/token_utils.dart';
import 'package:provider/provider.dart';

/// The width of the shrink widget for token and pairs
const _shrinkWidgetWidth = 120.0;

/// The response model for the seletion. This model will be passed on
/// navigator pop. So the previous screen get the result of selection
class MarketSelectionResultModel {
  MarketSelectionResultModel({
    required this.selectedBaseAsset,
    required this.selectedQuoteAsset,
  });

  final AssetEntity selectedBaseAsset;
  final AssetEntity selectedQuoteAsset;
}

/// XD_PAGE: 10
///
/// The Trade Market Token Open
class MarketTokenSelectionScreen extends StatefulWidget {
  @override
  _MarketTokenSelectionScreenState createState() =>
      _MarketTokenSelectionScreenState();
}

class _MarketTokenSelectionScreenState extends State<MarketTokenSelectionScreen>
    with SingleTickerProviderStateMixin {
  /// The animation controller to handle the animations which are animating
  /// on screen entry
  late AnimationController _entryAnimationController;

  @override
  void initState() {
    _entryAnimationController = AnimationController(
      vsync: this,
      duration: AppConfigs.animDuration,
      reverseDuration: AppConfigs.animReverseDuration,
    );
    super.initState();
    Future.microtask(() => _entryAnimationController.forward().orCancel);
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_ThisProvider>(
      create: (_) => _ThisProvider(
          marketList: context.read<MarketAssetCubit>().listAvailableMarkets),
      builder: (context, _) => WillPopScope(
        onWillPop: () => _onBack(context),
        child: Scaffold(
          backgroundColor: AppColors.color2E303C,
          floatingActionButton: Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: AppColors.color2E303C,
              borderRadius: BorderRadius.circular(18),
              boxShadow: <BoxShadow>[bsDefault],
            ),
            padding: const EdgeInsets.all(22),
            child: SvgPicture.asset('arrow-2'.asAssetSvg()),
          ),
          body: SafeArea(
            child: CustomAppBar(
              title: 'Markets',
              // animationController: _entryAnimationController,
              onTapBack: () => _onBack(context),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.color1C2023,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(15, 21, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ThisSearchBarWidget(),
                    SizedBox(height: 12),
                    Expanded(
                      child: _ThisTokenPairWidget(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Dispose the animtation controllers and other controllers
  void _disposeControllers() {
    _entryAnimationController.dispose();
  }

  /// Handle the animation on back
  Future<bool> _onBack(BuildContext context) async {
    await _entryAnimationController.reverse().orCancel;
    Navigator.pop(context);
    return false;
  }
}

/// The widget to display token pair in row. Handles the widget width based on
/// selection
class _ThisTokenPairWidget extends StatefulWidget {
  @override
  __ThisTokenPairWidgetState createState() => __ThisTokenPairWidgetState();
}

class __ThisTokenPairWidgetState extends State<_ThisTokenPairWidget>
    with SingleTickerProviderStateMixin {
  /// The animation controller to handle the screen width
  late AnimationController _animationController;

  /// The animation for token width
  late Animation<double> _tokenAnimation;

  /// The animation for the pair width
  late Animation<double> _pairAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: AppConfigs.animDurationSmall);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initAnimations();
    return ChangeNotifierProvider<TokenPairExpandedProvider>(
      create: (context) => TokenPairExpandedProvider(),
      builder: (context, child) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ThisBaseLayoutWidget(
              onExpandWidget: _expandTokenWidget,
              onShrinkWidget: _shrinkTokenWidget,
              tokenAnimation: _tokenAnimation),
          SizedBox(width: 18),
          _ThisQuoteLayoutWidget(
            pairAnimation: _pairAnimation,
          ),
        ],
      ),
    );
  }

  /// Initialise the animations
  void _initAnimations() {
    _tokenAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);
    _pairAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  /// Reverese the animation to shrink the width
  void _shrinkTokenWidget() {
    _animationController.reverse().orCancel;
  }

  /// Animate to expand the width of selection
  void _expandTokenWidget() {
    _animationController.reset();
    _animationController.forward().orCancel;
  }
}

/// The base layout of the pair list. This widget shrink/expand its size
/// based on the user intraction
///
class _ThisQuoteLayoutWidget extends AnimatedWidget {
  const _ThisQuoteLayoutWidget({
    required Animation<double> pairAnimation,
  }) : super(listenable: pairAnimation);

  Animation<double> get _pairAnimation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: lerpDouble(
        _shrinkWidgetWidth,
        MediaQuery.of(context).size.width - 180.0,
        _pairAnimation.value,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 36,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  'Pair',
                  style: tsS18W600CFF,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: Consumer<_ThisProvider>(
              builder: (context, thisProvider, child) => ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) => InkWell(
                  onTap: () => _onMarketSelected(
                    context,
                    thisProvider,
                    index,
                  ),
                  child: _ThisQuoteItemWidget(
                    asset: thisProvider.quoteList[index],
                    isSelected: thisProvider.quoteList[index].assetId ==
                        thisProvider.selectedQuoteToken?.assetId,
                    pairAnimation: _pairAnimation,
                  ),
                ),
                itemCount: thisProvider.quoteList.length,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onMarketSelected(
    BuildContext context,
    _ThisProvider provider,
    int index,
  ) {
    provider.selectedQuoteToken = provider.quoteList[index];

    context.read<OrderbookCubit>().fetchOrderbookData(
          leftTokenId: provider.selectedBaseToken!.assetId,
          rightTokenId: provider.selectedQuoteToken!.assetId,
        );

    Navigator.of(context).pop(
      MarketSelectionResultModel(
          selectedBaseAsset: provider.selectedBaseToken!,
          selectedQuoteAsset: provider.selectedQuoteToken!),
    );
  }
}

/// The base layout of the token list. This widget shrink/expand its size
/// based on the user intraction
///
class _ThisBaseLayoutWidget extends AnimatedWidget {
  const _ThisBaseLayoutWidget({
    required this.onShrinkWidget,
    required this.onExpandWidget,
    required Animation<double> tokenAnimation,
  }) : super(listenable: tokenAnimation);

  final VoidCallback onShrinkWidget;
  final VoidCallback onExpandWidget;

  Animation<double> get _tokenAnimation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: lerpDouble(
        _shrinkWidgetWidth,
        MediaQuery.of(context).size.width - 180.0,
        _tokenAnimation.value,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 36,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Token',
                    style: tsS18W600CFF,
                  ),
                ),
                Opacity(
                  opacity: 0.5,
                  child: SvgPicture.asset(
                    'star-filled'.asAssetSvg(),
                  ),
                ),
                SizedBox(width: 16),
              ],
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: Consumer<_ThisProvider>(
              builder: (context, thisProvider, child) => ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    thisProvider.selectedBaseToken =
                        thisProvider.baseList[index];
                    // this.onShrinkWidget();
                    context.read<TokenPairExpandedProvider>().isTokenExpanded =
                        false;
                    // }
                  },
                  child: _ThisBaseItemWidget(
                    tokenAnimation: _tokenAnimation,
                    asset: thisProvider.baseList[index],
                    isSelected: thisProvider.baseList[index].assetId ==
                        thisProvider.selectedBaseToken?.assetId,
                  ),
                ),
                itemCount: thisProvider.baseList.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The complete item widget of pair card. This item expand and shrink based
/// on [pairAnimation] value
///
class _ThisQuoteItemWidget extends AnimatedWidget {
  const _ThisQuoteItemWidget({
    required this.asset,
    required Animation<double> pairAnimation,
    required this.isSelected,
  }) : super(listenable: pairAnimation);

  final AssetEntity asset;
  final bool isSelected;

  Animation<double> get _pairAnimation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppConfigs.animDurationSmall,
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.colorE6007A
            : AppColors.color2E303C.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(10, 15, 16, 16),
      margin: const EdgeInsets.only(bottom: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              SvgPicture.asset(
                TokenUtils.tokenIdToAssetSvg(asset.assetId),
                width: 43,
                height: 43,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) => Align(
                        alignment: Alignment.bottomLeft,
                        child: SizedBox(
                          width: constraints.maxWidth * _pairAnimation.value,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Opacity(
                              opacity: Interval(0.00, 0.50)
                                  .transform(_pairAnimation.value),
                              child: Text(
                                asset.name,
                                style: tsS16W500CFF,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0.0, -9 * (1.0 - _pairAnimation.value)),
                      child: Text(
                        asset.symbol,
                        style: tsS12W400CFF.copyWith(
                          color: AppColors.colorFFFFFF
                              .withOpacity(isSelected ? 1.0 : 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: AppConfigs.animDurationSmall,
                layoutBuilder: (currentChild, previousChildren) =>
                    currentChild!,
                child: _pairAnimation.value > 0.9
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 6),
                          Text(
                            'model.amount',
                            style: tsS12W600CFF,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 3),
                            decoration: BoxDecoration(
                              color: AppColors.color0CA564,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 1, horizontal: 4),
                            child: RichText(
                              text: TextSpan(
                                style: tsS12W500CFF,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'model.percentage',
                                    style: tsS12W500CFF,
                                  ),
                                  TextSpan(
                                    text: "%",
                                    style: TextStyle(
                                      fontSize: 8,
                                      fontFamily: 'WorkSans',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              )
            ],
          );
        },
      ),
    );
  }
}

/// The complete item widget of token card. This item expand and shrink based
/// on [tokenAnimation] value
///
class _ThisBaseItemWidget extends AnimatedWidget {
  const _ThisBaseItemWidget({
    required this.isSelected,
    required Animation<double> tokenAnimation,
    required this.asset,
  }) : super(listenable: tokenAnimation);

  final AssetEntity asset;
  final bool isSelected;

  Animation<double> get tokenAnimation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppConfigs.animDurationSmall,
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.colorE6007A
            : AppColors.color2E303C.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.fromLTRB(10, 15, 16, 16),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SvgPicture.asset(
            TokenUtils.tokenIdToAssetSvg(asset.assetId),
            width: 43,
            height: 43,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) => Align(
                    alignment: Alignment.bottomLeft,
                    child: SizedBox(
                      width: constraints.maxWidth * tokenAnimation.value,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Opacity(
                          opacity: Interval(0.50, 1.0)
                              .transform(tokenAnimation.value),
                          child: Text(
                            asset.name,
                            style: tsS16W500CFF,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0.0, -9 * (1.0 - tokenAnimation.value)),
                  child: Text(
                    asset.assetId,
                    style: tsS12W400CFF.copyWith(
                      color: AppColors.colorFFFFFF
                          .withOpacity(isSelected ? 1.0 : 0.6),
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 17 * tokenAnimation.value,
            height: 17,
            child: Opacity(
              opacity: lerpDouble(0.0, 0.6, tokenAnimation.value)!,
              child: Opacity(
                opacity: 0.5,
                child: SvgPicture.asset(
                  'star-filled'.asAssetSvg(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The top search bar with label and search icon
class _ThisSearchBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 21, 19, 22),
      decoration: BoxDecoration(
        color: AppColors.color2E303C.withOpacity(0.3),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          // Expanded(child: Container()),
          Expanded(
              child: TextField(
            style: tsS14W400CFF.copyWith(color: AppColors.colorABB2BC),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText: 'Search name or ticket',
              hintStyle: tsS14W400CFF.copyWith(color: AppColors.colorABB2BC),
              border: InputBorder.none,
              errorBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
            ),
            onChanged: (text) {
              context.read<_ThisProvider>().searchText = text;
            },
          )),
          SvgPicture.asset(
            'search'.asAssetSvg(),
            width: 22,
            height: 22,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

/// The provider for the screen to manage the list and selection
class _ThisProvider extends ChangeNotifier {
  _ThisProvider({required List<List<AssetEntity>> marketList})
      : _marketList = marketList;

  final List<List<AssetEntity>> _marketList;

  String? _searchText;
  AssetEntity? _selectedBaseToken;
  AssetEntity? _selectedQuoteToken;

  AssetEntity? get selectedBaseToken => _selectedBaseToken;
  AssetEntity? get selectedQuoteToken => _selectedQuoteToken;

  List<AssetEntity> get baseList {
    if (_searchText?.isNotEmpty ?? false) {
      final filteredMarkets = _marketList
          .where(
            (market) =>
                market[0]
                    .name
                    .toLowerCase()
                    .contains(_searchText!.toLowerCase()) ||
                market[1].name.toLowerCase().contains(
                      _searchText!.toLowerCase(),
                    ),
          )
          .toList();
      return filteredMarkets.map((market) => market[0]).toSet().toList();
    } else {
      return _marketList.map((market) => market[0]).toSet().toList();
    }
  }

  List<AssetEntity> get quoteList {
    if (_selectedBaseToken == null) {
      return [];
    } else if (_searchText?.isNotEmpty ?? false) {
      final filteredMarkets = _marketList
          .where(
            (market) =>
                market[0]
                    .name
                    .toLowerCase()
                    .contains(_searchText!.toLowerCase()) ||
                market[1].name.toLowerCase().contains(
                      _searchText!.toLowerCase(),
                    ),
          )
          .toList();
      return filteredMarkets.map((market) => market[1]).toList();
    } else {
      return _marketList.map((market) => market[1]).toList();
    }
  }

  set selectedBaseToken(AssetEntity? asset) {
    _selectedBaseToken = asset;
    _selectedQuoteToken = null;
    notifyListeners();
  }

  set selectedQuoteToken(AssetEntity? asset) {
    _selectedQuoteToken = asset;
    notifyListeners();
  }

  set searchText(String val) {
    _searchText = val;
    notifyListeners();
  }
}
