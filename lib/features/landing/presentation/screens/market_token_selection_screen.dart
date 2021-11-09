import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/dummy_providers/dummy_lists.dart';
import 'package:polkadex/features/landing/data/models/home_models.dart';
import 'package:polkadex/features/landing/presentation/providers/token_pair_expanded_provider.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

/// The width of the shrink widget for token and pairs
const _shrinkWidgetWidth = 120.0;

/// The response model for the seletion. This model will be passed on
/// navigator pop. So the previous screen get the result of selection
class MarketSelectionResultModel {
  /// The selected token model
  final BasicCoinListModel tokenModel;

  /// The selected pair model
  final BasicCoinListModel? pairModel;

  MarketSelectionResultModel({
    required this.tokenModel,
    required this.pairModel,
  });
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
      create: (_) => _ThisProvider(),
      builder: (context, _) => WillPopScope(
        onWillPop: () => _onBack(context),
        child: Scaffold(
          backgroundColor: color2E303C,
          floatingActionButton: Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: color2E303C,
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
                  color: color1C2023,
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
          _ThisTokenLayoutWidget(
              onExpandWidget: _expandTokenWidget,
              onShrinkWidget: _shrinkTokenWidget,
              tokenAnimation: _tokenAnimation),
          SizedBox(width: 18),
          _ThisPairLayoutWidget(
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
class _ThisPairLayoutWidget extends AnimatedWidget {
  const _ThisPairLayoutWidget({
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
                  onTap: () {
                    thisProvider.selectedPairModel =
                        thisProvider.pairList[index];
                    Navigator.of(context).pop(MarketSelectionResultModel(
                        tokenModel: thisProvider.selectedTokenModel,
                        pairModel: thisProvider.selectedPairModel));
                  },
                  child: _ThisPairItemWidget(
                    model: thisProvider.pairList[index],
                    isSelected: thisProvider.pairList[index] ==
                        thisProvider.selectedPairModel,
                    pairAnimation: _pairAnimation,
                  ),
                ),
                itemCount: thisProvider.pairList.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// The base layout of the token list. This widget shrink/expand its size
/// based on the user intraction
///
class _ThisTokenLayoutWidget extends AnimatedWidget {
  const _ThisTokenLayoutWidget({
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
                  onTap:
                      //  !context
                      //         .watch<TokenPairExpandedProvider>()
                      //         .isTokenExpanded
                      //     ?
                      //      () {
                      //         final isTokenExpanded = context
                      //             .read<TokenPairExpandedProvider>()
                      //             .isTokenExpanded;
                      //         if (isTokenExpanded) {
                      //           onShrinkWidget();
                      //         } else {
                      //           onExpandWidget();
                      //         }
                      //         context
                      //             .read<TokenPairExpandedProvider>()
                      //             .isTokenExpanded = !isTokenExpanded;
                      //       }
                      //     :
                      () {
                    // if (this._tokenAnimation.isCompleted) {

                    thisProvider.selectedTokenModel =
                        thisProvider.tokenList[index];
                    // this.onShrinkWidget();
                    context.read<TokenPairExpandedProvider>().isTokenExpanded =
                        false;
                    // }
                  },
                  child: _ThisTokenItemWidget(
                    tokenAnimation: _tokenAnimation,
                    model: thisProvider.tokenList[index],
                    isSelected: thisProvider.tokenList[index] ==
                        thisProvider.selectedTokenModel,
                  ),
                ),
                itemCount: thisProvider.tokenList.length,
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
class _ThisPairItemWidget extends AnimatedWidget {
  final BasicCoinListModel model;
  final bool isSelected;
  const _ThisPairItemWidget({
    required this.model,
    required Animation<double> pairAnimation,
    required this.isSelected,
  }) : super(listenable: pairAnimation);

  Animation<double> get _pairAnimation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppConfigs.animDurationSmall,
      decoration: BoxDecoration(
        color: isSelected ? colorE6007A : color2E303C.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(10, 15, 16, 16),
      margin: const EdgeInsets.only(bottom: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              Image.asset(
                model.imgAsset,
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
                                model.name,
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
                        model.code,
                        style: tsS12W400CFF.copyWith(
                          color:
                              colorFFFFFF.withOpacity(isSelected ? 1.0 : 0.6),
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
                            model.amount,
                            style: tsS12W600CFF,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 3),
                            decoration: BoxDecoration(
                              color: color0CA564,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 1, horizontal: 4),
                            child: RichText(
                              text: TextSpan(
                                style: tsS12W500CFF,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: model.percentage,
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
class _ThisTokenItemWidget extends AnimatedWidget {
  final BasicCoinListModel model;
  final bool isSelected;

  const _ThisTokenItemWidget({
    required this.isSelected,
    required Animation<double> tokenAnimation,
    required this.model,
  }) : super(listenable: tokenAnimation);

  Animation<double> get tokenAnimation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppConfigs.animDurationSmall,
      decoration: BoxDecoration(
        color: isSelected ? colorE6007A : color2E303C.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.fromLTRB(10, 15, 16, 16),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Image.asset(
            model.imgAsset,
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
                            model.name,
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
                    model.code,
                    style: tsS12W400CFF.copyWith(
                      color: colorFFFFFF.withOpacity(isSelected ? 1.0 : 0.6),
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
        color: color2E303C.withOpacity(0.3),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          // Expanded(child: Container()),
          Expanded(
              child: TextField(
            style: tsS14W400CFF.copyWith(color: colorABB2BC),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText: 'Search name or ticket',
              hintStyle: tsS14W400CFF.copyWith(color: colorABB2BC),
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
  String? _searchText;
  BasicCoinListModel _selectedTokenModel = _dummyTokenList[0];
  BasicCoinListModel? _selectedPairModel;

  BasicCoinListModel get selectedTokenModel => _selectedTokenModel;
  BasicCoinListModel? get selectedPairModel => _selectedPairModel;

  List<BasicCoinListModel> get tokenList {
    if (_searchText?.isNotEmpty ?? false) {
      return _dummyTokenList
          .where((e) =>
              e.name.toLowerCase().contains(_searchText!.toLowerCase()) ||
              e.code.toLowerCase().contains(_searchText!.toLowerCase()))
          .toList();
    }
    return _dummyTokenList;
  }

  List<BasicCoinListModel> get pairList {
    if (_searchText?.isNotEmpty ?? false) {
      return _dummyPairList
          .where((e) =>
              e.name.toLowerCase().contains(_searchText!.toLowerCase()) ||
              e.code.toLowerCase().contains(_searchText!.toLowerCase()))
          .toList();
    }
    return _dummyPairList;
  }

  set selectedTokenModel(BasicCoinListModel value) {
    _selectedTokenModel = value;
    _selectedPairModel = null;
    notifyListeners();
  }

  set selectedPairModel(BasicCoinListModel? value) {
    _selectedPairModel = value;
    notifyListeners();
  }

  set searchText(String val) {
    _searchText = val;
    notifyListeners();
  }
}

/// Remove the dummy data below
// class _TokenModel {
//   final String assetImage;
//   final String name;
//   final String code;

//   const _TokenModel({
//     @required this.assetImage,
//     @required this.name,
//     @required this.code,
//   });
// }

// class _PairModel {
//   final String assetImage;
//   final String name;
//   final String code;
//   final String amount;
//   final String percentage;

//   const _PairModel({
//     @required this.assetImage,
//     @required this.name,
//     @required this.code,
//     @required this.amount,
//     @required this.percentage,
//   });
// }

// const _DUMMY_TOKEN_LIST = <_TokenModel>[
//   _TokenModel(
//     assetImage: 'trade_open/trade_open_1.png',
//     name: 'Polkadex',
//     code: 'DEX',
//   ),
//   _TokenModel(
//     assetImage: 'trade_open/trade_open_2.png',
//     name: 'Ethereum',
//     code: 'ETH',
//   ),
//   _TokenModel(
//     assetImage: 'trade_open/trade_open_3.png',
//     name: 'Cardano',
//     code: 'ADA',
//   ),
//   _TokenModel(
//     assetImage: 'trade_open/trade_open_4.png',
//     name: 'Monero',
//     code: 'XMR',
//   ),
//   _TokenModel(
//     assetImage: 'trade_open/trade_open_5.png',
//     name: 'Dogecoin',
//     code: 'DOGE',
//   ),
//   _TokenModel(
//     assetImage: 'trade_open/trade_open_6.png',
//     name: 'IOST',
//     code: 'IOST',
//   ),
//   _TokenModel(
//     assetImage: 'trade_open/trade_open_7.png',
//     name: 'Ripple',
//     code: 'XRP',
//   ),
//   _TokenModel(
//     assetImage: 'trade_open/trade_open_8.png',
//     name: 'Polkadot',
//     code: 'DOT',
//   ),
//   _TokenModel(
//     assetImage: 'trade_open/trade_open_9.png',
//     name: 'Litecoin',
//     code: 'LTC',
//   ),
//   _TokenModel(
//     assetImage: 'trade_open/trade_open_10.png',
//     name: 'Theter',
//     code: 'USDT',
//   ),
// ];

// const _DUMMY_PAIR_LIST = <_PairModel>[
//   _PairModel(
//     assetImage: 'trade_open/trade_open_11.png',
//     name: 'Bitcoin',
//     code: 'BTC',
//     amount: '0.7261',
//     percentage: '+13.07',
//   ),
//   _PairModel(
//     assetImage: 'trade_open/trade_open_10.png',
//     name: 'Tether',
//     code: 'USDT',
//     amount: '42.50',
//     percentage: '+9.12',
//   ),
//   _PairModel(
//     assetImage: 'trade_open/trade_open_12.png',
//     name: 'Polkadot',
//     code: 'DOT',
//     amount: '0.90',
//     percentage: '+23.09',
//   ),
// ];

final _dummyTokenList = basicCoinDummyList;
final _dummyPairList = List<BasicCoinListModel>.generate(
    3, (index) => basicCoinDummyList[basicCoinDummyList.length - index - 1]);
