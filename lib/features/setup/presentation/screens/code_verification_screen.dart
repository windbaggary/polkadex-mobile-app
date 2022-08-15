import 'package:flutter/material.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/features/setup/presentation/widgets/wallet_input_widget.dart';

class CodeVerificationScreen extends StatefulWidget {
  @override
  _CodeVerificationScreenState createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen>
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
    return WillPopScope(
      onWillPop: () => _onPop(context),
      child: Scaffold(
        backgroundColor: AppColors.color1C2023,
        appBar: AppBar(
          title: Text(
            'Email Verification',
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
                            padding: const EdgeInsets.only(
                              left: 20,
                              top: 20,
                              right: 20,
                              bottom: 32,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Text(
                                    'Please check your email',
                                    style: tsS26W600CFF,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: Text(
                                    'We have sent a code to your email:\nemail@polkadex.trade',
                                    style: tsS18W400CFF,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: WalletInputWidget(
                                        title: 'Password',
                                        description: 'Set password',
                                        controller: null,
                                        obscureText: true,
                                        onChanged: (_) {},
                                      ),
                                    ),
                                  ],
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppButton(
                      enabled: false,
                      label: 'Verify Account',
                      onTap: () => {},
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

  //void _onNextTap(
  //  List<String> mnemonicWords,
  //  String password,
  //  String name,
  //  bool onlyBiometric,
  //) async {
  //  final accountCubit = context.read<AccountCubit>();
  //  final isBiometricAvailable =
  //      dependency.get<bool>(instanceName: 'isBiometricAvailable');
//
  //  FocusScope.of(context).unfocus();
//
  //  if (isBiometricAvailable) {
  //    final hasImported = await accountCubit.savePassword(
  //      password,
  //    );
//
  //    if (!hasImported) {
  //      return;
  //    }
  //  }
//
  //  LoadingPopup.show(
  //    context: context,
  //    text: 'We are almost there...',
  //  );
//
  //  await accountCubit.saveAccount(
  //    mnemonicWords,
  //    password,
  //    name,
  //    onlyBiometric,
  //    isBiometricAvailable,
  //  );
  //  final accountState = accountCubit.state;
//
  //  if (accountState is AccountLoaded) {
  //    await context.read<MarketAssetCubit>().getMarkets();
  //    Coordinator.goToLandingScreen(accountState.account);
  //  } else if (accountState is AccountNotLoaded) {
  //    _onShowRegisterErrorModal(accountState.errorMessage);
  //  }
  //}

  //void _onShowRegisterErrorModal(String? errorMessage) {
  //  Navigator.of(context).pop();
  //  showModalBottomSheet(
  //    context: context,
  //    isScrollControlled: true,
  //    shape: RoundedRectangleBorder(
  //      borderRadius: BorderRadius.vertical(
  //        top: Radius.circular(30),
  //      ),
  //    ),
  //    builder: (_) => WarningModalWidget(
  //      title: 'Account register error',
  //      subtitle: errorMessage,
  //    ),
  //  );
  //}

  Future<bool> _onPop(BuildContext context) async {
    await _animationController.reverse();
    Navigator.of(context).pop();
    return false;
  }
}
