import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/features/landing/screens/landing_screen.dart';
import 'package:polkadex/utils/colors.dart';
import 'package:polkadex/utils/extensions.dart';
import 'package:polkadex/utils/styles.dart';
import 'package:polkadex/widgets/app_buttons.dart';
import 'package:polkadex/widgets/build_methods.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class LoginScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color2E303C,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  _buildBackButton(context),
                  Text(
                    "Login",
                    style: tsS21W500CFF,
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 10.0),
                decoration: BoxDecoration(
                  color: color1C2023,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40, top: 28),
                      child: Text(
                        'QR Code Scan',
                        style: tsS23W500CFF,
                      ),
                    ),
                    InkWell(
                      onTap: () => _onNavigateToHome(context),
                      child: _ThisTopCameraWidget(),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      padding:
                          const EdgeInsets.only(left: 39, top: 36, bottom: 39),
                      decoration: BoxDecoration(
                        color: color2E303C.withOpacity(0.30),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Scan a Polkadex QR Code',
                            style: tsS20W600CFF,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 8,
                              bottom: 15,
                              right: MediaQuery.of(context).size.width * 0.10,
                            ),
                            child: RichText(
                              text: TextSpan(
                                  style: tsS14W400CFF.copyWith(height: 1.4),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Open ',
                                      style: TextStyle(fontFamily: 'WorkSans'),
                                    ),
                                    TextSpan(
                                      text: 'https://Polkadex.trade',
                                      style: tsS14W400CFF.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ', then click in ',
                                      style: TextStyle(fontFamily: 'WorkSans'),
                                    ),
                                    TextSpan(
                                      text: 'Polkadex App',
                                      style: tsS14W400CFF.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                          Image.asset(
                            'polkadexScan.png'.asAssetImg(),
                            fit: BoxFit.fitWidth,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The back button for the screen
  Widget _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AppBackButton(
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  /// navigate to home screen
  void _onNavigateToHome(BuildContext context) {
    // print("####");
    // Navigator.push(
    //     context,
    //     PageRouteBuilder(
    //       pageBuilder: (context, animation, secondaryAnimation) =>
    //           FadeTransition(
    //         opacity: animation,
    //         child: LandingScreen(),
    //       ),
    //     ));
    Navigator.of(context).pushNamed(LandingScreen.routeName);
  }
}

class _ThisTopCameraWidget extends StatefulWidget {
  @override
  __ThisTopCameraWidgetState createState() => __ThisTopCameraWidgetState();
}

class __ThisTopCameraWidgetState extends State<_ThisTopCameraWidget> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late ValueNotifier<bool> _isFlashNotifier;
  QRViewController? controller;
  StreamSubscription<Barcode>? _streamSubscription;
  bool hasData = false;

  // Barcode result;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  void initState() {
    _isFlashNotifier = ValueNotifier<bool>(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12.0,
        right: 12.0,
        top: 18.0,
      ),
      child: Stack(
        children: [
          // Image.asset(
          //   'bg_login_cam.png'.asAssetImg(),
          //   fit: BoxFit.fitWidth,
          // ),
          IgnorePointer(
            ignoring: true,
            child: SizedBox(
              height: max(MediaQuery.of(context).size.height * 0.35, 250),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: (data) => _onQRViewCreated(data, context),
                ),
              ),
            ),
          ),
          Positioned(
            right: 14.0,
            bottom: 18.0,
            child: InkWell(
              onTap: () async {
                if (controller != null) {
                  _isFlashNotifier.value = !_isFlashNotifier.value;
                  await controller?.toggleFlash();
                  controller
                      ?.getFlashStatus()
                      .then((value) => _isFlashNotifier.value = value!);
                }
              },
              child: ValueListenableBuilder<bool>(
                valueListenable: _isFlashNotifier,
                builder: (context, isFlashOn, child) => Container(
                    width: 53,
                    height: 53,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isFlashOn ? colorE6007A : color2E303C,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: SvgPicture.asset(
                      'flashlight'.asAssetSvg(),
                      color: colorFFFFFF,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _isFlashNotifier.dispose();
    _closeSubscription();
    super.dispose();
  }

  void _closeSubscription() {
    _streamSubscription?.cancel();
  }

  /// Subscribe to qrcode result
  void _subscribe() {
    _closeSubscription();
    _streamSubscription =
        controller?.scannedDataStream.listen((scanData) async {
      // setState(() {
      //   result = scanData;
      // });
      if (hasData) return;
      hasData = true;
      await controller?.pauseCamera();
      print(scanData.code);
      String data = 'The qr code scanned: ${scanData.code} ${DateTime.now()}';
      buildAppToast(msg: data, context: context);
      await Navigator.of(context).pushNamed(LandingScreen.routeName);
    });
  }

  /// The qr code controller created callback
  void _onQRViewCreated(QRViewController controller, BuildContext context) {
    this.controller = controller;
    _subscribe();
  }
}
