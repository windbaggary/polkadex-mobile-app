import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkadex/features/setup/presentation/widgets/editable_mnemonic_word_widget.dart';
import 'package:provider/provider.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/features/setup/presentation/providers/mnemonic_provider.dart';

class RestoreExistingWalletScreen extends StatefulWidget {
  @override
  _RestoreExistingWalletScreenState createState() =>
      _RestoreExistingWalletScreenState();
}

class _RestoreExistingWalletScreenState
    extends State<RestoreExistingWalletScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _entryAnimation;
  late PageController _mnemonicPageController;
  late int itemsPerPage;
  final double mnemonicListHeight = (AppConfigs.size!.height * 0.5);

  @override
  void initState() {
    itemsPerPage = ((AppConfigs.size!.height * 0.5) / 58).floor();

    _animationController = AnimationController(
      vsync: this,
      duration: AppConfigs.animDuration,
      reverseDuration: AppConfigs.animReverseDuration,
    );
    _entryAnimation = _animationController;
    _mnemonicPageController = PageController(
        initialPage: 0,
        viewportFraction:
            (AppConfigs.size!.width - 40) / AppConfigs.size!.width);

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
            backgroundColor: color1C2023,
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
                      return LayoutBuilder(
                        builder: (_, constraints) {
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
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          top: 20,
                                        ),
                                        child: Text(
                                          'Restore existing wallet',
                                          style: tsS26W600CFF,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                        ),
                                        child: Text(
                                          'Type your secret phrase to restore your existing wallet 12-24 words mnemonic seed.',
                                          style: tsS18W400CFF,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxHeight:
                                                AppConfigs.size!.height * 0.5),
                                        child: PageView.builder(
                                          controller: _mnemonicPageController,
                                          itemCount:
                                              _pageMnemonicCount(provider),
                                          itemBuilder: (context, position) {
                                            return ListView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: _listMnemonicCount(
                                                  provider, position),
                                              itemBuilder: (context, index) =>
                                                  Padding(
                                                padding: EdgeInsets.only(
                                                  bottom:
                                                      index + 1 >= itemsPerPage
                                                          ? 0
                                                          : 10,
                                                  right: 10,
                                                ),
                                                child:
                                                    EditableMnemonicWordWidget(),
                                              ),
                                            );
                                          }, // Can be null
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
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
                          label: 'Next',
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

  int _pageMnemonicCount(MnemonicProvider provider) {
    return (provider.mnemonicWords.length / itemsPerPage).ceil();
  }

  int _listMnemonicCount(
    MnemonicProvider provider,
    int pagePosition,
  ) {
    return pagePosition + 1 >=
            (provider.mnemonicWords.length / itemsPerPage).ceil()
        ? provider.mnemonicWords.length - (itemsPerPage * pagePosition)
        : itemsPerPage;
  }

  //void _onNavigateToWalletSettings(
  //    BuildContext context, MnemonicProvider provider) async {
  //  Navigator.of(context).push(PageRouteBuilder(
  //    pageBuilder: (context, animation, secondaryAnimation) {
  //      return ChangeNotifierProvider.value(
  //        value: provider,
  //        child: FadeTransition(
  //          opacity: CurvedAnimation(
  //              parent: animation, curve: Interval(0.500, 1.00)),
  //          child: WalletSettingsScreen(),
  //        ),
  //      );
  //    },
  //  ));
  //}

  /// Handling the back button animation
  Future<bool> _onPop(BuildContext context) async {
    await _animationController.reverse();
    Navigator.of(context).pop();
    return false;
  }
}
