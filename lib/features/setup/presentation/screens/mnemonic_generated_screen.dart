import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/common/widgets/check_box_widget.dart';
import 'package:polkadex/features/setup/presentation/providers/mnemonic_provider.dart';
import 'package:polkadex/features/setup/presentation/widgets/mnemonic_grid_shimmer_widget.dart';
import 'package:polkadex/features/setup/presentation/widgets/mnemonic_grid_widget.dart';
import 'package:provider/provider.dart';

class MnemonicGeneratedScreen extends StatefulWidget {
  @override
  _MnemonicGeneratedScreenState createState() =>
      _MnemonicGeneratedScreenState();
}

class _MnemonicGeneratedScreenState extends State<MnemonicGeneratedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _entryAnimation;
  bool _isButtonToBackupEnabled = false;

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
          body: CustomScrollView(
            physics: ClampingScrollPhysics(),
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        provider.isLoading
                                            ? MnemonicGridShimmerWidget()
                                            : MnemonicGridWidget(
                                                mnemonicWords:
                                                    provider.mnemonicWords,
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
                                  isChecked: _isButtonToBackupEnabled,
                                  onTap: (_) => setState(() =>
                                      _isButtonToBackupEnabled =
                                          !_isButtonToBackupEnabled),
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
                        'The mnemonic can be used to restore your wallet. Keep it carefully to not lose your assets. Having the mnemonic phrases can have a full control over the assets.',
                        textAlign: TextAlign.center,
                        style: tsS13W400CABB2BC,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 28),
                        child: AppButton(
                          onTap: () => Coordinator.goToBackupMnemonic(
                              provider..shuffleMnemonicWords()),
                          enabled:
                              _isButtonToBackupEnabled && !provider.isLoading,
                          label: 'Next',
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
    });
  }

  /// Handling the back button animation
  Future<bool> _onPop(BuildContext context) async {
    await _animationController.reverse();
    Navigator.of(context).pop();
    return false;
  }
}
