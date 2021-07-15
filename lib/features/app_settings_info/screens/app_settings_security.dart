import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/features/app_settings_info/widgets/app_settings_layout.dart';
import 'package:polkadex/utils/colors.dart';
import 'package:polkadex/utils/styles.dart';
import 'package:polkadex/utils/extensions.dart';
import 'package:provider/provider.dart';

/// XD_PAGE: 42
class AppSettingsSecurity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<_ThisProvider>(
          create: (_) => _ThisProvider(),
        ),
      ],
      builder: (context, _) => Scaffold(
        backgroundColor: color1C2023,
        body: AppSettingsLayout(
          childAlignment: null,
          isExpanded: false,
          contentChild: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 18, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 8),
                Consumer<_ThisProvider>(
                  builder: (context, thisProvider, child) => _ThisItemWidget(
                    svgAsset: "finger-print".asAssetSvg(),
                    title: "Secure with FingerPrint",
                    description:
                        "Secure your access without typing your Pin Code.",
                    isChecked: thisProvider.isFingerPrint,
                    onSwitchChanged: (value) {
                      thisProvider.isFingerPrint = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Divider(
                    color: Colors.white10,
                    height: 1,
                  ),
                ),
                Consumer<_ThisProvider>(
                  builder: (context, thisProvider, child) => _ThisItemWidget(
                    svgAsset: "keypad".asAssetSvg(),
                    title: "Secure with Pin Code",
                    description: "Your access are kept safe by Pin Code.",
                    isChecked: thisProvider.isPinCode,
                    onSwitchChanged: (value) {
                      thisProvider.isPinCode = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Divider(
                    color: Colors.white10,
                    height: 1,
                  ),
                ),
                Consumer<_ThisProvider>(
                  builder: (context, thisProvider, child) => _ThisItemWidget(
                    svgAsset: "security".asAssetSvg(),
                    title: "Two-Factor Authentication (2FA)",
                    description:
                        "Use the Google Authentication or Authy app to generate one time security codes.",
                    isChecked: thisProvider.isTwoFactor,
                    onSwitchChanged: (value) {
                      thisProvider.isTwoFactor = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Divider(
                    color: Colors.white10,
                    height: 1,
                  ),
                ),
                Consumer<_ThisProvider>(
                  builder: (context, thisProvider, child) => _ThisItemWidget(
                    svgAsset: "tracker".asAssetSvg(),
                    title: "Tracking IP",
                    description: "Block access to suspicious IPs.",
                    isChecked: thisProvider.isIp,
                    onSwitchChanged: (value) {
                      thisProvider.isIp = value;
                    },
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
          subTitle: 'Privacy & Security',
          mainTitle: 'Privacy & Security',
          isShowSubTitle: false,
          onBack: () => Navigator.of(context).pop(),
          bottomChild: Padding(
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.08120,
              30,
              MediaQuery.of(context).size.width * 0.08120,
              36,
            ),
            child: Text(
              "Polkadex does not store any data , by security, Polkadex only enable withdrawals by confirmation via Two-Factor Authentication (2FA).",
              style: tsS14W400CFF,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

/// The widget represents the each items in the list of the screen
class _ThisItemWidget extends StatelessWidget {
  final String svgAsset;
  final String? title;
  final String? description;
  final bool isChecked;
  final ValueChanged<bool> onSwitchChanged;
  const _ThisItemWidget({
    required this.svgAsset,
    required this.title,
    required this.description,
    required this.isChecked,
    required this.onSwitchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: color8BA1BE.withOpacity(0.2),
            ),
            padding: const EdgeInsets.all(14),
            child: SvgPicture.asset(svgAsset),
          ),
          SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title ?? "",
                  style: tsS15W400CFF,
                ),
                SizedBox(height: 1),
                Text(
                  description ?? "",
                  style: tsS13W400CFFOP60,
                ),
              ],
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.01800),
          SizedBox(
            width: 48,
            height: 48,
            child: FittedBox(
              child: Switch(
                value: this.isChecked,
                onChanged: this.onSwitchChanged,
                inactiveTrackColor: Colors.white.withOpacity(0.15),
                activeColor: colorABB2BC,
                activeTrackColor: Colors.white.withOpacity(0.15),
                inactiveThumbColor: colorE6007A,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The provider to handle the click selection of the screen
class _ThisProvider extends ChangeNotifier {
  bool _isFigerPrint = false,
      _isPinCode = false,
      _isTwoFactor = false,
      _isIp = false;

  bool get isFingerPrint => this._isFigerPrint;
  bool get isPinCode => this._isPinCode;
  bool get isTwoFactor => this._isTwoFactor;
  bool get isIp => this._isIp;

  set isFingerPrint(bool val) {
    this._isFigerPrint = val;
    notifyListeners();
  }

  set isPinCode(bool val) {
    this._isPinCode = val;
    notifyListeners();
  }

  set isTwoFactor(bool val) {
    this._isTwoFactor = val;
    notifyListeners();
  }

  set isIp(bool val) {
    this._isIp = val;
    notifyListeners();
  }
}
