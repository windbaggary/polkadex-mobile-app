import 'dart:async';
import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/time_utils.dart';
import 'package:provider/provider.dart';
import 'common/cubits/account_cubit.dart';
import 'main.dart';

class AppLifecycleWidget extends StatefulWidget {
  const AppLifecycleWidget({required this.child});

  final Widget child;

  @override
  State<AppLifecycleWidget> createState() => _AppLifecycleWidgetState();
}

class _AppLifecycleWidgetState extends State<AppLifecycleWidget>
    with WidgetsBindingObserver {
  Timer? lockTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (context.read<AccountCubit>().state is AccountLoaded) {
      if (state == AppLifecycleState.paused) {
        lockTimer = Timer(
          Duration(
            minutes: TimeUtils.timerIntervalTypeToInt(
                context.read<AccountCubit>().timerInterval),
          ),
          () async {
            MyApp.restartApp(context);
          },
        );
      } else if (state == AppLifecycleState.resumed) {
        lockTimer?.cancel();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
