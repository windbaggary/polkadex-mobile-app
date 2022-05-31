import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/features/setup/presentation/widgets/warning_mnemonic_widget.dart';
import 'package:polkadex/features/setup/presentation/widgets/wallet_input_widget.dart';
import 'package:polkadex/common/market_asset/presentation/cubit/market_asset_cubit.dart';

import 'package:provider/provider.dart';

class ConfirmPasswordScreen extends StatefulWidget {
  @override
  _ConfirmPasswordScreenState createState() => _ConfirmPasswordScreenState();
}

class _ConfirmPasswordScreenState extends State<ConfirmPasswordScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _entryAnimation;

  final _passwordController = TextEditingController();

  var _isConfirmEnabled = false;

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
    return Scaffold(
      backgroundColor: AppColors.color1C2023,
      appBar: AppBar(
        title: Text(
          'Security Password',
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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Login with security password',
                                style: tsS26W600CFF,
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                'Please enter your password.',
                                style: tsS18W400CFF,
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              WalletInputWidget(
                                title: 'Repeat Password',
                                description: '',
                                controller: _passwordController,
                                obscureText: true,
                                onChanged: (password) => setState(() =>
                                    _isConfirmEnabled = password.length >= 8),
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
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    label: 'Confirm',
                    innerPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    enabled: _isConfirmEnabled,
                    onTap: () async {
                      final isCorrect = await context
                          .read<AccountCubit>()
                          .confirmPassword(_passwordController.text);
                      final accountState = context.read<AccountCubit>().state;

                      if (isCorrect && accountState is AccountLoaded) {
                        await context.read<MarketAssetCubit>().getMarkets();
                        Coordinator.goToLandingScreen(accountState.account);
                      } else {
                        _onShowIncorrectPasswordModal(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onShowIncorrectPasswordModal(BuildContext context) {
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
        title: 'Incorrect password',
        subtitle: 'Please enter again.',
      ),
    );
  }

  Future<bool> _onPop(BuildContext context) async {
    await _animationController.reverse();
    Navigator.of(context).pop();
    return false;
  }
}
