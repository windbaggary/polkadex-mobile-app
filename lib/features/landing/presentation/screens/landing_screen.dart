import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';
import 'package:polkadex/common/orderbook/presentation/cubit/orderbook_cubit.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
import 'package:polkadex/features/landing/presentation/providers/home_scroll_notif_provider.dart';
import 'package:polkadex/features/landing/presentation/providers/notification_drawer_provider.dart';
import 'package:polkadex/features/landing/presentation/cubits/recent_trades_cubit/recent_trades_cubit.dart';
import 'package:polkadex/features/coin/presentation/cubits/trade_history_cubit/trade_history_cubit.dart';
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

  final ValueNotifier<int> _pageViewNotifier = ValueNotifier<int>(0);
  late ValueNotifier<String> _titleNotifier;

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

    super.initState();
  }

  @override
  void dispose() {
    _titleNotifier.dispose();
    _drawerAnimationController.dispose();
    _drawerNotifAnimController.dispose();
    _contentAnimController.dispose();
    _pageController.dispose();

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
          BlocProvider<TradeHistoryCubit>(
            create: (_) => dependency<TradeHistoryCubit>(),
          ),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<NotificationDrawerProvider>(
                create: (context) => NotificationDrawerProvider()),
            ChangeNotifierProvider<HomeScrollNotifProvider>(
                create: (_) => HomeScrollNotifProvider()),
          ],
          builder: (context, child) => Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColors.color1C2023,
            bottomNavigationBar: ValueListenableBuilder<int>(
              valueListenable: _pageViewNotifier,
              builder: (context, index, child) => BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.call),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.camera),
                    label: 'Markets',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat),
                    label: 'Trade',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat),
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
            drawer: Drawer(
              backgroundColor: Colors.transparent,
              child: AppOptionsWidget(),
            ),
            endDrawer: Drawer(
              backgroundColor: Colors.transparent,
              child: NotificationsWidget(),
            ),
            body: SafeArea(
              child: PageView(
                controller: _pageController,
                children: [
                  HomeTabView(),
                  ExchangeTabView(),
                  TradeTabView(),
                  BalanceTabView(),
                ],
                physics: NeverScrollableScrollPhysics(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    _pageViewNotifier.value = index;
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 500), curve: Curves.easeOut);
  }
}
