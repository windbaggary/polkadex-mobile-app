import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:polkadex/common/utils/extensions.dart';

/// The QRCode screen can be accessed usign navigator. The screen displays
/// the QR code and once its read it will pop the result
///
class QRCodeScanScreen extends StatefulWidget {
  @override
  _QRCodeScanScreenState createState() => _QRCodeScanScreenState();
}

class _QRCodeScanScreenState extends State<QRCodeScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late ValueNotifier<bool> _isFlashNotifier;
  QRViewController? controller;
  StreamSubscription<Barcode>? _streamSubscription;
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
    return Scaffold(
      backgroundColor: AppColors.color1C2023,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.color2E303C,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAppbar(context),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.color1C2023,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(35),
                      topLeft: Radius.circular(35),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Image.asset(
                      //   'bg_login_cam.png'.asAssetImg(),
                      //   fit: BoxFit.fitWidth,
                      // ),
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: QRView(
                            key: qrKey,
                            onQRViewCreated: (data) =>
                                _onQRViewCreated(data, context),
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
                              controller?.getFlashStatus().then(
                                  (value) => _isFlashNotifier.value = value!);
                            }
                          },
                          child: ValueListenableBuilder<bool>(
                            valueListenable: _isFlashNotifier,
                            builder: (context, isFlashOn, child) => Container(
                                width: 53,
                                height: 53,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isFlashOn
                                      ? AppColors.colorE6007A
                                      : AppColors.color2E303C,
                                ),
                                padding: const EdgeInsets.all(16),
                                child: SvgPicture.asset(
                                  'flashlight'.asAssetSvg(),
                                  color: AppColors.colorFFFFFF,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppbar(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 16, top: 8),
        child: Row(
          children: [
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: SizedBox(
                width: 50,
                height: 50,
                child: Icon(
                  Icons.close,
                  color: AppColors.colorFFFFFF,
                ),
              ),
            ),
            Expanded(
              child: Text(
                "Scan QR Code",
                style: tsS19W700CFF,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 50),
          ],
        ),
      );

  @override
  void dispose() {
    _isFlashNotifier.dispose();
    _closeSubscription();
    super.dispose();
  }

  void _closeSubscription() {
    if (_streamSubscription != null) {
      _streamSubscription?.cancel();
      _streamSubscription = null;
    }
  }

  bool hasData = false;
  void _subscribe() {
    _closeSubscription();
    _streamSubscription =
        controller!.scannedDataStream.listen((scanData) async {
      // setState(() {
      //   result = scanData;
      // });
      if (hasData) return;
      hasData = true;
      await controller?.pauseCamera();
      Navigator.pop(context, scanData.code);
    });
  }

  void _onQRViewCreated(QRViewController controller, BuildContext context) {
    this.controller = controller;
    _subscribe();
  }
}
