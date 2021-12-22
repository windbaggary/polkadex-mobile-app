import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:provider/provider.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/features/setup/presentation/widgets/available_method_widget.dart';
import 'package:polkadex/features/setup/presentation/providers/mnemonic_provider.dart';
import 'package:polkadex/common/utils/extensions.dart';

class ImportWalletMethodsScreen extends StatefulWidget {
  @override
  _ImportWalletMethodsScreenState createState() =>
      _ImportWalletMethodsScreenState();
}

class _ImportWalletMethodsScreenState extends State<ImportWalletMethodsScreen>
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
                'Import Wallet',
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
                                      'Available import wallet methods',
                                      style: tsS26W600CFF,
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      'Type your secret phrase to restore your existing wallet.',
                                      style: tsS18W400CFF,
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    AvailableMethodWidget(
                                      title: 'Mnemonic Phrase',
                                      description:
                                          'Add a wallet by importing recovery phase',
                                      iconWidget: SvgPicture.asset(
                                        'mnemonicIcon'.asAssetSvg(),
                                      ),
                                      onTap: (_) => Coordinator
                                          .goToRestoreExistingWalletScreen(),
                                    ),
                                    SizedBox(
                                      height: 14,
                                    ),
                                    AvailableMethodWidget(
                                      title: 'Json File',
                                      description:
                                          'Import wallet from backup JSON file',
                                      iconWidget: SvgPicture.asset(
                                        'jsonIcon'.asAssetSvg(),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 14,
                                    ),
                                    AvailableMethodWidget(
                                      title: 'Ledger Device',
                                      description:
                                          'Connect ledger device for import your wallet',
                                      iconWidget: SvgPicture.asset(
                                        'ledgerIcon'.asAssetSvg(),
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
