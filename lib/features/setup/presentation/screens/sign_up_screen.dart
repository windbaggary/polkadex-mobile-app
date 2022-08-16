import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/common/widgets/option_tab_switch_widget.dart';
import 'package:polkadex/common/widgets/polkadex_snack_bar.dart';
import 'package:polkadex/features/setup/presentation/utils/email_regex.dart';
import 'package:polkadex/features/setup/presentation/widgets/password_validation_widget.dart';
import 'package:polkadex/features/setup/presentation/widgets/wallet_input_widget.dart';
import 'package:polkadex/features/setup/presentation/utils/password_regex.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';
import 'package:polkadex/common/widgets/loading_popup.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/injection_container.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _entryAnimation;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordRepeatController = TextEditingController();

  final ValueNotifier<bool> _hasLeast8Characters = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _hasLeast1Uppercase = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _hasLeast1LowercaseLetter =
      ValueNotifier<bool>(false);
  final ValueNotifier<bool> _hasLeast1Digit = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isNextEnabled = ValueNotifier<bool>(false);
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
    _passwordRepeatController.dispose();

    _hasLeast8Characters.dispose();
    _hasLeast1Uppercase.dispose();
    _hasLeast1LowercaseLetter.dispose();
    _hasLeast1Digit.dispose();
    _isNextEnabled.dispose();
    _isFingerPrintEnabled.dispose();

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
            'Sign up to Orderbook',
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
                            padding: const EdgeInsets.all(20),
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
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Text(
                                    'Polkadex is a fully non-custodial platform',
                                    style: tsS18W400CFF,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: WalletInputWidget(
                                        title: 'Email',
                                        description: 'Set email',
                                        controller: _emailController,
                                        onChanged: (_) => _evalNextEnabled(),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: WalletInputWidget(
                                        title: 'Password',
                                        description: 'Set password',
                                        controller: _passwordController,
                                        obscureText: true,
                                        onChanged: (_) => _evalNextEnabled(),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 32),
                                      child: WalletInputWidget(
                                        title: 'Repeat Password',
                                        description: 'Repeat your password',
                                        controller: _passwordRepeatController,
                                        obscureText: true,
                                        onChanged: (_) => _evalNextEnabled(),
                                      ),
                                    ),
                                    GridView.count(
                                      shrinkWrap: true,
                                      primary: false,
                                      childAspectRatio: (164 / 19),
                                      crossAxisCount: 2,
                                      children: [
                                        ValueListenableBuilder<bool>(
                                          valueListenable: _hasLeast8Characters,
                                          builder: (context, has8chars, _) =>
                                              PasswordValidationWidget(
                                            title: 'At least 8 characters',
                                            isValid: has8chars,
                                          ),
                                        ),
                                        ValueListenableBuilder<bool>(
                                          valueListenable:
                                              _hasLeast1LowercaseLetter,
                                          builder: (context, has1low, _) =>
                                              PasswordValidationWidget(
                                            title: 'At least 1 lowercase',
                                            isValid: has1low,
                                          ),
                                        ),
                                        ValueListenableBuilder<bool>(
                                          valueListenable: _hasLeast1Uppercase,
                                          builder: (context, has1up, _) =>
                                              PasswordValidationWidget(
                                            title:
                                                'At least 1 uppercase letter',
                                            isValid: has1up,
                                          ),
                                        ),
                                        ValueListenableBuilder<bool>(
                                          valueListenable: _hasLeast1Digit,
                                          builder: (context, has1digit, _) =>
                                              PasswordValidationWidget(
                                            title: 'At least 1 digit',
                                            isValid: has1digit,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (dependency.get<bool>(
                                    instanceName: 'isBiometricAvailable'))
                                  ValueListenableBuilder<bool>(
                                    valueListenable: _isFingerPrintEnabled,
                                    builder:
                                        (context, isFingerPrintEnabled, _) =>
                                            OptionTabSwitchWidget(
                                      svgAsset: "finger-print".asAssetSvg(),
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
                      valueListenable: _isNextEnabled,
                      builder: (context, isNextEnabled, _) => AppButton(
                        enabled: isNextEnabled,
                        label: 'Continue',
                        onTap: () => Coordinator.goToCodeVerificationScreen(),
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

  void _onContinuePressed(
    BuildContext context,
  ) async {
    final accountCubit = context.read<AccountCubit>();

    FocusScope.of(context).unfocus();

    LoadingPopup.show(
      context: context,
      text: 'We are almost there...',
    );

    await accountCubit.signUp(
      email: _emailController.text,
      password: _passwordController.text,
    );

    final currentState = accountCubit.state;

    if (currentState is AccountVerifyingCode) {
      Coordinator.goToCodeVerificationScreen();
    } else {
      final errorMsg = currentState is AccountNotLoaded
          ? currentState.errorMessage
          : 'Unexpected error on sign up.';

      PolkadexSnackBar.show(
        context: context,
        text: errorMsg,
      );
    }
  }

  void _evalNextEnabled() {
    _evalPasswordRequirements();

    _isNextEnabled.value = _hasLeast8Characters.value &&
        _hasLeast1Uppercase.value &&
        _hasLeast1LowercaseLetter.value &&
        _hasLeast1Digit.value &&
        EmailRegex.checkIsEmail(_emailController.text) &&
        (_passwordController.text == _passwordRepeatController.text);
  }

  void _evalPasswordRequirements() {
    _hasLeast8Characters.value =
        PasswordRegex.check8Characters(_passwordController.text);
    _hasLeast1Uppercase.value =
        PasswordRegex.check1Uppercase(_passwordController.text);
    _hasLeast1LowercaseLetter.value =
        PasswordRegex.check1Lowercase(_passwordController.text);
    _hasLeast1Digit.value = PasswordRegex.check1Digit(_passwordController.text);
  }

  Future<bool> _onPop(BuildContext context) async {
    await _animationController.reverse();
    Navigator.of(context).pop();
    return false;
  }
}
