import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/utils/extensions.dart';

class QRCodeScanScreen extends StatefulWidget {
  QRCodeScanScreen(this.onQrCodeScan);

  final Function(String)? onQrCodeScan;
  @override
  _QRCodeScanScreenState createState() => _QRCodeScanScreenState();
}

class _QRCodeScanScreenState extends State<QRCodeScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  MobileScannerController controller = MobileScannerController(
    facing: CameraFacing.front,
    torchEnabled: false,
  );
  late ValueNotifier<bool> _isFlashNotifier;

  @override
  void initState() {
    _isFlashNotifier = ValueNotifier<bool>(false);
    super.initState();
  }

  @override
  void dispose() {
    _isFlashNotifier.dispose();
    super.dispose();
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
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: MobileScanner(
                            key: qrKey,
                            onDetect: (barcode, args) =>
                                _onQRCodeDetected(barcode, context),
                          ),
                        ),
                      ),
                      if (controller.hasTorch)
                        Positioned(
                          right: 14.0,
                          bottom: 18.0,
                          child: InkWell(
                            onTap: () async {
                              _isFlashNotifier.value = !_isFlashNotifier.value;
                              await controller.toggleTorch();
                              _isFlashNotifier.value =
                                  controller.torchEnabled ?? false;
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

  void _onQRCodeDetected(Barcode barcode, BuildContext context) async {
    if (barcode.rawValue != null) {
      if (widget.onQrCodeScan != null) {
        await widget.onQrCodeScan!(barcode.rawValue ?? '');
      } else {
        Navigator.pop(context, barcode.rawValue);
      }
    }
  }
}
