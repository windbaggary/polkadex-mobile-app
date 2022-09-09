import 'dart:async';

import 'package:flutter/material.dart';

class LoadingDotsWidget extends StatefulWidget {
  const LoadingDotsWidget({required this.dotSize});

  final double dotSize;

  @override
  State<LoadingDotsWidget> createState() => _LoadingDotsWidgetState();
}

class _LoadingDotsWidgetState extends State<LoadingDotsWidget> {
  int indexDotFade = 0;
  late Timer animationTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => animationTimer = Timer.periodic(
        Duration(milliseconds: 500),
        (_) => setState(() => indexDotFade = (indexDotFade + 1) % 3),
      ),
    );
  }

  @override
  void dispose() {
    animationTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (index) => Container(
          width: widget.dotSize,
          height: widget.dotSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == indexDotFade
                ? Colors.white.withOpacity(0.5)
                : Colors.white,
          ),
        ),
      )
        ..insert(
            1,
            SizedBox(
              width: 4,
            ))
        ..insert(
            3,
            SizedBox(
              width: 4,
            )),
    );
  }
}
