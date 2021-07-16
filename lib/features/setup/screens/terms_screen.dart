import 'package:flutter/material.dart';
import 'package:polkadex/configs/app_config.dart';
import 'package:polkadex/features/setup/screens/create_account_screen.dart';
import 'package:polkadex/features/setup/screens/login_scan_screen.dart';
import 'package:polkadex/utils/colors.dart';
import 'package:polkadex/utils/styles.dart';
import 'package:polkadex/utils/extensions.dart';
import 'package:polkadex/widgets/app_buttons.dart';

/// This is the terms screen of the XD
///
/// XD_PAGE: 3
///
class TermsScreen extends StatefulWidget {
  @override
  _TermsScreenState createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _entryAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: AppConfigs.animDuration,
      reverseDuration: AppConfigs.animReverseDuration,
    );
    _entryAnimation = _animationController;
    super.initState();
    Future.microtask(() => _animationController.forward().orCancel);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ThisInheritedWidget(
      onNavigateToCreateAccount: () => _onNavigateToCreateGuide(context),
      onNavigateToLogin: () => _onNavigateToLogin(context),
      child: WillPopScope(
        onWillPop: () => _onPop(context),
        child: Scaffold(
          backgroundColor: color2E303C,
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     _animationController.reset();
          //     _animationController.forward().orCancel;
          //   },
          // ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBackButton(context),
                Spacer(),
                Center(
                  child: AnimatedBuilder(
                    animation: _entryAnimation,
                    builder: (context, child) {
                      final value = _entryAnimation.value;
                      return Transform.translate(
                        offset: Offset(0.0, -50.0 * (1.0 - value)),
                        child: Opacity(
                          opacity: value,
                          child: child,
                        ),
                      );
                    },
                    child: Image.asset(
                      'logo_icon.png'.asAssetImg(),
                      width: 88,
                      height: 88,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 32,
                    right: 32,
                    top: 43,
                  ),
                  child: AnimatedBuilder(
                    animation: _entryAnimation,
                    builder: (context, child) {
                      final value = _entryAnimation.value;
                      return Transform.translate(
                        offset: Offset(0.0, -50.0 * (1.0 - value)),
                        child: Opacity(
                          opacity: value,
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      "Hi there, let’s get started, do you have a PolkadotJs account?",
                      style: tsS23W500CFF,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Spacer(flex: 2),
                _ThisBottomWidget(
                  entryAnimation: _entryAnimation,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AnimatedBuilder(
          animation: _entryAnimation,
          builder: (context, child) {
            final value = _entryAnimation.value;
            return Opacity(
              opacity: value,
              child: Transform(
                  transform: Matrix4.identity()..translate(-50 * (1.0 - value)),
                  child: child),
            );
          },
          child: AppBackButton(
            onTap: () => _onPop(context),
          ),
        ),
      ),
    );
  }

  /// Handling the back button animation
  Future<bool> _onPop(BuildContext context) async {
    await _animationController.reverse().orCancel;
    Navigator.of(context).pop();
    return false;
  }

  /// Navigate to create steps screen after animation
  void _onNavigateToCreateGuide(BuildContext context) async {
    await _animationController.reverse();
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
            opacity: CurvedAnimation(
                parent: animation, curve: Interval(0.500, 1.00)),
            child: CreateAccountScreen());
      },
    )).then((value) => _animationController.forward().orCancel);
  }

  /// Navigate to login screen after animation
  void _onNavigateToLogin(BuildContext context) async {
    await _animationController.reverse();
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
            opacity: CurvedAnimation(
                parent: animation, curve: Interval(0.500, 1.00)),
            child: LoginScanScreen());
      },
    )).then((value) => _animationController.forward().orCancel);
  }
}

/// The bottom row widget. The widget contain Yes & No buttons
///
class _ThisBottomWidget extends AnimatedWidget {
  const _ThisBottomWidget({
    required Animation<double> entryAnimation,
  }) : super(listenable: entryAnimation);

  Animation<double> get _entryAnimation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    final value = _entryAnimation.value;

    return Padding(
      padding: const EdgeInsets.only(left: 36, right: 36, bottom: 36),
      child: Opacity(
        opacity: _entryAnimation.value,
        child: Row(
          children: [
            Expanded(
              child: Transform(
                transform: Matrix4.identity()..translate(-75 * (1 - value)),
                child: AppButton(
                  label: "Yes",
                  onTap: _ThisInheritedWidget.of(context)?.onNavigateToLogin !=
                          null
                      ? _ThisInheritedWidget.of(context)!.onNavigateToLogin
                      : () {},
                ),
              ),
            ),
            SizedBox(width: 40),
            Expanded(
              child: Transform(
                transform: Matrix4.identity()..translate(75 * (1 - value)),
                child: AppButton(
                  label: "No",
                  onTap: _ThisInheritedWidget.of(context)
                              ?.onNavigateToCreateAccount !=
                          null
                      ? _ThisInheritedWidget.of(context)!
                          .onNavigateToCreateAccount
                      : () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThisInheritedWidget extends InheritedWidget {
  /// This method will navigate to the create account steps
  final VoidCallback onNavigateToCreateAccount;

  /// This method will navigate to login screen
  final VoidCallback onNavigateToLogin;

  _ThisInheritedWidget({
    required this.onNavigateToCreateAccount,
    required this.onNavigateToLogin,
    required Widget child,
  }) : super(child: child);

  static _ThisInheritedWidget? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ThisInheritedWidget>();

  @override
  bool updateShouldNotify(covariant _ThisInheritedWidget oldWidget) {
    return oldWidget.onNavigateToCreateAccount != onNavigateToCreateAccount ||
        oldWidget.onNavigateToLogin != onNavigateToLogin;
  }
}
