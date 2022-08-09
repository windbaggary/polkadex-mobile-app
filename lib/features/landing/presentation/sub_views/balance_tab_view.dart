import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/dummy_providers/balance_chart_dummy_provider.dart';
import 'package:polkadex/common/market_asset/presentation/cubit/market_asset_cubit.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/common/widgets/check_box_widget.dart';
import 'package:polkadex/features/landing/presentation/providers/home_scroll_notif_provider.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/features/landing/presentation/widgets/balance_item_shimmer_widget.dart';
import 'package:polkadex/features/landing/presentation/widgets/balance_item_widget.dart';
import 'package:polkadex/features/landing/presentation/widgets/top_balance_widget.dart';
import 'package:polkadex/features/landing/utils/token_utils.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
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
  late AnimationController _controller;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_onScrollListener);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollListener);
    _scrollController.dispose();
    _controller.dispose();
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
      builder: (context, _) => BlocBuilder<BalanceCubit, BalanceState>(
        builder: (context, state) {
          return NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 24),
                      TopBalanceWidget(),
                    ],
                  ),
                ),
              ];
            },
            body: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: AppColors.color2E303C,
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
                      height: 50,
                      child: Container(
                        color: AppColors.color2E303C,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
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
                                      checkColor: AppColors.colorFFFFFF,
                                      backgroundColor: AppColors.colorE6007A,
                                      isChecked:
                                          thisProvider.isHideSmallBalance,
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: BlocBuilder<BalanceCubit, BalanceState>(
                      builder: (context, state) {
                        if (state is BalanceLoaded) {
                          return ListView.builder(
                            padding: const EdgeInsets.only(bottom: 24),
                            itemBuilder: (context, index) {
                              String key = state.free.keys.elementAt(index);
                              final asset = context
                                  .read<MarketAssetCubit>()
                                  .getAssetDetailsById(key);

                              return InkWell(
                                onTap: () =>
                                    Coordinator.goToBalanceCoinPreviewScreen(
                                  asset: asset,
                                  balanceCubit: context.read<BalanceCubit>(),
                                ),
                                child: BalanceItemWidget(
                                  tokenAcronym: asset.symbol,
                                  tokenFullName: asset.name,
                                  assetImg: TokenUtils.tokenIdToAssetImg(
                                      asset.assetId),
                                  amount: state.free.getBalance(key),
                                ),
                              );
                            },
                            itemCount: state.free.keys.length,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                          );
                        }

                        if (state is BalanceLoading) {
                          return BalanceItemShimmerWidget();
                        }

                        return Container();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onScrollListener() {
    context.read<HomeScrollNotifProvider>().scrollOffset =
        _scrollController.offset;
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
