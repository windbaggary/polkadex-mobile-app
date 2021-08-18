import 'package:flutter/material.dart';
import 'package:polkadex/common/widgets/option_tab_switch_widget.dart';
import 'package:polkadex/features/app_settings_info/widgets/app_settings_layout.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/generated/l10n.dart';
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
                  builder: (context, thisProvider, child) =>
                      OptionTabSwitchWidget(
                    svgAsset: "finger-print".asAssetSvg(),
                    title: S.of(context).secureWithFingerPrint,
                    description: S.of(context).secureYourAccessWithout,
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
                  builder: (context, thisProvider, child) =>
                      OptionTabSwitchWidget(
                    svgAsset: "keypad".asAssetSvg(),
                    title: S.of(context).secureWithPinCode,
                    description: S.of(context).yourAccessAreKept,
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
                  builder: (context, thisProvider, child) =>
                      OptionTabSwitchWidget(
                    svgAsset: "security".asAssetSvg(),
                    title: S.of(context).twoFactorAuth,
                    description: S.of(context).useTheGoogleAuth,
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
                  builder: (context, thisProvider, child) =>
                      OptionTabSwitchWidget(
                    svgAsset: "tracker".asAssetSvg(),
                    title: S.of(context).trackingIp,
                    description: S.of(context).blockAccess,
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
          subTitle: S.of(context).privacyAndSecurity,
          mainTitle: S.of(context).privacyAndSecurity,
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
              S.of(context).polkadexOnlyEnable,
              style: tsS14W400CFF,
              textAlign: TextAlign.center,
            ),
          ),
        ),
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

  bool get isFingerPrint => _isFigerPrint;
  bool get isPinCode => _isPinCode;
  bool get isTwoFactor => _isTwoFactor;
  bool get isIp => _isIp;

  set isFingerPrint(bool val) {
    _isFigerPrint = val;
    notifyListeners();
  }

  set isPinCode(bool val) {
    _isPinCode = val;
    notifyListeners();
  }

  set isTwoFactor(bool val) {
    _isTwoFactor = val;
    notifyListeners();
  }

  set isIp(bool val) {
    _isIp = val;
    notifyListeners();
  }
}
