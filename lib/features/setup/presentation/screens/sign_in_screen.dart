import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/common/widgets/loading_popup.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/common/widgets/polkadex_snack_bar.dart';
import 'package:polkadex/common/widgets/option_tab_switch_widget.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';
import 'package:polkadex/features/setup/presentation/utils/email_regex.dart';
import 'package:polkadex/features/setup/presentation/widgets/wallet_input_widget.dart';
import 'package:polkadex/common/market_asset/presentation/cubit/market_asset_cubit.dart';
import 'package:polkadex/injection_container.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _entryAnimation;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final ValueNotifier<bool> _isLogInEnabled = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isFingerPrintEnabled = ValueNotifier<bool>(false);

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: AppConfigs.animDuration,
      reverseDuration: AppConfigs.animReverseDuration,
    );
    _entryAnimation = _animationController;

    super.initState();
    Future.microtask(() => _animationController.forward());
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onPop(context),
      child: Scaffold(
        backgroundColor: AppColors.color1C2023,
        appBar: AppBar(
          title: Text(
            'Sign in to Orderbook',
            style: tsS19W600CFF,
          ),
          leading: SizedBox(
            height: 5,
            child: AnimatedBuilder(
              animation: _entryAnimation,
              builder: (context, child) {
                final value = _entryAnimation.value;
                return Opacity(
                  opacity: value,
                  child: Transform(
                      transform: Matrix4.identity()
                        ..translate(-50 * (1.0 - value)),
                      child: child),
                );
              },
              child: AppBackButton(
                onTap: () => _onPop(context),
              ),
            ),
          ),
          elevation: 0,
        ),
        body: CustomScrollView(
          physics: ClampingScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.color2E303C,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 30,
                          offset: Offset(0.0, 20.0),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              20,
                              16,
                              20,
                              0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Text(
                                    'Discover the decentralized world',
                                    style: tsS26W600CFF,
                                  ),
                                ),
                                Text(
                                  'Buy and sell cryptocurrencies\nFast and Secure',
                                  style: tsS18W400CFF,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: WalletInputWidget(
                                          title: 'Email',
                                          description: 'Email',
                                          controller: _emailController,
                                          onChanged: (_) => _evalLogInEnabled(),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12),
                                        child: WalletInputWidget(
                                          title: 'Password',
                                          description: 'Password',
                                          controller: _passwordController,
                                          obscureText: true,
                                          onChanged: (_) => _evalLogInEnabled(),
                                        ),
                                      ),
                                      if (dependency.get<bool>(
                                          instanceName: 'isBiometricAvailable'))
                                        ValueListenableBuilder<bool>(
                                          valueListenable:
                                              _isFingerPrintEnabled,
                                          builder: (context,
                                                  isFingerPrintEnabled, _) =>
                                              OptionTabSwitchWidget(
                                            svgAsset:
                                                "finger-print".asAssetSvg(),
                                            title: "Secure with Biometric Only",
                                            description:
                                                "Secure your access without typing your password.",
                                            isChecked: isFingerPrintEnabled,
                                            onSwitchChanged: (newValue) =>
                                                _isFingerPrintEnabled.value =
                                                    newValue,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: 1,
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 14, 28, 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: _isLogInEnabled,
                      builder: (context, isLogInEnabled, _) => AppButton(
                        enabled: isLogInEnabled,
                        label: 'Log In',
                        onTap: () => _onLogInPressed(context),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onLogInPressed(
    BuildContext context,
  ) async {
    final accountCubit = context.read<AccountCubit>();

    FocusScope.of(context).unfocus();

    if (_isFingerPrintEnabled.value) {
      final isPasswordSaved =
          await accountCubit.savePassword(_passwordController.text);

      if (!isPasswordSaved) {
        return;
      }
    }

    LoadingPopup.show(
      context: context,
      text: 'We are almost there...',
    );

    await accountCubit.signIn(
        email: _emailController.text,
        password: _passwordController.text,
        useBiometric: _isFingerPrintEnabled.value);

    Navigator.of(context).pop();

    final currentState = accountCubit.state;

    if (currentState is AccountLoggedIn) {
      await context.read<MarketAssetCubit>().getMarkets();

      Coordinator.goToLandingScreen(currentState.account);
    } else {
      final errorMsg =
          currentState is AccountNotLoaded ? currentState.errorMessage : null;

      PolkadexSnackBar.show(
        context: context,
        text: errorMsg,
      );
    }
  }

  void _evalLogInEnabled() {
    _isLogInEnabled.value = EmailRegex.checkIsEmail(_emailController.text) &&
        _passwordController.text.isNotEmpty;
  }

  Future<bool> _onPop(BuildContext context) async {
    await _animationController.reverse();
    Navigator.of(context).pop();
    return false;
  }
}
