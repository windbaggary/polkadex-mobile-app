import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/common/widgets/option_tab_switch_widget.dart';
import 'package:polkadex/features/setup/presentation/providers/mnemonic_provider.dart';
import 'package:polkadex/features/setup/presentation/widgets/password_validation_widget.dart';
import 'package:polkadex/features/setup/presentation/widgets/wallet_input_widget.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:provider/provider.dart';

class WalletSettingsScreen extends StatefulWidget {
  @override
  _WalletSettingsScreenState createState() => _WalletSettingsScreenState();
}

class _WalletSettingsScreenState extends State<WalletSettingsScreen>
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
          body: CustomScrollView(
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 20,
                                top: 20,
                                right: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Wallet Settings',
                                    style: tsS26W600CFF,
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    'Security password is used for transfers, create orders, mnemonics backups, applications authorization, etc.',
                                    style: tsS18W400CFF,
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  WalletInputWidget(
                                    title: 'Wallet Name',
                                    description: 'Set wallet name',
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  WalletInputWidget(
                                    title: 'Password',
                                    description: 'Set password',
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  WalletInputWidget(
                                    title: 'Repeat Password',
                                    description: 'Repeat your password',
                                  ),
                                  SizedBox(
                                    height: 26,
                                  ),
                                  GridView.count(
                                    shrinkWrap: true,
                                    primary: false,
                                    childAspectRatio: (164 / 19),
                                    crossAxisCount: 2,
                                    children: [
                                      PasswordValidationWidget(
                                        title: 'At least 8 characters',
                                        isValid: true,
                                      ),
                                      PasswordValidationWidget(
                                        title: 'At least 1 lowercase',
                                        isValid: true,
                                      ),
                                      PasswordValidationWidget(
                                        title: 'At least 1 uppercase letter',
                                      ),
                                      PasswordValidationWidget(
                                        title: 'At least 1 digit',
                                      ),
                                    ],
                                  ),
                                  OptionTabSwitchWidget(
                                    svgAsset: "finger-print".asAssetSvg(),
                                    title: "Secure with FingerPrint",
                                    description:
                                        "Secure your access without typing your Pin Code.",
                                    isChecked: provider.isFingerPrint,
                                    onSwitchChanged: (value) {
                                      provider.fingerPrintAuth = value;
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
                  padding: const EdgeInsets.fromLTRB(28, 14, 28, 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Polkadex Exchange eApp does not keep it, if you forget the password, you cannot restore it.',
                        textAlign: TextAlign.center,
                        style: tsS13W400CABB2BC,
                      ),
                      AppButton(
                        enabled: provider.isButtonBackupVerificationEnabled,
                        label: 'Next',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  /// Handling the back button animation
  Future<bool> _onPop(BuildContext context) async {
    await _animationController.reverse();
    Navigator.of(context).pop();
    return false;
  }
}
