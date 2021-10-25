import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common/blocs/account_cubit.dart';
import 'main.dart';

class AppLifecycleWidget extends StatefulWidget {
  const AppLifecycleWidget({required this.child});

  final Widget child;

  @override
  State<AppLifecycleWidget> createState() => _AppLifecycleWidgetState();
}

class _AppLifecycleWidgetState extends State<AppLifecycleWidget>
    with WidgetsBindingObserver {
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

  late AppLifecycleState _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(context.read<AccountCubit>().state);
    if (context.read<AccountCubit>().state is AccountLoaded &&
        state.index == 0) {
      MyApp.restartApp(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
