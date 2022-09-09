import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/market_asset/presentation/cubit/market_asset_cubit.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/common/widgets/loading_overlay.dart';
import 'package:polkadex/common/widgets/polkadex_snack_bar.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';

class CodeVerificationScreen extends StatefulWidget {
  CodeVerificationScreen({
    required this.email,
    required this.password,
    required this.useBiometric,
  });

  final String email;
  final String password;
  final bool useBiometric;

  @override
  _CodeVerificationScreenState createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _entryAnimation;

  final ValueNotifier<bool> _isVerifyEnabled = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isResendVisible = ValueNotifier<bool>(false);

  final TextEditingController _pinCodeController = TextEditingController();

  final LoadingOverlay _loadingOverlay = LoadingOverlay();

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: AppConfigs.animDuration,
      reverseDuration: AppConfigs.animReverseDuration,
    );
    _entryAnimation = _animationController;

    Future.microtask(() => _animationController.forward());

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Timer(
        Duration(
          minutes: 1,
        ),
        () => _isResendVisible.value = true,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _isVerifyEnabled.dispose();
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
        body: BlocListener<AccountCubit, AccountState>(
          listener: (_, state) {
            if (state is AccountLoggedIn) {
              Coordinator.goToLandingScreen(state.account);
            }

            if (state is AccountConfirmSignUpError) {
              PolkadexSnackBar.show(
                context: context,
                text: state.errorMessage,
              );
            }

            if (state is AccountCodeResent) {
              _isResendVisible.value = false;

              Timer(
                Duration(
                  minutes: 1,
                ),
                () => _isResendVisible.value = true,
              );
            }

            if (state is AccountResendCodeError) {
              PolkadexSnackBar.show(
                context: context,
                text: state.errorMessage,
              );
            }

            state is AccountLoading
                ? _loadingOverlay.show(context: context, text: 'Signing up...')
                : _loadingOverlay.hide();
          },
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
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
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            final codeLength = 6;
                                            final pinCodeBoxDimension =
                                                constraints.maxWidth /
                                                        codeLength -
                                                    16;

                                            return PinCodeTextField(
                                              appContext: context,
                                              controller: _pinCodeController,
                                              pastedTextStyle: TextStyle(
                                                color: Colors.green.shade600,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              length: codeLength,
                                              animationType: AnimationType.fade,
                                              pinTheme: PinTheme(
                                                fieldWidth: pinCodeBoxDimension,
                                                fieldHeight:
                                                    pinCodeBoxDimension,
                                                shape: PinCodeFieldShape.box,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                activeFillColor: Colors.white,
                                                activeColor: Colors.white,
                                                selectedColor: Colors.white,
                                                selectedFillColor: Colors.white,
                                                inactiveFillColor:
                                                    AppColors.color1C1C26,
                                                inactiveColor:
                                                    AppColors.color1C1C26,
                                              ),
                                              animationDuration: const Duration(
                                                  milliseconds: 300),
                                              enableActiveFill: true,
                                              keyboardType:
                                                  TextInputType.number,
                                              boxShadows: const [
                                                BoxShadow(
                                                  offset: Offset(0, 1),
                                                  color: Colors.black12,
                                                  blurRadius: 10,
                                                )
                                              ],
                                              onCompleted: (code) =>
                                                  _isVerifyEnabled.value = true,
                                              onChanged: (code) =>
                                                  _isVerifyEnabled.value &&
                                                          code.length <
                                                              codeLength
                                                      ? _isVerifyEnabled.value =
                                                          false
                                                      : null,
                                            );
                                          },
                                        ),
                                      ),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: _isResendVisible,
                                        builder: (context, isResendVisible,
                                                _) =>
                                            isResendVisible
                                                ? Padding(
                                                    padding: EdgeInsets.zero,
                                                    child: RichText(
                                                      text: TextSpan(
                                                        style: tsS14W400CFF,
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  'Didn\'t receive the code? '),
                                                          TextSpan(
                                                            text: 'Resend',
                                                            style: tsS14W400CFF
                                                                .copyWith(
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              color: AppColors
                                                                  .colorE6007A,
                                                            ),
                                                            recognizer: TapGestureRecognizer()
                                                              ..onTap = () => context
                                                                  .read<
                                                                      AccountCubit>()
                                                                  .resendCode(
                                                                      email: widget
                                                                          .email),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                      )
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
                      ValueListenableBuilder<bool>(
                        valueListenable: _isVerifyEnabled,
                        builder: (context, isVerifyEnabled, _) => AppButton(
                          enabled: isVerifyEnabled,
                          label: 'Verify Account',
                          onTap: () => _onVerifyPressed(context),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onVerifyPressed(
    BuildContext context,
  ) async {
    final accountCubit = context.read<AccountCubit>();
    final marketsCubit = context.read<MarketAssetCubit>();

    FocusScope.of(context).unfocus();

    if (widget.useBiometric) {
      final isPasswordSaved = await accountCubit.savePassword(widget.password);

      if (!isPasswordSaved) {
        return;
      }
    }

    if (marketsCubit.state is! MarketAssetLoaded) {
      await marketsCubit.getMarkets();
    }

    await accountCubit.confirmSignUp(
        email: widget.email,
        password: widget.password,
        code: _pinCodeController.text,
        useBiometric: widget.useBiometric);
  }

  Future<bool> _onPop(BuildContext context) async {
    await _animationController.reverse();
    Navigator.of(context).pop();
    return false;
  }
}
