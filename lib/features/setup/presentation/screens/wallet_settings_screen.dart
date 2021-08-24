import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/common/widgets/loading_popup.dart';
import 'package:polkadex/common/widgets/option_tab_switch_widget.dart';
import 'package:polkadex/features/landing/screens/landing_screen.dart';
import 'package:polkadex/features/setup/presentation/providers/mnemonic_provider.dart';
import 'package:polkadex/features/setup/presentation/providers/wallet_settings_provider.dart';
import 'package:polkadex/features/setup/presentation/widgets/password_validation_widget.dart';
import 'package:polkadex/features/setup/presentation/widgets/wallet_input_widget.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/generated/l10n.dart';
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

  final _nameController = TextEditingController();
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
    return Consumer<MnemonicProvider>(builder: (context, provider, child) {
      return WillPopScope(
        onWillPop: () => _onPop(context),
        child: Scaffold(
          backgroundColor: color1C2023,
          appBar: AppBar(
            title: Text(
              S.of(context).walletSettings,
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
          body: ChangeNotifierProvider(
              create: (context) => dependency<WalletSettingsProvider>(),
              builder: (context, _) {
                return Consumer<WalletSettingsProvider>(
                    builder: (context, settingProvider, child) {
                  return CustomScrollView(
                    physics: ClampingScrollPhysics(),
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: color2E303C,
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20,
                                        top: 20,
                                        right: 20,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16),
                                            child: Text(
                                              S.of(context).walletSettings,
                                              style: tsS26W600CFF,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 14),
                                            child: Text(
                                              S
                                                  .of(context)
                                                  .securityPasswordIsUsedFor,
                                              style: tsS18W400CFF,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 12),
                                            child: WalletInputWidget(
                                              title: S.of(context).walletName,
                                              description:
                                                  S.of(context).setWalletName,
                                              controller: _nameController,
                                              onChanged: (password) =>
                                                  settingProvider.evalNextEnabled(
                                                      _nameController.text,
                                                      _passwordController.text,
                                                      _passwordRepeatController
                                                          .text),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 12),
                                            child: WalletInputWidget(
                                              title: S.of(context).password,
                                              description:
                                                  S.of(context).setPassword,
                                              controller: _passwordController,
                                              obscureText: true,
                                              onChanged: (password) =>
                                                  settingProvider.evalNextEnabled(
                                                      _nameController.text,
                                                      _passwordController.text,
                                                      _passwordRepeatController
                                                          .text),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 26),
                                            child: WalletInputWidget(
                                              title:
                                                  S.of(context).repeatPassword,
                                              description: S
                                                  .of(context)
                                                  .repeatYourPassword,
                                              controller:
                                                  _passwordRepeatController,
                                              obscureText: true,
                                              onChanged: (password) =>
                                                  settingProvider.evalNextEnabled(
                                                      _nameController.text,
                                                      _passwordController.text,
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
                                                title: S
                                                    .of(context)
                                                    .atLeast8Characters,
                                                isValid: settingProvider
                                                    .hasLeast8Characters,
                                              ),
                                              PasswordValidationWidget(
                                                title: S
                                                    .of(context)
                                                    .atLeast1Lowercase,
                                                isValid: settingProvider
                                                    .hasLeast1LowercaseLetter,
                                              ),
                                              PasswordValidationWidget(
                                                title: S
                                                    .of(context)
                                                    .atLeast1Uppercase,
                                                isValid: settingProvider
                                                    .hasLeast1Uppercase,
                                              ),
                                              PasswordValidationWidget(
                                                title:
                                                    S.of(context).atLeast1Digit,
                                                isValid: settingProvider
                                                    .hasLeast1Digit,
                                              ),
                                            ],
                                          ),
                                          OptionTabSwitchWidget(
                                            svgAsset:
                                                "finger-print".asAssetSvg(),
                                            title: S
                                                .of(context)
                                                .secureWithBiometric,
                                            description: S
                                                .of(context)
                                                .secureYourAccessWithout,
                                            isChecked: settingProvider
                                                .isFingerPrintEnabled,
                                            onSwitchChanged: (value) {
                                              settingProvider.fingerPrintAuth =
                                                  value;
                                            },
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
                                S.of(context).polkadexExchangeAppDoesNot,
                                textAlign: TextAlign.center,
                                style: tsS13W400CABB2BC,
                              ),
                              AppButton(
                                enabled: settingProvider.isNextEnabled &&
                                    _nameController.text.isNotEmpty &&
                                    _passwordController.text ==
                                        _passwordRepeatController.text,
                                label: S.of(context).next,
                                onTap: () => _onNextTap(provider),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                });
              }),
        ),
      );
    });
  }

  void _onNextTap(MnemonicProvider provider) async {
    FocusScope.of(context).unfocus();
    LoadingPopup.show(
      context: context,
      text: S.of(context).weAreAlmostThere,
    );

    await provider.importAccount(_passwordController.text);

    Navigator.of(context).pushAndRemoveUntil(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
            opacity: CurvedAnimation(
                parent: animation, curve: Interval(0.500, 1.00)),
            child: LandingScreen());
      },
    ), (route) => route.isFirst);
  }

  Future<bool> _onPop(BuildContext context) async {
    await _animationController.reverse();
    Navigator.of(context).pop();
    return false;
  }
}
