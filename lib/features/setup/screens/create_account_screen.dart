import 'package:flutter/material.dart';
import 'package:polkadex/configs/app_config.dart';
import 'package:polkadex/features/setup/screens/create_account_step_two_screen.dart';
import 'package:polkadex/utils/colors.dart';
import 'package:polkadex/utils/styles.dart';
import 'package:polkadex/widgets/app_buttons.dart';
import 'package:polkadex/utils/extensions.dart';
import 'package:polkadex/widgets/app_step_progress_widget.dart';

/// The screen to guide account creation
/// XD_PAGE: 4
/// XD_PAGE: 5
class CreateAccountScreen extends StatefulWidget {
  static const String tagHeading = "tag_heading";
  static const String tagBackButton = "tag_back_button";

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen>
    with TickerProviderStateMixin {
  final _isChromeExpandedNotifier = ValueNotifier<bool>(false);

  final _isFirefoxExpandedNotifier = ValueNotifier<bool>(false);

  AnimationController _animationController;
  AnimationController _entryCardExpandAnimController;
  Animation<Offset> _nextButtonAnimation;
  Animation<double> _opacityAnimation;
  Animation<Offset> _cardAnimation;
  Animation<Offset> _headingAnimation;
  Animation<Offset> _backButtonAnimation;

  /// This method will be invoked when user click on chrome to expand
  void _onChromeTapExpanded(BuildContext context) {
    _isChromeExpandedNotifier.value = true;
    _isFirefoxExpandedNotifier.value = false;
  }

  /// This method will be invoked when user click on firefox to expand
  void _onFirefoxTapExpanded(BuildContext context) {
    _isFirefoxExpandedNotifier.value = true;
    _isChromeExpandedNotifier.value = false;
  }

  /// This method will be invoked when user click on chrome to expand
  void _onChromeTapHide(BuildContext context) {
    _isChromeExpandedNotifier.value = false;
    _isFirefoxExpandedNotifier.value = false;
  }

  /// This method will be invoked when user click on firefox to expand
  void _onFirefoxTapHide(BuildContext context) {
    _isChromeExpandedNotifier.value = false;
    _isFirefoxExpandedNotifier.value = false;
  }

  /// This method will be called when user click on Next button
  void _onNextTap(BuildContext context) async {
    bool shouldDelay = (_isChromeExpandedNotifier.value
        // Uncomment this after implementation of firefox expanded card
        // || _isFirefoxExpandedNotifier.value
        );
    _onChromeTapHide(context);
    _onFirefoxTapHide(context);
    if (shouldDelay) {
      await Future.delayed(AppConfigs.animReverseDuration);
    }
    await _entryCardExpandAnimController.reverse();
    Navigator.of(context)
        .push(PageRouteBuilder(
          transitionDuration: AppConfigs.animDuration,
          reverseTransitionDuration: AppConfigs.animReverseDuration,
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
                opacity: CurvedAnimation(
                    parent: animation, curve: Interval(0.500, 1.00)),
                child: CreateAccountStepTwoScreen());
          },
        ))
        .then((value) => _entryCardExpandAnimController.forward());
  }

  /// Initialise all the animations
  /// Must initialise the [_animationController] before calling this
  void _initAnimations() {
    assert(_animationController != null, '''
   Must initialise the [_animationController] before calling this
  ''');
    assert(_entryCardExpandAnimController != null, '''
   Must initialise the [_entryCardExpandAnimController] before calling this
  ''');

    _opacityAnimation = CurvedAnimation(
        parent: _entryCardExpandAnimController, curve: Interval(0.00, 1.00));
    _backButtonAnimation =
        Tween<Offset>(begin: Offset(-1.5, 0.0), end: Offset(0.0, 0.0))
            .animate(_animationController);
    _headingAnimation =
        Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
            .animate(_animationController);
    _nextButtonAnimation =
        Tween<Offset>(begin: Offset(0.0, 1.5), end: Offset(0.0, 0.0))
            .animate(_animationController);
    _cardAnimation =
        Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))
            .animate(_entryCardExpandAnimController);
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: AppConfigs.animDuration,
      reverseDuration: AppConfigs.animReverseDuration,
    );

    _entryCardExpandAnimController = AnimationController(
      vsync: this,
      duration: AppConfigs.animDuration,
      reverseDuration: AppConfigs.animReverseDuration,
    );

    _initAnimations();

    super.initState();

    Future.microtask(() {
      _animationController.forward().orCancel;
      _entryCardExpandAnimController
          .forward()
          .orCancel
          .then((value) => _isChromeExpandedNotifier.value = true);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _entryCardExpandAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ThisInheritedWidget(
      isChromeExpandedNotifier: _isChromeExpandedNotifier,
      isFirefoxExpandedNotifier: _isFirefoxExpandedNotifier,
      onChromeTapExpanded: () => _onChromeTapExpanded(context),
      onFirefoxTapExpanded: () => _onFirefoxTapExpanded(context),
      onChromeTapHide: () => _onChromeTapHide(context),
      onFirefoxTapHide: () => _onFirefoxTapHide(context),
      onNextTap: () => _onNextTap(context),
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
                SlideTransition(
                  position: _headingAnimation,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: Hero(
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
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    MediaQuery.of(context).size.height * 0.055,
                    26,
                    26,
                  ),
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: AppStepProgressWidget(
                      currentStep: '1',
                      totalSteps: '2',
                      progress: 0.0,
                      animation: _animationController,
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: _isChromeExpandedNotifier,
                      builder: (context, isExpanded, child) =>
                          _ThisBrowserExpandCard(isExpanded: isExpanded),
                    ),
                    SlideTransition(
                        position: _cardAnimation,
                        child: _ThisTopBrowserSelectionCard()),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 36.0),
                  child: Center(
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _nextButtonAnimation,
                        child: AppButton(
                          label: "Next",
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 41,
                          ),
                          onTap: () => _onNextTap(context),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// The back button for the screen handles the back navigation
  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SlideTransition(
          position: _backButtonAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: AppBackButton(
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// The expand card on clicking on brower in [_ThisTopBrowserSelectionCard]
class _ThisBrowserExpandCard extends StatelessWidget {
  final bool isExpanded;
  const _ThisBrowserExpandCard({Key key, this.isExpanded = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: AppConfigs.animDuration,
      opacity: isExpanded ? 1.0 : 0.0,
      child: AnimatedContainer(
        duration: AppConfigs.animDuration,
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: color1C2023.withOpacity(0.50),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40),
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.symmetric(horizontal: 12)
            .add(EdgeInsets.only(bottom: isExpanded ? 24.0 : 260.0)),
        padding:
            EdgeInsets.only(left: 24, bottom: 30, top: isExpanded ? 280 : 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'polkadotjs_chromium.png'.asAssetImg(),
              fit: BoxFit.fitWidth,
            ),
            SizedBox(height: 24),
            RichText(
              text: TextSpan(
                  text: 'Open ',
                  style: tsS15W400CFF.copyWith(
                    height: 1.4,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Chrome Web Store',
                      style: tsS15W700CFF,
                    ),
                    TextSpan(
                      text: ' your computer, search and install ',
                      style: TextStyle(fontFamily: 'WorkSans'),
                    ),
                    TextSpan(
                      text: 'polkadot{.js}',
                      style: tsS15W700CFF,
                    ),
                    TextSpan(
                      text: ' extension, remember always check the author ',
                      style: TextStyle(fontFamily: 'WorkSans'),
                    ),
                    TextSpan(
                      text: 'polkadot{.js}',
                      style: tsS15W700CFF,
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

/// The top card to choose chrome or firefox
class _ThisTopBrowserSelectionCard extends StatelessWidget {
  const _ThisTopBrowserSelectionCard({
    Key key,
  }) : super(key: key);

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Open your browser in your computer',
            style: tsS23W600CFF,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 20),
            child: Text(
              'What’s browser are you using?',
              style: tsS18W500CFF,
            ),
          ),
          Row(
            children: [
              ValueListenableBuilder<bool>(
                valueListenable:
                    _ThisInheritedWidget.of(context).isChromeExpandedNotifier,
                builder: (context, value, child) => _ChromeOrFirefoxButton(
                  imgIcon: 'chromium.png',
                  label: 'Chrome/Opera/Edge',
                  isSelected: value,
                  onTap: () {
                    if (value) {
                      _ThisInheritedWidget.of(context).onChromeTapHide();
                    } else {
                      _ThisInheritedWidget.of(context).onChromeTapExpanded();
                    }
                  },
                ),
              ),
              SizedBox(width: 8),
              Flexible(
                fit: FlexFit.tight,
                child: ValueListenableBuilder<bool>(
                  valueListenable: _ThisInheritedWidget.of(context)
                      .isFirefoxExpandedNotifier,
                  builder: (context, value, child) => _ChromeOrFirefoxButton(
                    imgIcon: 'firefox.png',
                    label: 'Firefox',
                    isSelected: false,
                    isApplyBlendMode: true,
                    onTap: () {
                      if (value) {
                        _ThisInheritedWidget.of(context).onFirefoxTapHide();
                      } else {
                        _ThisInheritedWidget.of(context).onFirefoxTapExpanded();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The button on the [_ThisTopBrowserSelectionCard] for chrome or firefox
class _ChromeOrFirefoxButton extends StatelessWidget {
  final String label;
  final String imgIcon;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isApplyBlendMode;
  const _ChromeOrFirefoxButton({
    Key key,
    @required this.label,
    @required this.imgIcon,
    this.onTap,
    this.isSelected = false,
    this.isApplyBlendMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConfigs.animDurationSmall,
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: (isSelected) ? colorE6007A : color2E303C,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02, vertical: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imgIcon.asAssetImg(),
              width: 32,
              height: 32,
              fit: BoxFit.contain,
              color: isApplyBlendMode ? color2E303C : null,
              colorBlendMode: BlendMode.color,
            ),
            SizedBox(width: 8),
            Text(
              label ?? "",
              style: tsS15W500CFF,
            ),
          ],
        ),
      ),
    );
  }
}

/// The inherited widget for the main screen in this file
class _ThisInheritedWidget extends InheritedWidget {
  /// This method will be involked to expand the chrome
  final VoidCallback onChromeTapExpanded;

  /// This method will be involked to expand the fire
  final VoidCallback onFirefoxTapExpanded;

  /// This method will be involked to hide the chrome
  final VoidCallback onChromeTapHide;

  /// This method will be involked to hide the Firefox
  final VoidCallback onFirefoxTapHide;

  /// The notifier for the chrome click events
  final ValueNotifier<bool> isChromeExpandedNotifier;

  /// The notifier for the firefox click events
  final ValueNotifier<bool> isFirefoxExpandedNotifier;

  /// This event will be triggered when tap on bottom next button
  final VoidCallback onNextTap;

  _ThisInheritedWidget({
    @required this.onChromeTapExpanded,
    @required this.onFirefoxTapExpanded,
    @required this.onChromeTapHide,
    @required this.onFirefoxTapHide,
    @required this.isChromeExpandedNotifier,
    @required this.isFirefoxExpandedNotifier,
    @required this.onNextTap,
    @required Widget child,
    Key key,
  }) : super(child: child, key: key);

  @override
  bool updateShouldNotify(covariant _ThisInheritedWidget oldWidget) {
    return oldWidget.onChromeTapExpanded != onChromeTapExpanded ||
        oldWidget.onFirefoxTapExpanded != onFirefoxTapExpanded ||
        oldWidget.onChromeTapHide != onChromeTapHide ||
        oldWidget.onFirefoxTapHide != onFirefoxTapHide ||
        oldWidget.isChromeExpandedNotifier != isChromeExpandedNotifier ||
        oldWidget.isFirefoxExpandedNotifier != isFirefoxExpandedNotifier ||
        oldWidget.onNextTap != onNextTap;
  }

  static _ThisInheritedWidget of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ThisInheritedWidget>();
}
