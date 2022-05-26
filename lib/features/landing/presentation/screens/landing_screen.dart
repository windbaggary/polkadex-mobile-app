import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/cubits/account_cubit.dart';
import 'package:polkadex/common/orderbook/presentation/cubit/orderbook_cubit.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
import 'package:polkadex/features/landing/presentation/providers/home_scroll_notif_provider.dart';
import 'package:polkadex/features/landing/presentation/providers/notification_drawer_provider.dart';
import 'package:polkadex/features/landing/presentation/providers/trade_tab_provider.dart';
import 'package:polkadex/features/landing/presentation/sub_views/balance_tab_view.dart';
import 'package:polkadex/features/landing/presentation/sub_views/exchange_tab_view.dart';
import 'package:polkadex/features/landing/presentation/sub_views/home_tab_view.dart';
import 'package:polkadex/features/landing/presentation/sub_views/trade_tab_view.dart';
import 'package:polkadex/features/landing/presentation/widgets/app_bottom_navigation_bar.dart';
import 'package:polkadex/features/landing/presentation/widgets/app_drawer_widget.dart';
import 'package:polkadex/common/providers/bottom_navigation_provider.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/injection_container.dart';
import 'package:provider/provider.dart';

/// XD_PAGE: 34
class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  // AnimationController _entryAnimationController;
  // Animation<Offset> _offsetBottomTopAnimation;
  // Animation<double> _appbarAnimation;
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

    // Future.microtask(() => _initAnimations());
    _initAnimations();

    // _entryAnimationController = AnimationController(
    //     vsync: this,
    //     duration: AppConfigs.animDuration,
    //     reverseDuration: AppConfigs.animReverseDuration);
    // _initAnimations();

    super.initState();
    // Future.microtask(() => _entryAnimationController.forward().orCancel);
  }

  @override
  void dispose() {
    // _entryAnimationController.dispose();
    // _entryAnimationController = null;

    _titleNotifier.dispose();

    _drawerAnimationController.dispose();
    _drawerNotifAnimController.dispose();
    _contentAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<BalanceCubit>(
            create: (_) => dependency<BalanceCubit>()
              ..getBalance(context.read<AccountCubit>().accountAddress),
          ),
          BlocProvider<OrderbookCubit>(
            create: (_) => dependency<OrderbookCubit>()
              ..fetchOrderbookData(
                leftTokenId: '0',
                rightTokenId: '1',
              ),
          ),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<NotificationDrawerProvider>(
                create: (context) => NotificationDrawerProvider()),
            ChangeNotifierProvider<HomeScrollNotifProvider>(
                create: (_) => HomeScrollNotifProvider()),
            ChangeNotifierProvider<TradeTabCoinProvider>(
                create: (context) => TradeTabCoinProvider()),
          ],
          builder: (context, child) => _ThisInheritedWidget(
            onOpenDrawer: _onOpenDrawer,
            onOpenRightDrawer: _onOpenRightDrawer,
            appbarTitleNotifier: _titleNotifier,
            onNotificationTap: _onOpenRightDrawer,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: AppColors.color1C2023,
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
                                offset: Offset(
                                    _rightDrawerWidthAnimation.value, 0.0),
                                child: child,
                              ),
                          child: AppDrawerWidget()),
                      AnimatedBuilder(
                        animation: _rightDrawerWidthAnimation,
                        builder: (context, child) => Transform.translate(
                            offset:
                                Offset(_rightDrawerWidthAnimation.value, 0.0),
                            child: child),
                        child: AnimatedBuilder(
                          animation: _contentAnimController,
                          builder: (context, child) {
                            return Container(
                              transform: Matrix4.translationValues(
                                  _leftDrawerWidthAnimation.value, 0.0, 0.0),
                              decoration: BoxDecoration(
                                color: AppColors.color1C2023,
                                borderRadius:
                                    _drawerContentRadiusAnimation.value,
                              ),
                              foregroundDecoration: BoxDecoration(
                                color: _drawerContentColorAnimation.value,
                                borderRadius:
                                    _drawerContentRadiusAnimation.value,
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: InkWell(
                                onTap: (_isDrawerVisible ||
                                        _isNotifDrawerVisible)
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
                          child: _ThisContentWidget(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
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

  /// Open the drawer menu
  ///
  void _onOpenDrawer() {
    _drawerAnimationController.reset();
    _contentAnimController.reset();
    _drawerAnimationController.forward().orCancel;
    _contentAnimController.forward().orCancel;
    _isDrawerVisible = true;
  }

  void _onOpenRightDrawer() {
    _drawerNotifAnimController.reset();
    _contentAnimController.reset();
    _drawerNotifAnimController.forward().orCancel;
    _contentAnimController.forward().orCancel;
    _isNotifDrawerVisible = true;
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

class _ThisContentWidget extends StatefulWidget {
  @override
  __ThisContentWidgetState createState() => __ThisContentWidgetState();
}

class __ThisContentWidgetState extends State<_ThisContentWidget>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  late ValueNotifier<EnumBottonBarItem> _bottomNavbarNotifier;
  StreamSubscription<EnumBottonBarItem>? _bottomBarStreamSubScription;

  @override
  void initState() {
    _bottomNavbarNotifier =
        ValueNotifier<EnumBottonBarItem>(EnumBottonBarItem.home);

    _tabController =
        TabController(length: EnumBottonBarItem.values.length, vsync: this)
          ..addListener(() {
            context.read<HomeScrollNotifProvider>().scrollOffset = 0.0;
          });

    WidgetsBinding.instance!.addObserver(this);
    _subscribeBottomBarStream();

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bottomNavbarNotifier.dispose();
    _unsubscribeBottomBar();
    WidgetsBinding.instance!.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      context.read<BalanceCubit>().balanceTimer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<EnumBottonBarItem>(
      valueListenable: _bottomNavbarNotifier,
      builder: (context, selectedMenu, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _ThisAppBar(_bottomNavbarNotifier.value),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: TabBarView(
                      controller: _tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: EnumBottonBarItem.values
                          .map((e) => _buildBottomBarTab(e))
                          .toList(),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Consumer2<BottomNavigationProvider,
                        HomeScrollNotifProvider>(
                      builder: (context, bottomNavigationProvider,
                          homeScrollProvider, child) {
                        return Container(
                          height: homeScrollProvider.bottombarSize -
                              homeScrollProvider.bottombarValue,
                          child: SingleChildScrollView(
                            physics: NeverScrollableScrollPhysics(),
                            child: Container(
                              transform: Matrix4.identity(),
                              height: homeScrollProvider.bottombarSize,
                              child: AppBottomNavigationBar(
                                onSelected: _onBottomNavigationSelected,
                                initialItem: EnumBottonBarItem
                                    .values[_tabController.index],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// Widget to build the content view based on bottom navigation bar selection
  Widget _buildBottomBarTab(EnumBottonBarItem e) {
    switch (e) {
      case EnumBottonBarItem.home:
        return HomeTabView();
      case EnumBottonBarItem.exchange:
        return ExchangeTabView(
          onBottombarItemSel: _onBottomNavigationSelected,
          tabController: _tabController,
        );
      case EnumBottonBarItem.trade:
        return TradeTabView();
      case EnumBottonBarItem.balance:
        return BalanceTabView();
    }
  }

  /// This method will be called when user click on search icon on app bar
  // void _onSearchTap(BuildContext context) {}
  void _onBottomNavigationSelected(EnumBottonBarItem item) {
    _bottomNavbarNotifier.value = item;
    String title = "Hello Kas";
    switch (item) {
      case EnumBottonBarItem.home:
        title = "Hello Kas";
        break;
      case EnumBottonBarItem.exchange:
        title = "Exchange";
        break;
      case EnumBottonBarItem.trade:
        title = "Trade";
        break;
      case EnumBottonBarItem.balance:
        title = "Balance";
        break;
    }
    Future.microtask(() =>
        _ThisInheritedWidget.of(context)?.appbarTitleNotifier.value = title);
    _tabController.animateTo(EnumBottonBarItem.values.indexOf(item),
        curve: Curves.easeIn);
  }

  /// Unsubscribe from bottom navigation bar selection
  void _unsubscribeBottomBar() {
    _bottomBarStreamSubScription?.cancel();
  }

  /// Subscribe to bottom navigation bar selection
  void _subscribeBottomBarStream() {
    _unsubscribeBottomBar();
    _bottomBarStreamSubScription =
        BottomNavigationProvider().streamBottomBarItem.listen((type) {
      _tabController.animateTo(EnumBottonBarItem.values.indexOf(type));
    });
  }
}

/// The app bar for the landing screen. This wideget is shown as appbar for
/// all the tabviews
class _ThisBaseAppbar extends StatelessWidget with PreferredSizeWidget {
  final String assetImg;
  final String title;
  final List<Widget> actions;
  // final Animation<double> animation;

  /// The call back listner for avatar onTap
  final VoidCallback onAvatarTapped;

  const _ThisBaseAppbar({
    required this.assetImg,
    required this.title,
    required this.actions,
    required this.onAvatarTapped,
    // this.animation,
  });
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            if (assetImg.isNotEmpty) _buildAvatar(),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: SvgPicture.asset(
                    'title'.asAssetSvg(),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            if (actions.isNotEmpty) _buildNotification(),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, kToolbarHeight);

  Widget _buildAvatar() {
    return InkWell(
      onTap: onAvatarTapped,
      child: Container(
        width: 40,
        height: 40,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: AppColors.color558BA1BE, shape: BoxShape.circle),
        child: SvgPicture.asset(
          'profile'.asAssetSvg(),
          color: Colors.white,
          fit: BoxFit.contain,
        ),
      ),
      // ),
    );
  }

  Widget _buildNotification() {
    return Row(children: actions);
  }
}

/// The inherited widget for the entire screen to access the parent methods
/// from the child widgets
class _ThisInheritedWidget extends InheritedWidget {
  /// Method to open the left drawer menu
  final VoidCallback onOpenDrawer;

  /// Method to open the right drawer menu
  final VoidCallback onOpenRightDrawer;

  /// Set the title on the appbar
  final ValueNotifier<String> appbarTitleNotifier;

  /// Handle the notification icon click on app bar
  final VoidCallback onNotificationTap;

  _ThisInheritedWidget({
    required this.onOpenDrawer,
    required this.onOpenRightDrawer,
    required this.appbarTitleNotifier,
    required this.onNotificationTap,
    required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(covariant _ThisInheritedWidget oldWidget) {
    return oldWidget.onOpenDrawer != onOpenDrawer ||
        oldWidget.onOpenRightDrawer != onOpenRightDrawer ||
        oldWidget.onNotificationTap != onNotificationTap ||
        oldWidget.appbarTitleNotifier != appbarTitleNotifier;
  }

  static _ThisInheritedWidget? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ThisInheritedWidget>();
}

/// The app bar widget for the screen.
class _ThisAppBar extends StatelessWidget {
  const _ThisAppBar(this.bottomNavbarValue);

  final EnumBottonBarItem bottomNavbarValue;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeScrollNotifProvider>();
    return bottomNavbarValue == EnumBottonBarItem.home ||
            bottomNavbarValue == EnumBottonBarItem.balance
        ? Container(
            height: kToolbarHeight - provider.appbarValue,
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                transform: Matrix4.identity()
                  ..translate(0.0, -provider.appbarValue),
                height: kToolbarHeight,
                child: ValueListenableBuilder<String>(
                  valueListenable:
                      _ThisInheritedWidget.of(context)!.appbarTitleNotifier,
                  builder: (context, title, child) => _ThisBaseAppbar(
                    // animation: this._appbarAnimation,
                    assetImg: 'user_icon.png'.asAssetImg(),
                    title: title,
                    actions: [
                      InkWell(
                        onTap: () => _ThisInheritedWidget.of(context)!
                            .onNotificationTap(),
                        child: Container(
                          width: 40,
                          height: 40,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: AppColors.color558BA1BE,
                              shape: BoxShape.circle),
                          child: SvgPicture.asset(
                            'notifications'.asAssetSvg(),
                            color: Colors.white,
                            fit: BoxFit.contain,
                          ),
                        ),
                        // ),
                      )
                    ],
                    onAvatarTapped: () =>
                        _ThisInheritedWidget.of(context)!.onOpenDrawer(),
                  ),
                ),
              ),
            ),
          )
        : Container();
  }
}
