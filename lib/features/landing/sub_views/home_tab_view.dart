import 'package:flutter/material.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/features/balance/screens/balance_coin_preview_screen.dart';
import 'package:polkadex/features/landing/models/home_models.dart';
import 'package:polkadex/features/landing/providers/home_scroll_notif_provider.dart';
import 'package:polkadex/features/landing/providers/rank_list_provider.dart';
import 'package:polkadex/features/landing/widgets/app_slider_widget.dart';
import 'package:polkadex/features/trade/screens/coin_trade_screen.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/build_methods.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

/// XD_PAGE: 34
class HomeTabView extends StatefulWidget {
  @override
  _HomeTabViewState createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView>
    with SingleTickerProviderStateMixin {
  // AnimationController _entryAnimationController;

  // Animation<double> _sliderAnimation;
  // Animation<Offset> _topPairsHeadingAnimation;
  // Animation<Offset> _rankingListHeadingAnimation;
  // Animation<Offset> _rankingListFilterAnimation;
  // Animation<double> _rankingListOpacityAnimation;
  // Animation<double> _topPairsOpacityAnimation;
  // Animation<double> _rankingListFilterOpacityAnimation;

  late ScrollController _scrollController;

  @override
  void initState() {
    // _entryAnimationController = AnimationController(
    //     vsync: this,
    //     duration: AppConfigs.animDuration,
    //     reverseDuration: AppConfigs.animReverseDuration);

    // this._sliderAnimation = CurvedAnimation(
    //   parent: _entryAnimationController,
    //   curve: Interval(
    //     0.0,
    //     0.50,
    //     curve: Curves.decelerate,
    //   ),
    // );
    // this._topPairsHeadingAnimation = Tween<Offset>(
    //   begin: Offset(-1.0, 0.0),
    //   end: Offset(0.0, 0.0),
    // ).animate(
    //   CurvedAnimation(
    //     parent: _entryAnimationController,
    //     curve: Interval(
    //       0.25,
    //       0.850,
    //       curve: Curves.decelerate,
    //     ),
    //   ),
    // );
    // this._topPairsOpacityAnimation = CurvedAnimation(
    //   parent: _entryAnimationController,
    //   curve: Interval(
    //     0.25,
    //     0.650,
    //     curve: Curves.decelerate,
    //   ),
    // );
    // this._rankingListHeadingAnimation = Tween<Offset>(
    //   begin: Offset(-1.0, 0.0),
    //   end: Offset(0.0, 0.0),
    // ).animate(
    //   CurvedAnimation(
    //     parent: _entryAnimationController,
    //     curve: Interval(
    //       0.40,
    //       0.950,
    //       curve: Curves.decelerate,
    //     ),
    //   ),
    // );
    // this._rankingListOpacityAnimation = CurvedAnimation(
    //   parent: _entryAnimationController,
    //   curve: Interval(
    //     0.40,
    //     0.850,
    //     curve: Curves.decelerate,
    //   ),
    // );
    // this._rankingListFilterAnimation = Tween<Offset>(
    //   begin: Offset(-1.0, 0.0),
    //   end: Offset(0.0, 0.0),
    // ).animate(
    //   CurvedAnimation(
    //     parent: _entryAnimationController,
    //     curve: Interval(
    //       0.65,
    //       1.0,
    //       curve: Curves.decelerate,
    //     ),
    //   ),
    // );
    // this._rankingListFilterOpacityAnimation = CurvedAnimation(
    //   parent: _entryAnimationController,
    //   curve: Interval(
    //     0.65,
    //     0.750,
    //     curve: Curves.decelerate,
    //   ),
    // );
    _scrollController = ScrollController()..addListener(_scrollListener);
    super.initState();
    // Future.microtask(() => _entryAnimationController.forward().orCancel);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeRankListProvider>(
          create: (context) => HomeRankListProvider(),
        ),
      ],
      child: SingleChildScrollView(
        controller: _scrollController,
        clipBehavior: Clip.none,
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16,
                top: 2,
              ),
              // child: FadeTransition(
              //   opacity: _sliderAnimation,
              //   child: ScaleTransition(
              //     scale: _sliderAnimation,
              // child: _ThisTopSlider(),
              child: AppSliderWidget(
                height: 200,
                childrens: List.generate(
                  10,
                  (index) => InkWell(
                      onTap: () async {
                        try {
                          final link = "https://www.polkadex.trade";
                          if (await url_launcher.canLaunch(link)) {
                            url_launcher.launch(link);
                          }
                        } catch (ex) {
                          print(ex);
                        }
                      },
                      child: _ThisSliderItemWidget()),
                ),
                opacities: [0.1, 0.50, 1.0],
                offsetsY: [0.0, 5.0, 10.0],
                scales: [0.85, 0.95, 1.0],
              ),
            ),

            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(
                left: 21,
                right: 21,
                top: 10,
                bottom: 12,
              ),
              // child: FadeTransition(
              //   opacity: _topPairsOpacityAnimation,
              //   child: SlideTransition(
              //     position: _topPairsHeadingAnimation,
              child: Text(
                'Tops Pairs',
                style: tsS20W600CFF,
              ),
              //   ),
              // ),
            ),
            SizedBox(
              height: 108,
              child: ListView.builder(
                itemBuilder: (context, index) => _ThisTopPairAnimatedWidget(
                  child: _ThisTopPairsItemWidget(),
                  index: index,
                  // animationController: this._entryAnimationController,
                ),
                itemCount: 20,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 21),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 21,
                right: 21,
                top: 45,
                bottom: 9,
              ),
              // child: FadeTransition(
              //   opacity: _rankingListOpacityAnimation,
              //   child: SlideTransition(
              //     position: _rankingListHeadingAnimation,
              child: Text(
                'Ranking List',
                style: tsS20W600CFF,
              ),
            ),
            //   ),
            // ),
            // FadeTransition(
            //   opacity: _rankingListFilterOpacityAnimation,
            //   child: SlideTransition(
            //       position: _rankingListFilterAnimation,
            // child:
            _ThisRankingListFilterWidget(), //  ),
            // ),
            Consumer<HomeRankListProvider>(
              builder: (context, rankProvider, child) => ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 64),
                itemBuilder: (context, index) => _ThisRankingListItemWidget(
                  model: rankProvider.list[index],
                ),
                itemCount: rankProvider.list.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollListener() {
    final provider = context.read<HomeScrollNotifProvider>();
    provider.scrollOffset = _scrollController.offset;
  }
}

/// The top filter widget shown above the ranking list.
/// This widget filter the ranking list
class _ThisRankingListFilterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 20.0 + 9.0, bottom: 8),
      child: Row(
        children: [
          DropdownButton<String>(
            items: ['All Markets', 'BTC Market', 'LTC Market']
                .map((e) => DropdownMenuItem<String>(
                      child: Text(
                        e,
                        style: tsS15W600CABB2BC,
                      ),
                      value: e,
                    ))
                .toList(),
            value: 'All Markets',
            style: tsS15W600CABB2BC,
            underline: Container(),
            onChanged: null,
            icon: Container(),
            // Padding(
            //   padding: const EdgeInsets.only(left: 4.0),
            //   child: Icon(
            //     Icons.keyboard_arrow_down_rounded,
            //     color: colorFFFFFF,
            //     size: 16,
            //   ),
            // ),
          ),
          Spacer(),
          _ThisRankingListSortWidget(),
        ],
      ),
    );
  }
}

/// The right side sorting filter. This filer sort the ranking
/// list based on the selection
class _ThisRankingListSortWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <EnumRankingListSorts>[
        EnumRankingListSorts.vol,
        EnumRankingListSorts.losers,
        EnumRankingListSorts.gainers,
      ]
          .map(
            (item) => Consumer<HomeRankListProvider>(
              builder: (context, rankListProvider, child) => InkWell(
                onTap: () => _onTap(context, item),
                child: _ThisRankingListSortItemWidget(
                  item: item,
                  isSelected: item == rankListProvider.listType,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  void _onTap(BuildContext context, EnumRankingListSorts item) {
    context.read<HomeRankListProvider>().listType = item;
  }
}

/// The item widget for the sort filter. The view is based on the
/// selection
class _ThisRankingListSortItemWidget extends StatelessWidget {
  final EnumRankingListSorts item;
  final bool isSelected;
  const _ThisRankingListSortItemWidget({
    required this.item,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    String? label;
    Color containerColor = Colors.transparent;
    Color textColor = colorABB2BC.withOpacity(0.30);

    switch (item) {
      case EnumRankingListSorts.gainers:
        label = 'Gainers';
        if (isSelected) {
          containerColor = color0CA564;
        }
        break;
      case EnumRankingListSorts.losers:
        label = 'Losers';
        if (isSelected) {
          containerColor = colorE6007A;
        }
        break;
      case EnumRankingListSorts.vol:
        label = 'Vol';
        if (isSelected) {
          containerColor = colorE6007A;
        }
        break;
    }

    if (isSelected) {
      textColor = colorFFFFFF;
    }

    return AnimatedContainer(
        duration: AppConfigs.animDurationSmall,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.fromLTRB(13, 5, 11, 7),
        child: AnimatedDefaultTextStyle(
          child: Text(label),
          style: tsS15W600CFF.copyWith(color: textColor),
          duration: AppConfigs.animDurationSmall,
        ));
  }
}

/// The widget for the top slider
class _ThisSliderItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color2E303C, borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: 0.0,
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Image.asset(
                    'testImage.png'.asAssetImg(),
                    fit: BoxFit.fill,
                    alignment: Alignment.center,
                  ),
                ),
                Positioned(
                  top: 18,
                  right: 22,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorE6007A,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.fromLTRB(6, 1, 5, 3),
                    child: Text(
                      "EVENT",
                      style: tsS13W600CFF,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 16, 25, 16),
            child: Text(
              'Participate in lucky draw and share 160 USDT prize poll!',
              style: tsS16W500CFF,
            ),
          )
        ],
      ),
    );
  }
}

/// The animated widget that animates the [child]
/// for the Top Pairs
///
/// [child] should not be null
/// [index] shpuld be passed to calculate the initial delay for [child]
class _ThisTopPairAnimatedWidget extends StatefulWidget {
  final _ThisTopPairsItemWidget child;
  final int index;
  // final Animation<double> animationController;
  // final Duration initialDelay;
  const _ThisTopPairAnimatedWidget({
    required this.child,
    required this.index,
    // this.animationController,
    // this.initialDelay,
  });

  @override
  __ThisTopPairAnimatedWidgetState createState() =>
      __ThisTopPairAnimatedWidgetState();
}

class __ThisTopPairAnimatedWidgetState extends State<_ThisTopPairAnimatedWidget>
    with SingleTickerProviderStateMixin {
  // AnimationController _animationController;
  // Animation<double> _entryAnimation;

  @override
  void initState() {
    // _animationController = widget.animationController ??
    //     AnimationController(
    //       vsync: this,
    //       duration: AppConfigs.animDurationSmall,
    //       reverseDuration: AppConfigs.animDurationSmall,
    //     );
    // _initEntryAnimation();
    // Timer(
    //     Duration(
    //         milliseconds: widget.index *
    //             AppConfigs.animDurationSmall.inMilliseconds), () {
    //   if (_animationController != null) {
    //     _animationController.forward();
    //   }
    // });
    super.initState();
  }

  @override
  void dispose() {
    // if (widget.animationController == null) {
    //   _disposeAnimationController();
    // }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _ThisTopPairAnimatedWidget oldWidget) {
    // if (oldWidget.animationController != widget.animationController) {
    //   this._animationController = widget.animationController;
    //   _initEntryAnimation();
    // }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // return AnimatedBuilder(
    //   animation: _entryAnimation,
    //   child: widget.child,
    //   builder: (context, child) => Opacity(
    //     opacity: _entryAnimation.value,
    //     child:
    //     Align(
    //       widthFactor: 1.0 + (0.5 * (1 - _animationController.value)),
    //       child: child,
    //     ),
    //   ),
    // );
    return widget.child;
  }

  // void _disposeAnimationController() {
  //   _animationController.dispose();
  //   _animationController = null;
  // }

  // void _initEntryAnimation() {
  //   _entryAnimation = CurvedAnimation(
  //     parent: _animationController,
  //     curve: Interval(
  //       0.45,
  //       0.60,
  //       curve: Curves.decelerate,
  //     ),
  //   );
  // }
}

/// The content widget for the Top Pairs
class _ThisTopPairsItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return buildInkWell(
      onTap: () async {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BalanceCoinPreviewScreen()));
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: color2E303C.withOpacity(0.30),
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.fromLTRB(16, 16, 14, 16.0),
        child: IntrinsicWidth(
          child: Column(
            children: [
              Row(
                children: [
                  RichText(
                      text: TextSpan(style: tsS14W400CFF, children: <TextSpan>[
                    TextSpan(text: 'DEX/'),
                    TextSpan(
                      text: 'USDT',
                      style: tsS16W700CFF,
                    ),
                  ])),
                  SizedBox(
                    width: 36,
                  ),
                  Spacer(),
                  // SvgPicture.asset(
                  //   'gain_graph'.asAssetSvg(),
                  //   width: 12,
                  //   height: 9,
                  //   ),
                  Text(
                    '12.47%',
                    style: tsS17W600C0CA564,
                  ),
                ],
              ),
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
                        '\$42.50',
                        style: tsS16W600CFF,
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vol',
                        style: tsS14W400CFFOP50,
                      ),
                      SizedBox(height: 4),
                      Text(
                        '\$824.1mi',
                        style: tsS16W600CFF,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The item widget for the ranking list
class _ThisRankingListItemWidget extends StatelessWidget {
  final BasicCoinListModel model;
  const _ThisRankingListItemWidget({
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: buildInkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CoinTradeScreen()));
        },
        child: Container(
          decoration: BoxDecoration(
            color: color2E303C.withOpacity(0.30),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.fromLTRB(11, 17, 17, 16),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Image.asset(
                  model.imgAsset,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: <Widget>[
                    Text(
                      '${model.code} ',
                      style: tsS15W500CFF,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 1.0),
                      child: Text(
                        '/${model.pair}',
                        style: tsS11W400CABB2BC,
                      ),
                    ),
                  ]),
                  Text(
                    'VOL ${model.volume} BTC',
                    style: tsS12W400CFF.copyWith(
                      color: colorABB2BC.withOpacity(0.70),
                    ),
                  )
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    model.amount,
                    style: tsS15W500CFF,
                  ),
                  Text(
                    '1 BTC',
                    style: tsS12W400CFF.copyWith(
                      color: colorABB2BC.withOpacity(0.70),
                    ),
                  ),
                ],
              ),
              Spacer(
                flex: 2,
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
