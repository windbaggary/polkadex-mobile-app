import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/common/widgets/loading_overlay.dart';
import 'package:polkadex/common/widgets/polkadex_snack_bar.dart';
import 'package:polkadex/features/landing/presentation/providers/wallet_settings_provider.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';
import 'package:polkadex/features/setup/presentation/widgets/wallet_input_widget.dart';
import 'package:provider/provider.dart';

class WalletSettingsScreen extends StatefulWidget {
  WalletSettingsScreen({required this.importedAccount});

  final AccountEntity importedAccount;

  @override
  _WalletSettingsScreenState createState() => _WalletSettingsScreenState();
}

class _WalletSettingsScreenState extends State<WalletSettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _entryAnimation;

  final _nameController = TextEditingController(text: 'Cool Wallet');
  final _passwordController = TextEditingController();
  final _passwordRepeatController = TextEditingController();

  final LoadingOverlay _loadingOverlay = LoadingOverlay();

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
    return WillPopScope(
      onWillPop: () => _onPop(),
      child: Scaffold(
        backgroundColor: AppColors.color1C2023,
        appBar: AppBar(
          title: Text(
            'Wallet Name',
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
                onTap: () => _onPop(),
              ),
            ),
          ),
          elevation: 0,
        ),
        body: BlocListener<AccountCubit, AccountState>(
          listener: (context, state) {
            if (state is AccountLoggedIn &&
                state.account.mainAddress !=
                    widget.importedAccount.mainAddress) {
              Coordinator.goBackToLandingScreen();
            }

            if (state is AccountLoggedInMainAccountFetchError) {
              PolkadexSnackBar.show(
                context: context,
                text: state.errorMessage,
              );
            }

            state is AccountLoading
                ? _loadingOverlay.show(
                    context: context, text: 'Loading wallet...')
                : _loadingOverlay.hide();
          },
          child: Consumer<WalletSettingsProvider>(
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
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16),
                                      child: Text(
                                        'Wallet Settings',
                                        style: tsS26W600CFF,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 14),
                                      child: Text(
                                        'Set a wallet name for your wallet.',
                                        style: tsS18W400CFF,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Spacer(),
                        AppButton(
                          enabled: settingProvider.isNextEnabled &&
                              _nameController.text.isNotEmpty &&
                              _passwordController.text ==
                                  _passwordRepeatController.text,
                          label: 'Confirm',
                          onTap: () async => await context
                              .read<AccountCubit>()
                              .addWalletToAccount(
                                proxyAddress:
                                    widget.importedAccount.proxyAddress,
                              ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  Future<bool> _onPop() async {
    if (_loadingOverlay.isActive) {
      return false;
    }

    await _animationController.reverse();
    Navigator.of(context).pop();
    return false;
  }
}
