import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/common/widgets/check_box_widget.dart';
import 'package:polkadex/features/setup/widgets/generated_mnemonic_word_widget.dart';

/// This is the terms screen of the XD
///
/// XD_PAGE: 3
///
class MnemonicGeneratedScreen extends StatefulWidget {
  @override
  _MnemonicGeneratedScreenState createState() =>
      _MnemonicGeneratedScreenState();
}

class _MnemonicGeneratedScreenState extends State<MnemonicGeneratedScreen>
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
      onNavigateToCreateAccount: () => {},
      onNavigateToLogin: () => {},
      child: WillPopScope(
        onWillPop: () => _onPop(context),
        child: Scaffold(
          backgroundColor: color1C2023,
          appBar: AppBar(
            title: Text(
              'Create Wallet',
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
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: color24252C,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 30,
                        offset: Offset(0.0, 20.0),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
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
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Create an account',
                                      style: tsS26W600CFF,
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      'Please write down your wallet’s mnemonic seed and keep it in a safe place.',
                                      style: tsS18W400CFF,
                                    ),
                                    SizedBox(
                                      height: 14,
                                    ),
                                    IgnorePointer(
                                      child: GridView.count(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        primary: false,
                                        childAspectRatio: (120 /
                                            (AppConfigs.size!.height * 0.0572)),
                                        crossAxisSpacing: 7,
                                        mainAxisSpacing: 7,
                                        crossAxisCount: 3,
                                        children: List<Widget>.generate(
                                          24,
                                          (_) => GeneratedMnemonicWordWidget(),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(22, 18, 0, 18),
                        child: Row(
                          children: [
                            CheckBoxWidget(
                              checkColor: colorE6007A,
                              backgroundColor: color3B4150,
                            ),
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(left: 6),
                                child: Text(
                                  'I have saved my mnemonic seed safely.',
                                  style: tsS14W400CFF,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 14, 28, 32),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'The mnemonic can be used to restore your wallet. Keep it carefully to not lose your assets. Having the mnemonic phrases can have a full control over the assets.',
                          textAlign: TextAlign.center,
                          style: tsS14W400CABB2BC,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 28),
                          child: AppButton(
                            enabled: false,
                            label: 'Next',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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

  @override
  bool updateShouldNotify(covariant _ThisInheritedWidget oldWidget) {
    return oldWidget.onNavigateToCreateAccount != onNavigateToCreateAccount ||
        oldWidget.onNavigateToLogin != onNavigateToLogin;
  }
}
