import 'package:flutter/material.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/features/setup/presentation/providers/mnemonic_provider.dart';
import 'package:polkadex/features/setup/presentation/widgets/warning_mnemonic_widget.dart';
import 'package:polkadex/features/setup/presentation/widgets/mnemonic_grid_widget.dart';
import 'package:provider/provider.dart';

class BackupMnemonicScreen extends StatefulWidget {
  @override
  _BackupMnemonicScreenState createState() => _BackupMnemonicScreenState();
}

class _BackupMnemonicScreenState extends State<BackupMnemonicScreen>
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
    return Consumer<MnemonicProvider>(
      builder: (context, provider, child) {
        return WillPopScope(
          onWillPop: () => _onPop(context),
          child: Scaffold(
            backgroundColor: AppColors.color1C2023,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Backup mnemonic phrases',
                                      style: tsS26W600CFF,
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      'Please enter the 12-24 words in the correct order.',
                                      style: tsS18W400CFF,
                                    ),
                                    SizedBox(
                                      height: 14,
                                    ),
                                    MnemonicGridWidget(
                                      mnemonicWords:
                                          provider.shuffledMnemonicWords,
                                      isDragEnabled: true,
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
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 28),
                        child: AppButton(
                          enabled: provider.hasShuffledMnemonicChanged,
                          label: 'Next',
                          onTap: () => provider.verifyMnemonicOrder()
                              ? Coordinator.goToWalletSettingsScreen(provider)
                              : showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30),
                                    ),
                                  ),
                                  builder: (_) => WarningModalWidget(
                                    title: 'Incorrect mnemonic phrase',
                                    subtitle: 'Please enter again.',
                                    imagePath: 'mnemonic_error.png',
                                    details:
                                        'One or more of your 12-24 words are incorrect, make sure that the order is correct or if there is a typing error.',
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  /// Handling the back button animation
  Future<bool> _onPop(BuildContext context) async {
    await _animationController.reverse();
    Navigator.of(context).pop();
    return false;
  }
}
