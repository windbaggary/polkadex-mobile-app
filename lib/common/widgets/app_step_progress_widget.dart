import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_horizontal_progress_bar.dart';

/// The progress bar with the steps on the left side
///
/// The widget is used in lets create screen
///

class AppStepProgressWidget extends StatelessWidget {
  /// The string will be displayed along with the text `Step `
  final String currentStep;

  /// The string will b displayed as total steps
  final String totalSteps;

  /// The progress of the bar should be greater than 0.0 and less than 1.0
  final double progress;

  /// This animation for showing the screen entry animation of the progress bar
  final Animation<double> animation;

  AppStepProgressWidget({
    Key key,
    @required this.currentStep,
    @required this.totalSteps,
    @required this.progress,
    this.animation,
  })  : assert(currentStep?.isNotEmpty ?? false, '''
  The current step string could not be empty
  '''),
        assert(totalSteps?.isNotEmpty ?? false, '''
  The total steps string could not be empty
  '''),
        assert(progress != null, '''
  The progress could not be null
  '''),
        assert(progress >= 0.0 && progress <= 1.0, '''
  The progress should be greater than or equal to 0.0 and less than or equal to 1.0
  '''),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget textWidget;
    final textChild = RichText(
      text: TextSpan(
        text: 'Step $currentStep ',
        style: tsS15W500CFF,
        children: <TextSpan>[
          TextSpan(
              text: '/ $totalSteps',
              style:
                  tsS15W500CFF.copyWith(color: colorFFFFFF.withOpacity(0.50))),
        ],
      ),
    );
    if (animation == null) {
      textWidget = textChild;
    } else {
      textWidget = SlideTransition(
        position: animation.drive(
            Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset(0.0, 0.0))),
        child: textChild,
      );
    }
    final body = Row(
      children: [
        textWidget,
        SizedBox(width: 24),
        Expanded(
          child: AppHorizontalProgressBar(
            progress: progress,
            animation: animation,
          ),
        ),
      ],
    );
    if (animation == null) {
      return body;
    } else {
      return FadeTransition(
        opacity: animation,
        child: body,
      );
    }
  }
}
