import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/dummy_providers/balance_chart_dummy_provider.dart';
import 'package:polkadex/common/market_asset/presentation/cubit/market_asset_cubit.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
import 'package:polkadex/features/landing/presentation/widgets/orderbook_app_bar_widget.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/common/widgets/check_box_widget.dart';
import 'package:polkadex/features/landing/presentation/widgets/balance_item_shimmer_widget.dart';
import 'package:polkadex/features/landing/presentation/widgets/balance_item_widget.dart';
import 'package:polkadex/features/landing/presentation/widgets/top_balance_widget.dart';
import 'package:polkadex/features/landing/utils/token_utils.dart';
import 'package:provider/provider.dart';

/// XD_PAGE: 18
/// XD_PAGE: 19
class BalanceTabView extends StatefulWidget {
  BalanceTabView({required this.scrollController});

  final ScrollController scrollController;

  @override
  _BalanceTabViewState createState() => _BalanceTabViewState();
}

class _BalanceTabViewState extends State<BalanceTabView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final ValueNotifier<bool> hideSmallBalancesNotifier =
      ValueNotifier<bool>(false);

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<_ThisIsChartVisibleProvider>(
            create: (_) => _ThisIsChartVisibleProvider()),
        ChangeNotifierProvider<BalanceChartDummyProvider>(
          create: (_) => BalanceChartDummyProvider(),
        ),
      ],
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OrderbookAppBarWidget(),
          Expanded(
            child: NestedScrollView(
              controller: widget.scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return <Widget>[
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: TopBalanceWidget(),
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
                                    ValueListenableBuilder<bool>(
                                      valueListenable:
                                          hideSmallBalancesNotifier,
                                      builder: (context, areSmallbalancesHidden,
                                              child) =>
                                          CheckBoxWidget(
                                        checkColor: AppColors.colorFFFFFF,
                                        backgroundColor: AppColors.colorE6007A,
                                        isChecked: areSmallbalancesHidden,
                                        isBackTransparentOnUnchecked: true,
                                        onTap: (val) =>
                                            hideSmallBalancesNotifier.value =
                                                val,
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
                      child: _buildAssetList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetList() {
    return BlocBuilder<BalanceCubit, BalanceState>(
      builder: (context, state) {
        if (state is BalanceLoaded) {
          return ValueListenableBuilder<bool>(
            valueListenable: hideSmallBalancesNotifier,
            builder: (context, areSmallBalancesHidden, child) =>
                ListView.builder(
              padding: const EdgeInsets.only(bottom: 24),
              itemBuilder: (context, index) {
                String key = state.free.keys.elementAt(index);
                final asset =
                    context.read<MarketAssetCubit>().getAssetDetailsById(key);
                final amount =
                    double.tryParse(state.free.getBalance(key)) ?? 0.0;

                return areSmallBalancesHidden && amount <= 0
                    ? Container()
                    : InkWell(
                        onTap: () => Coordinator.goToBalanceCoinPreviewScreen(
                          asset: asset,
                          balanceCubit: context.read<BalanceCubit>(),
                        ),
                        child: BalanceItemWidget(
                          tokenAcronym: asset.symbol,
                          tokenFullName: asset.name,
                          assetImg: TokenUtils.tokenIdToAssetImg(asset.assetId),
                          amount: state.free.getBalance(key),
                        ),
                      );
              },
              itemCount: state.free.keys.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
            ),
          );
        }

        if (state is BalanceLoading) {
          return BalanceItemShimmerWidget();
        }

        return Container();
      },
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
