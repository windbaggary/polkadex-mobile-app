import 'package:flutter/material.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/features/setup/presentation/utils/email_regex.dart';
import 'package:polkadex/features/setup/presentation/widgets/wallet_input_widget.dart';

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
                                            const EdgeInsets.only(bottom: 12),
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
                        onTap: () {},
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

  //void _onNextTap(
  //  List<String> mnemonicWords,
  //  String password,
  //  String name,
  //  bool onlyBiometric,
  //) async {
  //  final accountCubit = context.read<AccountCubit>();
  //  final isBiometricAvailable =
  //      dependency.get<bool>(instanceName: 'isBiometricAvailable');
//
  //  FocusScope.of(context).unfocus();
//
  //  if (isBiometricAvailable) {
  //    final hasImported = await accountCubit.savePassword(
  //      password,
  //    );
//
  //    if (!hasImported) {
  //      return;
  //    }
  //  }
//
  //  LoadingPopup.show(
  //    context: context,
  //    text: 'We are almost there...',
  //  );
//
  //  await accountCubit.saveAccount(
  //    mnemonicWords,
  //    password,
  //    name,
  //    onlyBiometric,
  //    isBiometricAvailable,
  //  );
  //  final accountState = accountCubit.state;
//
  //  if (accountState is AccountLoaded) {
  //    await context.read<MarketAssetCubit>().getMarkets();
  //    Coordinator.goToLandingScreen(accountState.account);
  //  } else if (accountState is AccountNotLoaded) {
  //    _onShowRegisterErrorModal(accountState.errorMessage);
  //  }
  //}

  void _evalLogInEnabled() {
    _isLogInEnabled.value = EmailRegex.checkIsEmail(_emailController.text) &&
        _passwordController.text.isNotEmpty;
  }

  //void _onShowRegisterErrorModal(String? errorMessage) {
  //  Navigator.of(context).pop();
  //  showModalBottomSheet(
  //    context: context,
  //    isScrollControlled: true,
  //    shape: RoundedRectangleBorder(
  //      borderRadius: BorderRadius.vertical(
  //        top: Radius.circular(30),
  //      ),
  //    ),
  //    builder: (_) => WarningModalWidget(
  //      title: 'Account register error',
  //      subtitle: errorMessage,
  //    ),
  //  );
  //}

  Future<bool> _onPop(BuildContext context) async {
    await _animationController.reverse();
    Navigator.of(context).pop();
    return false;
  }
}
