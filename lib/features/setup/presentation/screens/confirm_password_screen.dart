import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/common/widgets/loading_overlay.dart';
import 'package:polkadex/features/setup/presentation/widgets/wallet_input_widget.dart';

class ConfirmPasswordScreen extends StatefulWidget {
  @override
  _ConfirmPasswordScreenState createState() => _ConfirmPasswordScreenState();
}

class _ConfirmPasswordScreenState extends State<ConfirmPasswordScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _entryAnimation;

  final _passwordController = TextEditingController();

  final LoadingOverlay _loadingOverlay = LoadingOverlay();

  final ValueNotifier<bool> _isConfirmEnabled = ValueNotifier<bool>(false);

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
      body: BlocListener<AccountCubit, AccountState>(
        listener: (_, state) => state is AccountLoading
            ? _loadingOverlay.show(context: context, text: 'Signing in...')
            : _loadingOverlay.hide(),
        child: CustomScrollView(
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
                                  onChanged: (password) => _isConfirmEnabled
                                      .value = password.length >= 8,
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: _isConfirmEnabled,
                      builder: (context, isConfirmEnabled, _) => AppButton(
                        label: 'Confirm',
                        innerPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        enabled: isConfirmEnabled,
                        onTap: () => _onTapConfirm(),
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
  }

  Future<void> _onTapConfirm() async {
    await context.read<AccountCubit>().signInWithLocalAcc(
          password: _passwordController.text,
        );
  }

  Future<bool> _onPop(BuildContext context) async {
    await _animationController.reverse();
    Navigator.of(context).pop();
    return false;
  }
}
