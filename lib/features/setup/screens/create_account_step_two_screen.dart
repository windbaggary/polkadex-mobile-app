import 'package:flutter/material.dart';
import 'package:polkadex/configs/app_config.dart';
import 'package:polkadex/features/setup/screens/create_account_screen.dart';
import 'package:polkadex/features/setup/screens/login_scan_screen.dart';
import 'package:polkadex/utils/colors.dart';
import 'package:polkadex/utils/enums.dart';
import 'package:polkadex/utils/styles.dart';
import 'package:polkadex/widgets/app_buttons.dart';
import 'package:polkadex/widgets/app_slider_dots.dart';
import 'package:polkadex/widgets/app_step_progress_widget.dart';
import 'package:polkadex/utils/extensions.dart';

/// The create account guide step 2
///
/// XD_PAGE: 13
/// XD_PAGE: 14
/// XD_PAGE: 15
class CreateAccountStepTwoScreen extends StatefulWidget {
  @override
  _CreateAccountStepTwoScreenState createState() =>
      _CreateAccountStepTwoScreenState();
}

class _CreateAccountStepTwoScreenState extends State<CreateAccountStepTwoScreen>
    with SingleTickerProviderStateMixin {
  late ValueNotifier<EnumCreateSliderSteps> _sliderStepNotifier;
  late AnimationController _entryAnimController;

  @override
  void initState() {
    _sliderStepNotifier =
        ValueNotifier<EnumCreateSliderSteps>(EnumCreateSliderSteps.step1);
    _entryAnimController = AnimationController(
      vsync: this,
      duration: AppConfigs.animDuration,
      reverseDuration: AppConfigs.animReverseDuration,
    );
    super.initState();
    Future.microtask(() => _entryAnimController.forward());
  }

  @override
  void dispose() {
    _entryAnimController.dispose();
    _sliderStepNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ThisInheritedWidget(
      sliderNotifier: _sliderStepNotifier,
      child: Scaffold(
        backgroundColor: color2E303C,
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     _animationController.reset();
        //     _animationController.forward().orCancel;
        //   },
        // ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Hero(
                    tag: CreateAccountScreen.tagBackButton,
                    child: _buildBackButton(context)),
                Hero(
                  tag: CreateAccountScreen.tagHeading,
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      "So, let's create",
                      style: tsS23W500CFF,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    MediaQuery.of(context).size.height * 0.055,
                    26,
                    26,
                  ),
                  child: ValueListenableBuilder<EnumCreateSliderSteps>(
                    valueListenable: _sliderStepNotifier,
                    builder: (context, currentStep, child) {
                      double progress = 1 / 3;

                      switch (currentStep) {
                        case EnumCreateSliderSteps.step1:
                          progress = 1 / 3;
                          break;
                        case EnumCreateSliderSteps.step2:
                          progress = 2 / 3;
                          break;
                        case EnumCreateSliderSteps.step3:
                          progress = 1.0;
                          break;
                      }

                      return FadeTransition(
                        opacity: _entryAnimController
                            .drive<double>(Tween<double>(begin: 0.0, end: 1.0)),
                        child: AppStepProgressWidget(
                          currentStep: '2',
                          totalSteps: '2',
                          progress: progress,
                        ),
                      );
                    },
                  ),
                ),
                _ThisContainerCard(),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 36.0,
                    top: 36,
                    left: 44,
                    right: 26,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ValueListenableBuilder<EnumCreateSliderSteps>(
                        valueListenable: _sliderStepNotifier,
                        builder: (context, step, child) => AppSliderDots(
                          length: EnumCreateSliderSteps.values.length,
                          selectedIndex:
                              EnumCreateSliderSteps.values.indexOf(step),
                        ),
                      ),
                      ValueListenableBuilder<EnumCreateSliderSteps>(
                        valueListenable: _sliderStepNotifier,
                        builder: (context, currentStep, child) {
                          String label = "Next";
                          bool isFinished =
                              currentStep == EnumCreateSliderSteps.values.last;
                          if (isFinished) {
                            label = "Finished";
                          }
                          return AppButton(
                            label: label,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 41,
                            ),
                            onTap: () {
                              if (isFinished) {
                                _onNavigateToLoginScanScreen(context);
                              } else {
                                final int currentIndex = EnumCreateSliderSteps
                                    .values
                                    .indexOf(currentStep);
                                _sliderStepNotifier.value =
                                    EnumCreateSliderSteps
                                        .values[currentIndex + 1];
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// The back button for the appbar section
  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AppBackButton(
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  /// Callback listener to navigate to login screen
  void _onNavigateToLoginScanScreen(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: AppConfigs.animDuration,
        reverseTransitionDuration: AppConfigs.animReverseDuration,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: LoginScanScreen(),
          );
        },
      ),
    );
  }
}

/// The top card to choose chrome or firefox
class _ThisContainerCard extends StatelessWidget {
  Widget _getCurrentStepWidget(EnumCreateSliderSteps currentStep) {
    switch (currentStep) {
      case EnumCreateSliderSteps.step1:
        return _ThisFirstSliderWidget();
      case EnumCreateSliderSteps.step2:
        return _ThisSecondSliderWidget();
      case EnumCreateSliderSteps.step3:
        return _ThisThirdSliderWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color1C2023,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 34, 16, 50),
      child: ValueListenableBuilder<EnumCreateSliderSteps>(
          valueListenable: _ThisInheritedWidget.of(context)?.sliderNotifier ??
              ValueNotifier<EnumCreateSliderSteps>(EnumCreateSliderSteps.step1),
          builder: (context, currentStep, child) => AnimatedSwitcher(
              duration: AppConfigs.animDuration,
              reverseDuration: AppConfigs.animReverseDuration,
              layoutBuilder: (currentChild, previousChildren) {
                return currentChild!;
              },
              child: _getCurrentStepWidget(currentStep))),
    );
  }
}

class _ThisFirstSliderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Create or import a new wallet',
          style: tsS23W600CFF,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 26, bottom: 13),
          child: Text(
            '1. Open polkadot{.js} extension',
            style: tsS18W500CFF,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 40, bottom: 27),
          child: Image.asset(
            'polkadotjs-screen1.png'.asAssetImg(),
            fit: BoxFit.fitWidth,
          ),
        ),
        RichText(
          text: TextSpan(
            style: tsS15W400CFF.copyWith(height: 1.4),
            children: <TextSpan>[
              TextSpan(
                text: 'Open  ',
                style: TextStyle(fontFamily: 'WorkSans'),
              ),
              TextSpan(
                text: 'Your browser',
                style: tsS15W400CFF.copyWith(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                    ' and locate the extensions, then select polkadot{.js} extension, then click on the icon +.',
                style: TextStyle(fontFamily: 'WorkSans'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ThisSecondSliderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Create or import a new wallet',
          style: tsS23W600CFF,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 26, bottom: 13),
          child: Text(
            '2. Create an account',
            style: tsS18W500CFF,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 40, bottom: 27),
          child: Image.asset(
            'polkadotjs-screen2.png'.asAssetImg(),
            fit: BoxFit.fitWidth,
          ),
        ),
        RichText(
          text: TextSpan(
            style: tsS15W400CFF.copyWith(height: 1.4),
            children: <TextSpan>[
              TextSpan(
                text:
                    'Save your 12-word Mnemonic Seed and don’t share it with anyone.',
                style: TextStyle(fontFamily: 'WorkSans'),
              ),
              // TextSpan(
              //   text: 'Your browser',
              //   style: tsS16W400CFF.copyWith(fontWeight: FontWeight.bold),
              // ),
              // TextSpan(
              //   text:
              //       ' and locate the extensions, then select polkadot{.js} extension, then click on the icon +.',
              // ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ThisThirdSliderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Create or import a new wallet',
          style: tsS23W600CFF,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 26, bottom: 13),
          child: Text(
            '2. Enter your password',
            style: tsS18W500CFF,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 40, bottom: 27),
          child: Image.asset(
            'polkadotjs-screen3.png'.asAssetImg(),
            fit: BoxFit.fitWidth,
          ),
        ),
        RichText(
          text: TextSpan(
            style: tsS15W400CFF.copyWith(height: 1.4),
            children: <TextSpan>[
              TextSpan(
                text:
                    'Enter a descriptive name for your account and a secure password.',
                style: TextStyle(fontFamily: 'WorkSans'),
              ),
              // TextSpan(
              //   text: 'Your browser',
              //   style: tsS16W400CFF.copyWith(fontWeight: FontWeight.bold),
              // ),
              // TextSpan(
              //   text:
              //       ' and locate the extensions, then select polkadot{.js} extension, then click on the icon +.',
              // ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ThisInheritedWidget extends InheritedWidget {
  final ValueNotifier<EnumCreateSliderSteps> sliderNotifier;

  _ThisInheritedWidget({
    required this.sliderNotifier,
    required Widget child,
  }) : super(child: child);

  static _ThisInheritedWidget? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ThisInheritedWidget>();

  @override
  bool updateShouldNotify(covariant _ThisInheritedWidget oldWidget) {
    return oldWidget.sliderNotifier != sliderNotifier;
  }
}
