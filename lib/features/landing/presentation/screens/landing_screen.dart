import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';
import 'package:polkadex/common/orderbook/presentation/cubit/orderbook_cubit.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
import 'package:polkadex/features/landing/presentation/providers/home_scroll_notif_provider.dart';
import 'package:polkadex/features/landing/presentation/providers/notification_drawer_provider.dart';
import 'package:polkadex/features/landing/presentation/cubits/recent_trades_cubit/recent_trades_cubit.dart';
import 'package:polkadex/features/coin/presentation/cubits/trade_history_cubit/trade_history_cubit.dart';
import 'package:polkadex/features/landing/presentation/sub_views/balance_tab_view.dart';
import 'package:polkadex/features/landing/presentation/sub_views/exchange_tab_view.dart';
import 'package:polkadex/features/landing/presentation/sub_views/home_tab_view.dart';
import 'package:polkadex/features/landing/presentation/sub_views/trade_tab_view.dart';
import 'package:polkadex/common/market_asset/presentation/cubit/market_asset_cubit.dart';
import 'package:polkadex/features/landing/presentation/widgets/app_drawer_widget.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/injection_container.dart';
import 'package:provider/provider.dart';

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

  late Animation<double> _leftDrawerWidthAnimation;
  late Animation<double> _rightDrawerWidthAnimation;
  late Animation<Color?> _drawerContentColorAnimation;
  late Animation<BorderRadius?> _drawerContentRadiusAnimation;

  bool _isDrawerVisible = false;
  bool _isNotifDrawerVisible = false;
  double _dragStartDX = 0.0;

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

    _initAnimations();

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
            body: SafeArea(
              child: GestureDetector(
                onHorizontalDragCancel: _onHorizontalDragCancel,
                onHorizontalDragEnd: _onHorizontalDragEnd,
                onHorizontalDragStart: _onHorizontalDragStart,
                onHorizontalDragUpdate: (details) =>
                    _onHorizontalDragUpdate(details),
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      bottom: 0,
                      child: AnimatedBuilder(
                        animation: _leftDrawerWidthAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset:
                                Offset(_leftDrawerWidthAnimation.value, 0.0),
                            child: child,
                          );
                        },
                        child: NotificationDrawerWidget(
                          onClearTap: () {
                            context
                                .read<NotificationDrawerProvider>()
                                .seenAll();
                          },
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                        animation: _rightDrawerWidthAnimation,
                        builder: (context, child) => Transform.translate(
                              offset:
                                  Offset(_rightDrawerWidthAnimation.value, 0.0),
                              child: child,
                            ),
                        child: AppDrawerWidget()),
                    AnimatedBuilder(
                      animation: _rightDrawerWidthAnimation,
                      builder: (context, child) => Transform.translate(
                          offset: Offset(_rightDrawerWidthAnimation.value, 0.0),
                          child: child),
                      child: AnimatedBuilder(
                        animation: _contentAnimController,
                        builder: (context, child) {
                          return Container(
                            transform: Matrix4.translationValues(
                                _leftDrawerWidthAnimation.value, 0.0, 0.0),
                            decoration: BoxDecoration(
                              color: AppColors.color1C2023,
                              borderRadius: _drawerContentRadiusAnimation.value,
                            ),
                            foregroundDecoration: BoxDecoration(
                              color: _drawerContentColorAnimation.value,
                              borderRadius: _drawerContentRadiusAnimation.value,
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: InkWell(
                              onTap: (_isDrawerVisible || _isNotifDrawerVisible)
                                  ? () {
                                      if (_isDrawerVisible) _onHideDrawer();
                                      if (_isNotifDrawerVisible) {
                                        _onHideRightDrawer();
                                      }
                                    }
                                  : null,
                              child: IgnorePointer(
                                ignoring:
                                    _isDrawerVisible || _isNotifDrawerVisible,
                                child: child,
                              ),
                            ),
                          );
                        },
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
                  ],
                ),
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

  /// Initialise the animations
  void _initAnimations() {
    final curvedAnimation = CurvedAnimation(
      parent: _drawerAnimationController,
      curve: Curves.decelerate,
    );
    _leftDrawerWidthAnimation = Tween<double>(
      begin: 0.0,
      end: appDrawerWidth,
    ).animate(curvedAnimation);

    _rightDrawerWidthAnimation = Tween<double>(
      begin: 0.0,
      end: -getAppDrawerNotifWidth(),
    ).animate(CurvedAnimation(
      parent: _drawerNotifAnimController,
      curve: Curves.decelerate,
    ));

    _drawerContentColorAnimation = ColorTween(
            begin: Colors.transparent,
            end: AppColors.color1C2023.withOpacity(0.50))
        .animate(CurvedAnimation(
      parent: _contentAnimController,
      curve: Curves.decelerate,
    ));

    _drawerContentRadiusAnimation = BorderRadiusTween(
            begin: BorderRadius.circular(0), end: BorderRadius.circular(30))
        .animate(CurvedAnimation(
      parent: _contentAnimController,
      curve: Curves.decelerate,
    ));
  }

  /// Hide the drawer menu
  ///
  void _onHideDrawer() {
    _drawerAnimationController.reverse().orCancel;
    _contentAnimController.reverse().orCancel;
    _isDrawerVisible = false;
  }

  /// Method to hide the right drawer or notification drawer
  void _onHideRightDrawer() {
    _drawerNotifAnimController.reverse().orCancel;
    _contentAnimController.reverse().orCancel;
    _isNotifDrawerVisible = false;
  }

  /// handles the horizontal drag to show or hide drawer menus
  void _onHorizontalDragStart(DragStartDetails details) {
    _dragStartDX = details.localPosition.dx;
  }

  /// Handle the drawer menu on drag
  void _onHorizontalDragUpdate(
    DragUpdateDetails details,
  ) {
    final dx = details.localPosition.dx;
    final diff = _dragStartDX - dx;
    double perc = (diff / appDrawerWidth);

    if (_isNotifDrawerVisible) {
      perc = (1.0 - perc.abs()).abs().clamp(0.0, 1.0);
      _drawerNotifAnimController.value = perc;
      _contentAnimController.value = perc;
      return;
    }

    if (_isDrawerVisible) {
      perc = (1.0 - perc.clamp(0.0, 1.0).abs());
    } else {
      perc = perc.clamp(-1.0, 0.0).abs();
    }

    if (perc > 0.0) {
      _drawerAnimationController.value = perc;
      _contentAnimController.value = perc;
    } else {
      perc = (diff / getAppDrawerNotifWidth()).clamp(0.0, 1.0);
      _drawerAnimationController.value = 0.0;
      _drawerNotifAnimController.value = perc;
      _contentAnimController.value = perc;
    }
  }

  /// Handle the drawer drag menu
  void _onHorizontalDragComplete(Velocity velocity) {
    bool isOpen = false;
    if (_drawerNotifAnimController.value > 0.0) {
      final animVal = _drawerNotifAnimController.value;
      isOpen = animVal > 0.5;

      if (velocity.pixelsPerSecond.dx.abs() > 1000.0) {
        isOpen = !_isNotifDrawerVisible;
      }

      _drawerAnimationController.value = 0.0;

      if (isOpen) {
        _isNotifDrawerVisible = true;
        _drawerNotifAnimController.forward(from: animVal).orCancel;
        _contentAnimController.forward(from: animVal).orCancel;
      } else {
        _isNotifDrawerVisible = false;
        _drawerNotifAnimController.reverse(from: animVal).orCancel;
        _contentAnimController.reverse(from: animVal).orCancel;
      }
      return;
    }
    final animVal = _drawerAnimationController.value;
    isOpen = animVal > 0.5;

    if (velocity.pixelsPerSecond.dx.abs() > 1000.0) {
      isOpen = !_isDrawerVisible;
    }

    _drawerNotifAnimController.value = 0.0;

    if (isOpen) {
      _isDrawerVisible = true;
      _drawerAnimationController.forward(from: animVal).orCancel;
      _contentAnimController.forward(from: animVal).orCancel;
    } else {
      _isDrawerVisible = false;
      _drawerAnimationController.reverse(from: animVal).orCancel;
      _contentAnimController.reverse(from: animVal).orCancel;
    }
  }

  /// Handle the drawer menu animation
  void _onHorizontalDragEnd(DragEndDetails details) =>
      _onHorizontalDragComplete(details.velocity);

  /// Handle the drawer menu animation
  void _onHorizontalDragCancel() => _onHorizontalDragComplete(Velocity.zero);
}
