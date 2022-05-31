import 'package:flutter/material.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/common/widgets/loading_popup.dart';
import 'package:polkadex/common/widgets/option_tab_switch_widget.dart';
import 'package:polkadex/features/setup/presentation/providers/mnemonic_provider.dart';
import 'package:polkadex/features/setup/presentation/providers/wallet_settings_provider.dart';
import 'package:polkadex/features/setup/presentation/widgets/password_validation_widget.dart';
import 'package:polkadex/features/setup/presentation/widgets/wallet_input_widget.dart';
import 'package:polkadex/common/market_asset/presentation/cubit/market_asset_cubit.dart';
import 'package:polkadex/common/utils/string_utils.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/features/setup/presentation/widgets/warning_mnemonic_widget.dart';
import 'package:polkadex/injection_container.dart';
import 'package:provider/provider.dart';

class WalletSettingsScreen extends StatefulWidget {
  @override
  _WalletSettingsScreenState createState() => _WalletSettingsScreenState();
}

class _WalletSettingsScreenState extends State<WalletSettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _entryAnimation;

  final _generatedPassword = StringUtils.generateCryptoRandomString(length: 16);
  final _nameController = TextEditingController(text: 'Cool Wallet');
  final _passwordController = TextEditingController();
  final _passwordRepeatController = TextEditingController();

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: AppConfigs.animDuration,
      reverseDuration: AppConfigs.animReverseDuration,
    );
    _entryAnimation = _animationController;

    if (context.read<WalletSettingsProvider>().isBiometricOnlyEnabled) {
      _passwordController.text = _generatedPassword;
      _passwordRepeatController.text = _generatedPassword;
    }

    WidgetsBinding.instance?.addPostFrameCallback((_) => context
        .read<WalletSettingsProvider>()
        .evalNextEnabled(_nameController.text, _passwordController.text,
            _passwordRepeatController.text));

    super.initState();
    Future.microtask(() => _animationController.forward());
  }

  @override
  void dispose() {
    _animationController.dispose();
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
            'Wallet Settings',
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
        body: Consumer<WalletSettingsProvider>(
            builder: (context, settingProvider, child) {
          return CustomScrollView(
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
                              padding: const EdgeInsets.only(
                                left: 20,
                                top: 20,
                                right: 20,
                                bottom: 32,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Text(
                                      'Wallet Settings',
                                      style: tsS26W600CFF,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 14),
                                    child: Text(
                                      'Security password is used for transfers, create orders, mnemonics backups, applications authorization, etc.',
                                      style: tsS18W400CFF,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: WalletInputWidget(
                                      title: 'Wallet Name',
                                      description: 'Set wallet name',
                                      controller: _nameController,
                                      onChanged: (password) =>
                                          settingProvider.evalNextEnabled(
                                              _nameController.text,
                                              _passwordController.text,
                                              _passwordRepeatController.text),
                                    ),
                                  ),
                                  AnimatedSize(
                                    duration: AppConfigs.animDurationSmall,
                                    child: settingProvider
                                            .isBiometricOnlyEnabled
                                        ? Container()
                                        : Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 12),
                                                child: WalletInputWidget(
                                                  title: 'Password',
                                                  description: 'Set password',
                                                  controller:
                                                      _passwordController,
                                                  obscureText: true,
                                                  onChanged: (password) =>
                                                      settingProvider
                                                          .evalNextEnabled(
                                                              _nameController
                                                                  .text,
                                                              _passwordController
                                                                  .text,
                                                              _passwordRepeatController
                                                                  .text),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 26),
                                                child: WalletInputWidget(
                                                  title: 'Repeat Password',
                                                  description:
                                                      'Repeat your password',
                                                  controller:
                                                      _passwordRepeatController,
                                                  obscureText: true,
                                                  onChanged: (password) =>
                                                      settingProvider
                                                          .evalNextEnabled(
                                                              _nameController
                                                                  .text,
                                                              _passwordController
                                                                  .text,
                                                              _passwordRepeatController
                                                                  .text),
                                                ),
                                              ),
                                              GridView.count(
                                                shrinkWrap: true,
                                                primary: false,
                                                childAspectRatio: (164 / 19),
                                                crossAxisCount: 2,
                                                children: [
                                                  PasswordValidationWidget(
                                                    title:
                                                        'At least 8 characters',
                                                    isValid: settingProvider
                                                        .hasLeast8Characters,
                                                  ),
                                                  PasswordValidationWidget(
                                                    title:
                                                        'At least 1 lowercase',
                                                    isValid: settingProvider
                                                        .hasLeast1LowercaseLetter,
                                                  ),
                                                  PasswordValidationWidget(
                                                    title:
                                                        'At least 1 uppercase letter',
                                                    isValid: settingProvider
                                                        .hasLeast1Uppercase,
                                                  ),
                                                  PasswordValidationWidget(
                                                    title: 'At least 1 digit',
                                                    isValid: settingProvider
                                                        .hasLeast1Digit,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                  ),
                                  if (dependency.get<bool>(
                                      instanceName: 'isBiometricAvailable'))
                                    OptionTabSwitchWidget(
                                      svgAsset: "finger-print".asAssetSvg(),
                                      title: "Secure with Biometric Only",
                                      description:
                                          "Secure your access without typing your password.",
                                      isChecked: settingProvider
                                          .isBiometricOnlyEnabled,
                                      onSwitchChanged: (value) =>
                                          _onSwitchChanged(
                                              settingProvider, value),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Polkadex Exchange eApp does not keep it, if you forget the password, you cannot restore it.',
                        textAlign: TextAlign.center,
                        style: tsS13W400CABB2BC,
                      ),
                      AppButton(
                        enabled: settingProvider.isNextEnabled &&
                            _nameController.text.isNotEmpty &&
                            _passwordController.text ==
                                _passwordRepeatController.text,
                        label: 'Next',
                        onTap: () => _onNextTap(
                            Provider.of<MnemonicProvider>(context,
                                    listen: false)
                                .mnemonicWords,
                            _passwordController.text,
                            _nameController.text,
                            settingProvider.isBiometricOnlyEnabled),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  void _onSwitchChanged(WalletSettingsProvider provider, bool value) {
    if (value) {
      _passwordController.text = _generatedPassword;
      _passwordRepeatController.text = _generatedPassword;
    } else {
      _passwordController.text = '';
      _passwordRepeatController.text = '';
    }

    provider.evalNextEnabled(_nameController.text, _passwordController.text,
        _passwordRepeatController.text);
    provider.fingerPrintAuth = value;
  }

  void _onNextTap(
    List<String> mnemonicWords,
    String password,
    String name,
    bool onlyBiometric,
  ) async {
    final accountCubit = context.read<AccountCubit>();
    final isBiometricAvailable =
        dependency.get<bool>(instanceName: 'isBiometricAvailable');

    FocusScope.of(context).unfocus();

    if (isBiometricAvailable) {
      final hasImported = await accountCubit.savePassword(
        password,
      );

      if (!hasImported) {
        return;
      }
    }

    LoadingPopup.show(
      context: context,
      text: 'We are almost there...',
    );

    await accountCubit.saveAccount(
      mnemonicWords,
      password,
      name,
      onlyBiometric,
      isBiometricAvailable,
    );
    final accountState = accountCubit.state;

    if (accountState is AccountLoaded) {
      await context.read<MarketAssetCubit>().getMarkets();
      Coordinator.goToLandingScreen(accountState.account);
    } else {
      _onShowRegisterErrorModal();
    }
  }

  void _onShowRegisterErrorModal() {
    Navigator.of(context).pop();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (_) => WarningModalWidget(
        title: 'Account register error',
        subtitle:
            'Something went on while registering the account. Please try again.',
      ),
    );
  }

  Future<bool> _onPop(BuildContext context) async {
    await _animationController.reverse();
    Navigator.of(context).pop();
    return false;
  }
}
