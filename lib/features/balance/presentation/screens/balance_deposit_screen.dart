// import 'package:clipboard/clipboard.dart';
// import 'package:flutter/material.dart';
// import 'package:polkadex/features/balance/screens/balance_deposit_screen_1.dart';
// import 'package:polkadex/utils/colors.dart';
// import 'package:polkadex/utils/extensions.dart';
// import 'package:polkadex/utils/styles.dart';
// import 'package:polkadex/widgets/build_methods.dart';

// class BalanceDepositScreen extends StatefulWidget {
//   @override
//   _BalanceDepositScreenState createState() => _BalanceDepositScreenState();
// }

// class _BalanceDepositScreenState extends State<BalanceDepositScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: color1C2023,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Row(
//               children: [
//                 InkWell(
//                   onTap: () => Navigator.of(context).pop(),
//                   child: SizedBox(
//                     width: 50,
//                     height: 50,
//                     child: Icon(
//                       Icons.close,
//                       color: colorFFFFFF,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Text(
//                     "Deposit Polkadex (DEX)",
//                     style: tsS19W700CFF,
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 SizedBox(width: 50),
//               ],
//             ),
//             SizedBox(height: 8),
//             Expanded(
//               child: SingleChildScrollView(
//                 physics: BouncingScrollPhysics(),
//                 padding: const EdgeInsets.only(bottom: 36),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         top: 16,
//                         bottom: 27,
//                         left: 27,
//                         right: 31,
//                       ),
//                       child: Row(
//                         children: [
//                           Text(
//                             'Network:',
//                             style: tsS16W600CFF,
//                           ),
//                           SizedBox(width: 36),
//                           Expanded(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: color2E303C,
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               padding: const EdgeInsets.fromLTRB(27, 8, 24, 8),
//                               child: DropdownButton<String>(
//                                 items: ['DOT Chain', 'DOT Chain 2', 'DOT  3']
//                                     .map((e) => DropdownMenuItem<String>(
//                                           child: Text(
//                                             e,
//                                             style: tsS16W600CFF,
//                                           ),
//                                           value: e,
//                                         ))
//                                     ?.toList(),
//                                 value: 'DOT Chain',
//                                 style: tsS16W600CFF,
//                                 underline: Container(),
//                                 onChanged: (val) {},
//                                 isExpanded: true,
//                                 iconEnabledColor: Colors.white,
//                                 icon: Padding(
//                                   padding: const EdgeInsets.only(left: 4.0),
//                                   child: Icon(
//                                     Icons.keyboard_arrow_down_rounded,
//                                     color: colorFFFFFF,
//                                     size: 16,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: color2E303C,
//                         borderRadius: BorderRadius.only(
//                           topRight: Radius.circular(40),
//                           bottomLeft: Radius.circular(40),
//                           bottomRight: Radius.circular(40),
//                         ),
//                       ),
//                       margin: const EdgeInsets.symmetric(horizontal: 9),
//                       padding: const EdgeInsets.fromLTRB(12, 33, 12, 24),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           Center(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(18),
//                                 color: colorFFFFFF,
//                               ),
//                               width: 57,
//                               height: 57,
//                               padding: const EdgeInsets.all(3),
//                               child: Image.asset(
//                                 'trade_open/trade_open_2.png'?.asAssetImg(),
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 10, bottom: 14),
//                             child: Text(
//                               'Scan or share',
//                               style: tsS20W600CFF,
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                           Center(
//                             child: Image.asset(
//                               'qr-code.png'.asAssetImg(),
//                               width: MediaQuery.of(context).size.width * 0.55,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 24, bottom: 16),
//                             child: buildInkWell(
//                               borderRadius: BorderRadius.circular(20),
//                               onTap: () {
//                                 FlutterClipboard.copy(
//                                         '3P3QsMVK89JBNqZQv5zMAKG8FK3k')
//                                     .then((value) => buildAppToast(
//                                         msg:
//                                             'The address is copied to the clipboard',
//                                         context: context));
//                               },
//                               child: Container(
//                                 padding:
//                                     const EdgeInsets.fromLTRB(20, 24, 20, 26),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black.withOpacity(0.2),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment:
//                                       CrossAxisAlignment.stretch,
//                                   children: [
//                                     Text(
//                                       'Your DEX Address',
//                                       style: tsS16W600CFF,
//                                     ),
//                                     SizedBox(height: 7.3),
//                                     Text(
//                                       '3P3QsMVK89JBNqZQv5zMAKG8FK3k',
//                                       style: tsS15W400CFF.copyWith(
//                                         color: colorFFFFFF.withOpacity(0.70),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           RichText(
//                             textAlign: TextAlign.center,
//                             text: TextSpan(
//                               style: tsS14W400CFFOP50,
//                               children: <TextSpan>[
//                                 TextSpan(
//                                   text: 'Tap ',
//                                   style: TextStyle(
//                                     fontFamily: 'WorkSans',
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text: 'Address',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text: ' to copy',
//                                   style: TextStyle(
//                                     fontFamily: 'WorkSans',
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(26, 30, 26, 36),
//                       child: Text(
//                         'Attention: Sending token other than DEX to this address may result in the loss of your deposit.',
//                         style: tsS13W400CFFOP60.copyWith(color: colorFFFFFF),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     Center(
//                       child: InkWell(
//                         onTap: () => Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => BalanceDepositScreenOne(),
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 color: color8BA1BE.withOpacity(0.2),
//                               ),
//                               width: 48,
//                               height: 48,
//                               padding: const EdgeInsets.all(14),
//                               margin: const EdgeInsets.only(right: 14),
//                               child: Image.asset('share.png'.asAssetImg()),
//                             ),
//                             Text(
//                               'Share',
//                               style: tsS16W600CFF,
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
