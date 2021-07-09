import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:polkadex/utils/colors.dart';
import 'package:polkadex/utils/styles.dart';

/// The build method to show toast over the screen
void buildAppToast({@required String msg, @required BuildContext context}) {
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: color2E303C.withOpacity(0.90),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black.withOpacity(0.90),
          blurRadius: 99,
          offset: Offset(0.0, 0.0),
        )
      ],
    ),
    child: Text(
      msg ?? "",
      style: tsS14W500CFF,
      textAlign: TextAlign.center,
    ),
  );
  FToast()
    ..init(context)
    ..showToast(
      child: toast,
    );
}

/// A useful inkwell which are added default highlight and splash color
///
Widget buildInkWell({
  @required Widget child,
  @required VoidCallback onTap,
  BorderRadius borderRadius,
  Color highlightColor = const Color(0x558BA1BE),
  Color splashColor = const Color(0xFF8BA1BE),
}) {
  return Material(
      type: MaterialType.transparency,
      child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          highlightColor: highlightColor,
          splashColor: splashColor,
          child: child));
}
