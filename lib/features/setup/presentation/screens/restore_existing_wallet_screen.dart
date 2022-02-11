import 'package:flutter/material.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/common/widgets/loading_popup.dart';
import 'package:polkadex/features/setup/presentation/widgets/warning_mnemonic_widget.dart';
import 'package:polkadex/features/setup/presentation/widgets/suggestions_widget.dart';
import 'package:provider/provider.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/features/setup/presentation/widgets/mnemonic_pages_input_widget.dart';
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

  final List<TextEditingController> _editControllers = List.generate(
    24,
    (_) => TextEditingController(),
  );
  final int _itemsPerPage = 6;
  final Duration _transitionDuration = const Duration(milliseconds: 300);
  final Cubic _pageTransition = Curves.ease;
  final ValueNotifier<int> _currentPage = ValueNotifier<int>(0);

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: AppConfigs.animDuration,
      reverseDuration: AppConfigs.animReverseDuration,
    );
    _entryAnimation = _animationController;
    _mnemonicPageController = PageController(
        initialPage: 0,
        viewportFraction: (AppConfigs.size.width - 40) / AppConfigs.size.width);

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
                      return LayoutBuilder(
                        builder: (_, constraints) {
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
                                      MnemonicPagesInputWidget(
                                          pageController:
                                              _mnemonicPageController,
                                          currentPage: _currentPage,
                                          itemsPerPage: _itemsPerPage,
                                          pageCount: _pageMnemonicCount(
                                              context, provider),
                                          controllers: _editControllers),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 42,
                                          top: 21,
                                          right: 42,
                                          bottom: 38,
                                        ),
                                        child: SuggestionsWidget(
                                          suggestions:
                                              provider.suggestionsMnemonicWords,
                                          controllers: _editControllers,
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
                        child: ValueListenableBuilder(
                          valueListenable: _currentPage,
                          builder: (BuildContext context, int value, _) {
                            return Row(
                              mainAxisAlignment: value > 0
                                  ? MainAxisAlignment.spaceBetween
                                  : MainAxisAlignment.center,
                              children: [
                                if (value > 0)
                                  AppButton(
                                    label: 'Previous',
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 16,
                                    ),
                                    onTap: () {
                                      provider.clearSuggestions();
                                      if (_isInteger(
                                          _mnemonicPageController.page!)) {
                                        FocusScope.of(context).unfocus();
                                        _mnemonicPageController.previousPage(
                                          duration: _transitionDuration,
                                          curve: _pageTransition,
                                        );
                                      }
                                    },
                                  ),
                                AppButton(
                                  label: 'Next',
                                  enabled: _isNextEnabled(context, provider),
                                  onTap: () {
                                    provider.clearSuggestions();
                                    if (_isInteger(
                                        _mnemonicPageController.page!)) {
                                      FocusScope.of(context).unfocus();
                                      _evalNextButtonAction(context, provider);
                                    }
                                  },
                                ),
                              ],
                            );
                          },
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

  void _evalNextButtonAction(
      BuildContext context, MnemonicProvider provider) async {
    if (_isLastPage(context, provider)) {
      LoadingPopup.show(
        context: context,
        text: 'We are almost there...',
      );
      final isMnemonicValid = await provider.checkMnemonicValid();
      Navigator.of(context).pop();

      isMnemonicValid
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
            );
    } else {
      _mnemonicPageController.nextPage(
        duration: _transitionDuration,
        curve: _pageTransition,
      );
    }
  }

  bool _isNextEnabled(BuildContext context, MnemonicProvider provider) {
    return !_isLastPage(context, provider) ||
        (_isLastPage(context, provider) && provider.isMnemonicComplete);
  }

  bool _isLastPage(BuildContext context, MnemonicProvider provider) {
    return _currentPage.value + 1 >= _pageMnemonicCount(context, provider);
  }

  int _pageMnemonicCount(BuildContext context, MnemonicProvider provider) {
    return (provider.mnemonicWords.length / _itemsPerPage).ceil();
  }

  bool _isInteger(double value) {
    return value % 1 == 0;
  }

  /// Handling the back button animation
  Future<bool> _onPop(BuildContext context) async {
    await _animationController.reverse();
    Navigator.of(context).pop();
    return false;
  }
}
