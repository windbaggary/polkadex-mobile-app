import 'package:flutter/material.dart';
import 'package:polkadex/utils/styles.dart';
import 'package:polkadex/widgets/app_buttons.dart';

/// The app bar with backbutton and curve on the right side
class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key key,
    @required this.title,
    @required this.child,
    // @required AnimationController animationController,
    this.onTapBack,
    this.bgColor = const Color(0xFF2E303C),
    this.titleStyle,
    this.isExpanded = true,
  }) :
        // _opacityAnimation = CurvedAnimation(
        //         parent: animationController,
        //         curve: Interval(
        //           0.00,
        //           0.350,
        //           curve: Curves.decelerate,
        //         ),
        //       ),
        //       _backButtonAnimation =
        //           Tween<Offset>(begin: Offset(-1.5, 0.0), end: Offset(0.0, 0.0))
        //               .animate(
        //         CurvedAnimation(
        //           parent: animationController,
        //           curve: Interval(
        //             0.00,
        //             0.350,
        //             curve: Curves.decelerate,
        //           ),
        //         ),
        //       ),
        //       _headingAnimation =
        //           Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
        //               .animate(
        //         CurvedAnimation(
        //           parent: animationController,
        //           curve: Interval(
        //             0.00,
        //             0.350,
        //             curve: Curves.decelerate,
        //           ),
        //         ),
        //       ),
        super(key: key);
  final Widget child;
  final VoidCallback onTapBack;
  final String title;
  final Color bgColor;
  final TextStyle titleStyle;
  final bool isExpanded;

  // final Animation<double> _opacityAnimation;
  // final Animation<Offset> _headingAnimation;
  // final Animation<Offset> _backButtonAnimation;

  @override
  Widget build(BuildContext context) {
    Widget child = this.child;
    if (isExpanded) {
      child = Expanded(child: child);
    }
    return Container(
      // margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 4),
            child: Row(
              children: [
                _buildBackButton(context, onTapBack),
                Expanded(
                  child: Center(
                      // child: SlideTransition(
                      //   position: _headingAnimation,
                      //   child: FadeTransition(
                      //       opacity: _opacityAnimation,
                      child: Text(title ?? "",
                          style: titleStyle ?? tsS21W500CFF)),
                  //   ),
                  // ),
                ),
                SizedBox(width: 58),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        // child: SlideTransition(
        //   position: _backButtonAnimation,
        //   child: FadeTransition(
        //     opacity: _opacityAnimation,
        child: AppBackButton(
          onTap: onTap,
          //   ),
          // ),
        ),
      ),
    );
  }
}
