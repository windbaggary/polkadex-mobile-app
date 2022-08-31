import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';
import 'package:polkadex/common/dummy_providers/balance_chart_dummy_provider.dart';
import 'package:polkadex/common/market_asset/presentation/cubit/market_asset_cubit.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/common/widgets/polkadex_progress_error_widget.dart';
import 'package:polkadex/features/landing/presentation/providers/mnemonic_provider.dart';
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
import 'package:polkadex/injection_container.dart';
import 'package:provider/provider.dart';

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
      ValueNotifier<bool>(true);

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
            child: BlocBuilder<AccountCubit, AccountState>(
              builder: (context, state) {
                if (state is AccountLoaded &&
                    state.account.importedTradeAccountEntity != null &&
                    state.account.mainAddress.isNotEmpty) {
                  return _buildWalletHeaderAndAssetList();
                }

                return _buildNoWalletWidget();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoWalletWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 64,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: <BoxShadow>[bsDefault],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              8,
              16,
              16,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'walletBanner'.asAssetSvg(),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      32,
                      0,
                      32,
                      16,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Looks like you don't have a wallet",
                          textAlign: TextAlign.center,
                          style: tsS25W600CFF.copyWith(
                            color: AppColors.color1C2023,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Explore a new way to trade with your own wallet!",
                          textAlign: TextAlign.center,
                          style: tsS16W400CFF.copyWith(
                            color: AppColors.color93949A,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Scan QR Code',
                        innerPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        outerPadding: EdgeInsets.zero,
                        onTap: () => Coordinator.goToQrCodeScanScreen(
                            onQrCodeScan: (mnemonic) =>
                                _qrCodeMnemonicEval(mnemonic)),
                      ),
                    ),
                    SizedBox(
                      width: 18,
                    ),
                    Expanded(
                      child: AppButton(
                        label: 'Import Wallet',
                        innerPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        outerPadding: EdgeInsets.zero,
                        backgroundColor: AppColors.colorFFFFFF,
                        textColor: Colors.black,
                        onTap: () => Coordinator.goToimportWalletMethods(),
                      ),
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

  Widget _buildWalletHeaderAndAssetList() {
    return NestedScrollView(
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
                              valueListenable: hideSmallBalancesNotifier,
                              builder:
                                  (context, areSmallbalancesHidden, child) =>
                                      CheckBoxWidget(
                                checkColor: AppColors.colorFFFFFF,
                                backgroundColor: AppColors.colorE6007A,
                                isChecked: areSmallbalancesHidden,
                                isBackTransparentOnUnchecked: true,
                                onTap: (val) =>
                                    hideSmallBalancesNotifier.value = val,
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
    );
  }

  Widget _buildAssetList() {
    return BlocBuilder<MarketAssetCubit, MarketAssetState>(
      builder: (context, marketAssetState) =>
          BlocBuilder<BalanceCubit, BalanceState>(
        builder: (context, balanceState) {
          if (marketAssetState is MarketAssetLoaded &&
              balanceState is BalanceLoaded) {
            final avlbAssets =
                context.read<MarketAssetCubit>().listAvailableAssets;

            return ValueListenableBuilder<bool>(
              valueListenable: hideSmallBalancesNotifier,
              builder: (context, areSmallBalancesHidden, child) =>
                  ListView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                itemBuilder: (context, index) {
                  String key = avlbAssets.keys.elementAt(index);
                  final asset = avlbAssets[key];

                  final amount = balanceState.free.getBalance(key);

                  return (areSmallBalancesHidden && amount <= 0) ||
                          asset == null
                      ? Container()
                      : InkWell(
                          onTap: () => Coordinator.goToBalanceCoinPreviewScreen(
                            asset: asset,
                            balanceCubit: context.read<BalanceCubit>(),
                          ),
                          child: BalanceItemWidget(
                            tokenAcronym: asset.symbol,
                            tokenFullName: asset.name,
                            assetSvg:
                                TokenUtils.tokenIdToAssetSvg(asset.assetId),
                            amount: balanceState.free.getBalance(key),
                          ),
                        );
                },
                itemCount: avlbAssets.keys.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
              ),
            );
          }

          if (marketAssetState is MarketAssetLoading ||
              balanceState is BalanceLoading) {
            return BalanceItemShimmerWidget();
          }

          return PolkadexErrorRefreshWidget(
            onRefresh: () async {
              if (marketAssetState is MarketAssetError) {
                await context.read<MarketAssetCubit>().getMarkets();
              }

              if (balanceState is BalanceError) {
                await context.read<MarketAssetCubit>().getMarkets();
              }
            },
          );
        },
      ),
    );
  }

  void _qrCodeMnemonicEval(String qrCode) async {
    final provider = dependency<MnemonicProvider>();

    provider.mnemonicWords = qrCode.split(' ');
    final newAccount = await provider.createImportedAccount();

    if (newAccount != null) {
      Coordinator.goToWalletSettingsScreen(
        provider,
        importedAccount: newAccount,
        removePrevivousScreens: true,
      );
    } else {
      Navigator.pop(context);
    }
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
