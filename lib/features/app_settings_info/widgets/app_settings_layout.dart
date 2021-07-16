import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/custom_app_bar.dart';

/// The base screen for the apps settings from the drawer selection
///
/// XD_PAGE: 45
class AppSettingsLayout extends StatelessWidget {
  final String mainTitle;
  final String subTitle;
  final Widget contentChild;
  // final AnimationController animationController;
  final VoidCallback onBack;
  final Alignment childAlignment;
  final Widget bottomChild;
  final bool isExpanded;
  final bool isShowSubTitle;

  const AppSettingsLayout({
    Key key,
    @required this.subTitle,
    @required this.contentChild,
    this.mainTitle = 'App Settings',
    this.childAlignment = Alignment.topCenter,
    // @required this.animationController,
    this.onBack,
    this.bottomChild,
    this.isExpanded = true,
    this.isShowSubTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ThisInheritedWidget(
      // animationController: this.animationController,
      onBack: this.onBack,
      child: SafeArea(
        child: CustomAppBar(
          isExpanded: true,
          title: this.mainTitle,
          // animationController: this.animationController,
          onTapBack: onBack,
          child: _ThisSubTitleWidget(
            title: subTitle,
            contentChild: contentChild,
            childAlignment: childAlignment,
            bottomChild: bottomChild,
            isExpanded: isExpanded,
            isShowSubTitle: isShowSubTitle,
          ),
        ),
      ),
    );
  }
}

class _ThisSubTitleWidget extends StatelessWidget {
  const _ThisSubTitleWidget({
    Key key,
    @required this.title,
    @required this.contentChild,
    @required this.childAlignment,
    @required this.bottomChild,
    @required this.isExpanded,
    @required this.isShowSubTitle,
  }) : super(key: key);
  final String title;
  final Widget contentChild;
  final Alignment childAlignment;
  final Widget bottomChild;
  final bool isExpanded;
  final bool isShowSubTitle;

  @override
  Widget build(BuildContext context) {
    Widget contentChild = this.contentChild;
    if (childAlignment != null) {
      contentChild = Align(
        alignment: childAlignment,
        child: this.contentChild,
      );
    }
    // if (isExpanded) {
    //   contentChild = Expanded(
    //     child: contentChild,
    //   );
    // }

    // contentChild = Column(
    //   mainAxisSize:
    //       childAlignment == null ? MainAxisSize.min : MainAxisSize.max,
    //   children: [
    //     contentChild,
    //     if (bottomChild != null) bottomChild,
    //   ],
    // );

    contentChild = Align(
      alignment: Alignment.topCenter,
      child: Container(
        decoration: BoxDecoration(
          color: color2E303C,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40),
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        alignment: childAlignment,
        child: contentChild,
      ),
    );
    if (isExpanded) {
      contentChild = Expanded(
        child: contentChild,
      );
    }

    contentChild = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        contentChild,
        if (bottomChild != null) bottomChild,
      ],
    );

    if (!isExpanded) {
      contentChild = SingleChildScrollView(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        child: contentChild,
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: color1C2023,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isShowSubTitle)
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 27, 40, 24),
              child: Text(
                title ?? "",
                style: tsS20W500CFF,
              ),
            ),
          Expanded(child: contentChild),
        ],
      ),
    );
  }
}

/// The inherited widget to invoke the [onBack] on sub widgets
class _ThisInheritedWidget extends InheritedWidget {
  // final AnimationController animationController;
  final VoidCallback onBack;

  _ThisInheritedWidget({
    Key key,
    @required Widget child,
    // @required this.animationController,
    @required this.onBack,
  }) : super(key: key, child: child);
  @override
  bool updateShouldNotify(covariant _ThisInheritedWidget oldWidget) {
    return
        // oldWidget.animationController != this.animationController ||
        oldWidget.onBack != this.onBack;
  }

  // static _ThisInheritedWidget of(BuildContext context) =>
  //     context.dependOnInheritedWidgetOfExactType<_ThisInheritedWidget>();
}
