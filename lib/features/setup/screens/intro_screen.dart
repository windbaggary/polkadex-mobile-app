import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/configs/app_config.dart';
import 'package:polkadex/features/setup/screens/terms_screen.dart';
import 'package:polkadex/utils/colors.dart';
import 'package:polkadex/utils/extensions.dart';
import 'package:polkadex/utils/styles.dart';
import 'package:polkadex/widgets/app_slide_button.dart';
import 'package:polkadex/widgets/app_slider_dots.dart';

/// The dummy data for the screen
///
/// Delete the class on API integration
class _DummyData {
  static final sliderList = List.generate(
    3,
    (index) =>
        "A fully decentralized, peer-peer, orderbook based cryptocurrency exchange",
  );

  static final sliderImgList = <String>[
    'slider_img_1.png'.asAssetImg(),
    'slider_img_2.png'.asAssetImg(),
    'slider_img_3.png'.asAssetImg(),
  ];
}

/// This screen will be displayed on the first app opened.
///
/// In XD page 2 - Start Screen
/// XD_PAGE: 2
///

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  final _keyPageView = GlobalKey<__ThisPageViewState>();

  ValueNotifier<int> _pageviewIndexNotifier;

  @override
  void initState() {
    _pageviewIndexNotifier = ValueNotifier<int>(0);
    super.initState();
  }

  @override
  void dispose() {
    _pageviewIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _animationController.reset();
      //     _animationController.forward().orCancel;
      //   },
      // ),
      backgroundColor: color1C2023,
      body: Stack(
        children: [
          // // The background top image
          // Positioned(
          //   left: 0,
          //   top: 0,
          //   right: 0,
          //   height: MediaQuery.of(context).size.height * 0.45,
          //   child: Image.asset(
          //     'home_bg.png'.asAssetImg(),
          //     fit: BoxFit.fill,
          //   ),
          // ),

          // The content of the screen
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _ThisPageView(
                      key: _keyPageView,
                      length: _DummyData.sliderList.length,
                      pageviewIndexNotifier: _pageviewIndexNotifier),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 30, bottom: 40),
                  child: ValueListenableBuilder<int>(
                    valueListenable: _pageviewIndexNotifier,
                    builder: (context, pageIndex, child) => AppSliderDots(
                      length: _DummyData.sliderList.length,
                      selectedIndex: pageIndex,
                      onDotSelected: (dotSelectedIndex) {
                        _keyPageView.currentState.animateTo(dotSelectedIndex);
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      height: 60,
                      child: _ThisLoginButton(
                        onTap: () => _onNavigateToTerms(context),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24.0,
                    right: 24,
                    top: 22,
                    bottom: 24,
                  ),
                  child: Text(
                    'The following interface shows simulated trades from one of the largest centralized exchanges',
                    style: tsS16W400CABB2BC,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          // The polkadex logo
          Positioned(
            top: 36 + MediaQuery.of(context).padding.top,
            left: 26,
            height: 36,
            child: Image.asset(
              'logo_name.png'.asAssetImg(),
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  /// Navigate to terms and condition screen
  void _onNavigateToTerms(BuildContext context) async {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
            opacity: CurvedAnimation(
                parent: animation, curve: Interval(0.500, 1.00)),
            child: TermsScreen());
      },
    ));
  }
}

class _ThisLoginButton extends StatelessWidget {
  final _notifier = ValueNotifier<bool>(false);
  _ThisLoginButton({
    Key key,
    @required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (_) {
        _notifier.value = true;
      },
      onTap: () {
        _notifier.value = false;
        onTap();
      },
      onTapCancel: () {
        _notifier.value = false;
      },
      child: IgnorePointer(
        ignoring: true,
        child: ValueListenableBuilder<bool>(
          valueListenable: _notifier,
          builder: (context, isTranslate, child) {
            return AnimatedContainer(
              duration: AppConfigs.animDurationSmall ~/ 2,
              transform: Matrix4.translationValues(
                  0.0, isTranslate ? 10.0 : 0.00, 0.0),
              child: child,
            );
          },
          child: AppSlideButton(
            height: 70,
            label: 'Login with PolkadotJS',
            icon: Container(
              decoration: BoxDecoration(
                color: color1C2023,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(14),
              width: 45,
              height: 45,
              child: SvgPicture.asset(
                'arrow'.asAssetSvg(),
                fit: BoxFit.contain,
                color: colorFFFFFF,
              ),
            ),
            decoration: BoxDecoration(
              color: colorE6007A,
              borderRadius: BorderRadius.circular(20),
            ),
            // onComplete: () => _onNavigateToTerms(context),
          ),
        ),
      ),
    );
  }
}

/// The pageview of this screen
///
class _ThisPageView extends StatefulWidget {
  const _ThisPageView({
    Key key,
    @required this.length,
    @required ValueNotifier<int> pageviewIndexNotifier,
  })  : _pageviewIndexNotifier = pageviewIndexNotifier,
        super(key: key);

  final ValueNotifier<int> _pageviewIndexNotifier;
  final int length;

  @override
  __ThisPageViewState createState() => __ThisPageViewState();
}

class __ThisPageViewState extends State<_ThisPageView> {
  ValueNotifier<double> _pageNotifier;
  PageController _pageController;
  Timer _timer;

  void _initialiseTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.page < widget.length - 1) {
        _pageController.nextPage(
          duration: AppConfigs.animDuration,
          curve: Curves.ease,
        );
      } else {
        _pageController.animateToPage(
          0,
          duration: AppConfigs.animDuration,
          curve: Curves.ease,
        );
      }
    });
  }

  void animateTo(int index) {
    if (_pageController != null) {
      _pageController.animateToPage(
        index,
        duration: AppConfigs.animDuration,
        curve: Curves.ease,
      );
    }
  }

  @override
  void initState() {
    _pageNotifier = ValueNotifier<double>(0.0);
    _pageController = PageController()
      ..addListener(() {
        _pageNotifier.value = _pageController.page;
      });

    _initialiseTimer();

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    _pageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        accentColor: Colors.transparent,
        buttonColor: Colors.transparent,
      ),
      child: PageView.builder(
        pageSnapping: true,
        controller: _pageController,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ValueListenableBuilder<double>(
                  valueListenable: _pageNotifier,
                  builder: (context, page, child) {
                    final size = Size(392.7272, 759.2727);
                    final double scaleConst = (1.7 / size.height) *
                        MediaQuery.of(context).size.height;
                    final double offsetX =
                        (100 / size.width) * MediaQuery.of(context).size.width;
                    final double translateOffsetX =
                        (250 / size.width) * MediaQuery.of(context).size.width;
                    final double translateOffsetY = (190 / size.height) *
                        MediaQuery.of(context).size.height;

                    double value = (index - page);
                    double translateX = 0.0;
                    double scale = 1.0;

                    if (value > 0.0) {
                      value = page - index;

                      scale = (1 - value.abs()).abs() * scaleConst;
                    } else {
                      value = 1.0;
                      scale = scaleConst;
                      translateX = (page - index).abs();
                    }
                    return Transform(
                        transform: Matrix4.translationValues(
                            -offsetX + (-translateOffsetX * translateX),
                            -translateOffsetY,
                            0.0)
                          ..scale(scale, scale),
                        child: child);
                  },
                  child: Image.asset(
                    _DummyData.sliderImgList[index],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  _DummyData.sliderList[index] ?? "",
                  style: tsS32W600CFF,
                ),
              ),
            ],
          );
        },
        itemCount: _DummyData.sliderList.length,
        onPageChanged: (index) {
          widget._pageviewIndexNotifier.value = index;
        },
      ),
    );
  }
}
