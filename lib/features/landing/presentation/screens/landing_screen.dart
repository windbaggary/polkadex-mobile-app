import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/widgets/loading_overlay.dart';
import 'package:polkadex/common/widgets/polkadex_snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';
import 'package:polkadex/common/orderbook/presentation/cubit/orderbook_cubit.dart';
import 'package:polkadex/features/landing/presentation/widgets/scroll_to_hide_widget.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
import 'package:polkadex/features/landing/presentation/providers/home_scroll_notif_provider.dart';
import 'package:polkadex/features/landing/presentation/providers/notification_drawer_provider.dart';
import 'package:polkadex/features/landing/presentation/cubits/recent_trades_cubit/recent_trades_cubit.dart';
import 'package:polkadex/features/landing/presentation/widgets/notifications_widget.dart';
import 'package:polkadex/features/landing/presentation/sub_views/balance_tab_view.dart';
import 'package:polkadex/features/landing/presentation/sub_views/exchange_tab_view.dart';
import 'package:polkadex/features/landing/presentation/widgets/app_options_widget.dart';
import 'package:polkadex/features/landing/presentation/sub_views/home_tab_view.dart';
import 'package:polkadex/features/landing/presentation/sub_views/trade_tab_view.dart';
import 'package:polkadex/common/market_asset/presentation/cubit/market_asset_cubit.dart';
import 'package:polkadex/injection_container.dart';

/// XD_PAGE: 34
class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;

  late AnimationController _drawerAnimationController;
  late AnimationController _drawerNotifAnimController;
  late AnimationController _contentAnimController;

  late ValueNotifier<String> _titleNotifier;

  late ScrollController _scrollController;

  final ValueNotifier<int> _pageViewNotifier = ValueNotifier<int>(0);

  final LoadingOverlay _loadingOverlay = LoadingOverlay();

  @override
  void initState() {
    _titleNotifier = ValueNotifier<String>("Hello Kas");
    _drawerAnimationController = AnimationController(
      vsync: this,
      duration: AppConfigs.animDurationSmall,
      reverseDuration: AppConfigs.animDurationSmall,
    );

    _drawerNotifAnimController = AnimationController(
      vsync: this,
      duration: AppConfigs.animDurationSmall,
      reverseDuration: AppConfigs.animDurationSmall,
    );

    _contentAnimController = AnimationController(
      vsync: this,
      duration: AppConfigs.animDurationSmall,
      reverseDuration: AppConfigs.animDurationSmall,
    );

    _pageController = PageController();

    _scrollController = ScrollController();

    WidgetsBinding.instance?.addPostFrameCallback(
      (_) {
        if (context.read<MarketAssetCubit>().state is! MarketAssetLoaded) {
          _loadingOverlay.show(
              context: context, text: 'Loading blockchain data...');
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _titleNotifier.dispose();
    _drawerAnimationController.dispose();
    _drawerNotifAnimController.dispose();
    _contentAnimController.dispose();
    _pageController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context
        .read<RecentTradesCubit>()
        .getRecentTrades(context.read<AccountCubit>().mainAccountAddress);

    return WillPopScope(
      onWillPop: () async => false,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<BalanceCubit>(
            create: (_) => dependency<BalanceCubit>()
              ..getBalance(context.read<AccountCubit>().mainAccountAddress),
          ),
          BlocProvider<OrderbookCubit>(
            create: (_) => dependency<OrderbookCubit>()
              ..fetchOrderbookData(
                leftTokenId: context
                    .read<MarketAssetCubit>()
                    .currentBaseAssetDetails
                    .assetId,
                rightTokenId: context
                    .read<MarketAssetCubit>()
                    .currentQuoteAssetDetails
                    .assetId,
              ),
          ),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<NotificationDrawerProvider>(
                create: (context) => NotificationDrawerProvider()),
            ChangeNotifierProvider<HomeScrollNotifProvider>(
                create: (_) => HomeScrollNotifProvider()),
            ChangeNotifierProvider<PageController>(
              create: (_) => _pageController,
            ),
          ],
          builder: (context, child) => Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColors.color1C2023,
            bottomNavigationBar: ValueListenableBuilder<int>(
              valueListenable: _pageViewNotifier,
              builder: (context, index, child) => ScrollToHideWidget(
                controller: _scrollController,
                child: BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    _buildCustomBottomNavigationItem(
                      svgName: 'home',
                      label: 'Home',
                    ),
                    _buildCustomBottomNavigationItem(
                      svgName: 'markets',
                      label: 'Markets',
                    ),
                    _buildCustomBottomNavigationItem(
                      svgName: 'trade',
                      label: 'Trade',
                    ),
                    _buildCustomBottomNavigationItem(
                      svgName: 'wallet',
                      label: 'Wallets',
                    ),
                  ],
                  type: BottomNavigationBarType.fixed,
                  selectedIconTheme: IconThemeData(
                    color: AppColors.colorE6007A,
                  ),
                  currentIndex: index,
                  onTap: (newIndex) => _onItemTapped(newIndex),
                ),
              ),
            ),
            drawer: Drawer(
              backgroundColor: Colors.transparent,
              child: AppOptionsWidget(),
            ),
            endDrawer: Drawer(
              backgroundColor: Colors.transparent,
              child: NotificationsWidget(),
            ),
            body: BlocConsumer<MarketAssetCubit, MarketAssetState>(
              listener: (_, marketAssetState) {
                if (marketAssetState is MarketAssetLoaded &&
                    _loadingOverlay.isActive) {
                  _loadingOverlay.hide();
                }
              },
              builder: (context, marketAssetState) {
                return BlocListener<AccountCubit, AccountState>(
                  listener: (_, accountState) {
                    if (accountState is AccountLoggedInWalletAdded) {
                      context.read<BalanceCubit>().getBalance(
                            accountState.account.mainAddress,
                          );
                    }

                    if (accountState is AccountNotLoaded) {
                      Coordinator.goToIntroScreen();
                    }

                    if (accountState is AccountLoggedInSignOutError) {
                      PolkadexSnackBar.show(
                        context: context,
                        text: accountState.errorMessage,
                      );
                    }

                    accountState is AccountLoading
                        ? _loadingOverlay.show(
                            context: context, text: 'Signing out...')
                        : _loadingOverlay.hide();
                  },
                  child: SafeArea(
                    child: PageView(
                      controller: _pageController,
                      children: [
                        HomeTabView(
                          scrollController: _scrollController,
                        ),
                        ExchangeTabView(
                          scrollController: _scrollController,
                        ),
                        TradeTabView(
                          scrollController: _scrollController,
                        ),
                        BalanceTabView(
                          scrollController: _scrollController,
                        ),
                      ],
                      physics: NeverScrollableScrollPhysics(),
                      onPageChanged: (index) => _onPageChangedTapped(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildCustomBottomNavigationItem({
    required String svgName,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        svgName.asAssetSvg(),
      ),
      activeIcon: SvgPicture.asset(
        svgName.asAssetSvg(),
        color: AppColors.colorE6007A,
      ),
      label: label,
    );
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 500), curve: Curves.easeOut);
  }

  void _onPageChangedTapped(int index) {
    _pageViewNotifier.value = index;
  }
}
