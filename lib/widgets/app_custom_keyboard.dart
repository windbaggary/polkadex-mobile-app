// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:polkadex/utils/colors.dart';
// import 'package:polkadex/utils/extensions.dart';
// import 'package:polkadex/utils/styles.dart';

// class AppCustomKeyboard extends StatefulWidget {
//   final VoidCallback onTextTapped;
//   const AppCustomKeyboard({
//     Key key,
//     this.onTextTapped,
//   }) : super(key: key);

//   @override
//   AppCustomKeyboardState createState() => AppCustomKeyboardState();
// }

// class AppCustomKeyboardState extends State<AppCustomKeyboard> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: color2E303C,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(30),
//           topRight: Radius.circular(30),
//         ),
//       ),
//       padding: const EdgeInsets.symmetric(
//         horizontal: 19,
//         vertical: 17,
//       ),
//       child: IntrinsicHeight(
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 children: [
//                   Row(
//                     children: List.generate(
//                       3,
//                       (index) => Expanded(
//                         child: _ThisNumberItemWidget(
//                           number: (index + 1).toString(),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Row(
//                     children: List.generate(
//                       3,
//                       (index) => Expanded(
//                         child: _ThisNumberItemWidget(
//                           number: (index + 1 + 3).toString(),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Row(
//                     children: List.generate(
//                       3,
//                       (index) => Expanded(
//                         child: _ThisNumberItemWidget(
//                           number: (index + 1 + 6).toString(),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: _ThisNumberItemWidget(
//                           number: '.',
//                         ),
//                       ),
//                       Expanded(
//                         child: _ThisNumberItemWidget(
//                           number: '0',
//                         ),
//                       ),
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8),
//                           child: SizedBox(
//                             width: 26,
//                             height: 20,
//                             child: Icon(
//                               Icons.backspace,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(width: 16),
//             IntrinsicWidth(
//               child: Column(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       color: color1C2023,
//                       borderRadius: BorderRadius.circular(15),
//                       boxShadow: <BoxShadow>[bsDefault],
//                     ),
//                     padding: const EdgeInsets.fromLTRB(11, 15, 11, 14),
//                     child: Row(
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             color: colorFFFFFF,
//                             borderRadius: BorderRadius.circular(11),
//                           ),
//                           padding: const EdgeInsets.all(2.5),
//                           width: 26,
//                           height: 26,
//                           child: Image.asset(
//                             'trade_open/trade_open_2.png'.asAssetImg(),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 11),
//                           child: SvgPicture.asset(
//                             'arrow-2'.asAssetSvg(),
//                             width: 20,
//                             height: 13,
//                           ),
//                         ),
//                         Opacity(
//                           opacity: 0.20,
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: color8BA1BE,
//                               borderRadius: BorderRadius.circular(11),
//                             ),
//                             padding: const EdgeInsets.all(8),
//                             width: 26,
//                             height: 26,
//                             child: SvgPicture.asset(
//                               'fiat'.asAssetSvg(),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: colorE6007A,
//                         borderRadius: BorderRadius.circular(15),
//                         boxShadow: <BoxShadow>[bsDefault],
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(
//                         'Enter',
//                         style: tsS17W600C0CA564.copyWith(color: colorFFFFFF),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _ThisNumberItemWidget extends StatelessWidget {
//   final String number;

//   const _ThisNumberItemWidget({Key key, @required this.number})
//       : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Text(
//         number ?? "",
//         style: TextStyle(
//           fontFamily: 'Roboto',
//           fontSize: 30,
//           fontWeight: FontWeight.w400,
//           color: colorFFFFFF,
//         ),
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
// }
