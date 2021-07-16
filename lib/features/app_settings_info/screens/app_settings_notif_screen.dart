import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/features/app_settings_info/widgets/app_settings_layout.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/utils/extensions.dart';

/// XD_PAGE: 45
class AppSettingsNotificationScreen extends StatefulWidget {
  @override
  _AppSettingsNotificationScreenState createState() =>
      _AppSettingsNotificationScreenState();
}

class _AppSettingsNotificationScreenState
    extends State<AppSettingsNotificationScreen>
    with SingleTickerProviderStateMixin {
  // AnimationController _animationController;

  @override
  void initState() {
    // _animationController = AnimationController(
    //     vsync: this,
    //     duration: AppConfigs.animDuration * 1.5,
    //     reverseDuration: AppConfigs.animReverseDuration * 1.5);
    super.initState();
    // Future.microtask(() {
    //   if (_animationController != null) {
    //     _animationController.forward().orCancel;
    //   }
    // });
  }

  @override
  void dispose() {
    // _animationController.dispose();
    // _animationController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        //  _ThisInheritedWidget(
        //   // animationController: _animationController,
        //   child:
        WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: color1C2023,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     _animationController.reset();
        //     _initialiseAnimations();
        //     _animationController.forward().orCancel;
        //   },
        // ),
        body: AppSettingsLayout(
          // animationController: _animationController,
          onBack: () =>
              this._onWillPop().then((value) => Navigator.of(context).pop()),
          subTitle: 'Notifications',
          mainTitle: 'Notifications',
          isShowSubTitle: false,
          contentChild: Padding(
            padding: const EdgeInsets.only(
              left: 21.0,
              right: 18.0,
              top: 16,
              bottom: 14,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: EnumNotificationsMenu.values
                  .map((e) => _buildMenuItem(e))
                  .toList(),
            ),
          ),
        ),
      ),
      // ),
    );
  }

  /// The widget represents the each items in the list of the screen
  Widget _buildMenuItem(EnumNotificationsMenu e) {
    String description;
    String title;
    List<EnumNotificationAlert> lockedMenu;

    switch (e) {
      case EnumNotificationsMenu.Withdraw:
        lockedMenu = [EnumNotificationAlert.Email];
        title = "Withdraw";
        description = 'Notify when a withdrawal is requested.';
        break;
      case EnumNotificationsMenu.Deposit:
        title = "Deposit";
        description = 'Notify when a funds are received.';
        break;
      case EnumNotificationsMenu.FilledOrder:
        title = "Filled order";
        description = 'Notify when an order is filled.';
        break;
    }

    return _ThisMenuItemWidget(
      description: description,
      title: title,
      isShowLine: EnumNotificationsMenu.values.indexOf(e) !=
          EnumNotificationsMenu.values.length - 1,
      lockedItems: lockedMenu,
    );
  }

  /// Handles the backbutton in android
  Future<bool> _onWillPop() async {
    // await _animationController.reverse().orCancel;
    return true;
  }
}

/// The widget represents the each items in the list of the screen
class _ThisMenuItemWidget extends StatelessWidget {
  const _ThisMenuItemWidget({
    Key key,
    @required this.title,
    @required this.description,
    this.onEmailTap,
    this.onPhoneTap,
    this.onPushTap,
    this.isShowLine = true,
    this.lockedItems,
  }) : super(key: key);

  final String title;
  final String description;
  final VoidCallback onEmailTap;
  final VoidCallback onPhoneTap;
  final VoidCallback onPushTap;
  final bool isShowLine;
  final List<EnumNotificationAlert> lockedItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 21),
      decoration: BoxDecoration(
        border: isShowLine
            ? Border(
                bottom: BorderSide(
                  width: 1.0,
                  color: colorFFFFFF.withOpacity(0.10),
                ),
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title ?? "",
            style: tsS16W400CFF,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.0, bottom: 14.0),
            child: Text(
              description ?? "",
              style: tsS13W400CFFOP60,
            ),
          ),
          Row(
            children: EnumNotificationAlert.values
                .map((e) => _buildAlertWidget(e))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertWidget(EnumNotificationAlert e) {
    String label;
    String svgAsset;

    // double _deltaX;
    switch (e) {
      case EnumNotificationAlert.Email:
        label = 'Email';
        svgAsset = 'email'.asAssetSvg();
        // _deltaX = 0.0;
        break;
      case EnumNotificationAlert.Phone:
        label = 'Phone';
        svgAsset = 'message-text'.asAssetSvg();
        // _deltaX = 1.0;
        break;
      case EnumNotificationAlert.Push:
        label = 'Push';
        svgAsset = 'phone'.asAssetSvg();
        // _deltaX = 2.0;
        break;
    }

    // final double delta = _deltaX * 0.1666;
    // final double begin = (0.50 + delta).clamp(0.0, 1.0);
    // final double end = (0.6666 + delta).clamp(0.0, 1.0);
    // print(delta);
    return Builder(
      builder: (context) =>
          //  FadeTransition(
          //   opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          //     CurvedAnimation(
          //       parent: _ThisInheritedWidget.of(context).animationController,
          //       curve: Interval(
          //         begin,
          //         end,
          //         curve: Curves.decelerate,
          //       ),
          //     ),
          //   ),
          //   child: SlideTransition(
          //     position: Tween<Offset>(
          //       begin: Offset(-0.5 + delta, 0.0),
          //       end: Offset(0.0, 0.0),
          //     ).animate(CurvedAnimation(
          //         parent: _ThisInheritedWidget.of(context).animationController,
          //         curve: Interval(
          //           begin,
          //           end,
          //           curve: Curves.decelerate,
          //         ))),
          //     child:
          _ThisAlertItemWidget(
        label: label,
        svgAsset: svgAsset,
        isLocked: this.lockedItems?.contains(e) ?? false,
        isActive: this.lockedItems?.contains(e) ?? false,
      ),
      //   ),
      // ),
    );
  }
}

class _ThisAlertItemWidget extends StatelessWidget {
  _ThisAlertItemWidget({
    Key key,
    @required this.label,
    @required this.svgAsset,
    this.isLocked = false,
    this.isActive = false,
    this.onTap,
  })  : this._selectedNotifier = ValueNotifier<bool>(isActive),
        super(key: key);

  final ValueNotifier<bool> _selectedNotifier;

  final String label;
  final String svgAsset;
  final bool isLocked;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.isLocked
          ? null
          : () {
              _selectedNotifier.value = !_selectedNotifier.value;
              if (this.onTap != null) this.onTap();
            },
      child: ValueListenableBuilder<bool>(
        valueListenable: _selectedNotifier,
        builder: (context, isSelected, child) => AnimatedContainer(
          duration: AppConfigs.animDurationSmall,
          decoration: BoxDecoration(
              color: isSelected ? colorE6007A : color8BA1BE.withOpacity(0.20),
              borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.fromLTRB(11, 11, 0, 12),
          child: Row(
            children: [
              SizedBox(
                width: 13,
                height: 14,
                child: SvgPicture.asset(
                  svgAsset,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6.0, right: 5.0),
                child: Text(
                  label ?? "",
                  style: tsS14W400CFF,
                ),
              ),
              if (this.isLocked ?? false) SvgPicture.asset('lock'.asAssetSvg()),
              SizedBox(width: 11),
            ],
          ),
        ),
      ),
    );
  }
}

// class _ThisInheritedWidget extends InheritedWidget {
//   // final AnimationController animationController;

//   _ThisInheritedWidget(
//       {
//       // @required this.animationController,
//       @required Widget child,
//       Key key})
//       : super(child: child, key: key);

//   @override
//   bool updateShouldNotify(covariant _ThisInheritedWidget oldWidget) {
//     // return oldWidget.animationController != this.animationController;
//     return false;
//   }

//   // static _ThisInheritedWidget of(BuildContext context) =>
//   //     context.dependOnInheritedWidgetOfExactType<_ThisInheritedWidget>();
// }
