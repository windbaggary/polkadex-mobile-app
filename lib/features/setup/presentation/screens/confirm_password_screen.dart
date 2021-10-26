import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polkadex/common/cubits/account_cubit.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/common/widgets/loading_popup.dart';
import 'package:polkadex/features/landing/screens/landing_screen.dart';
import 'package:polkadex/features/setup/presentation/widgets/warning_mnemonic_widget.dart';
import 'package:polkadex/features/setup/presentation/widgets/wallet_input_widget.dart';
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
      backgroundColor: color1C2023,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppButton(
                    label: 'Confirm',
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    enabled: _isConfirmEnabled,
                    onTap: () async {
                      final accState = context.read<AccountCubit>().state;

                      if (accState is AccountLoaded) {
                        LoadingPopup.show(
                          context: context,
                          text: 'Checking Password...',
                        );

                        final isCorrect = await context
                            .read<AccountCubit>()
                            .confirmPassword(_passwordController.text);

                        isCorrect
                            ? _onNavigateToLanding(context)
                            : _onShowIncorrectPasswordModal(context);
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

  void _onNavigateToLanding(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: CurvedAnimation(
                parent: animation, curve: Interval(0.500, 1.00)),
            child: LandingScreen(),
          );
        },
      ),
      (route) => route.isFirst,
    );
  }

  Future<bool> _onPop(BuildContext context) async {
    await _animationController.reverse();
    Navigator.of(context).pop();
    return false;
  }
}
