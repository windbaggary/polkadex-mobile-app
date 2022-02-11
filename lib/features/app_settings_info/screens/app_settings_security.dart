import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/cubits/account_cubit.dart';
import 'package:polkadex/common/widgets/option_tab_switch_widget.dart';
import 'package:polkadex/features/app_settings_info/widgets/app_settings_layout.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:provider/provider.dart';
import 'package:polkadex/injection_container.dart';

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
        backgroundColor: AppColors.color1C2023,
        body: AppSettingsLayout(
          childAlignment: null,
          isExpanded: false,
          contentChild: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 18, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (dependency.get<bool>(instanceName: 'isBiometricAvailable'))
                  Column(
                    children: [
                      SizedBox(height: 8),
                      BlocBuilder<AccountCubit, AccountState>(
                          builder: (context, state) {
                        return OptionTabSwitchWidget(
                          enabled: context.read<AccountCubit>().state
                              is AccountLoaded,
                          loading: state is AccountUpdatingBiometric,
                          svgAsset: "finger-print".asAssetSvg(),
                          title: "Secure with Biometric",
                          description:
                              "Secure your access without typing your Pin Code.",
                          isChecked:
                              context.read<AccountCubit>().biometricAccess,
                          onSwitchChanged: (_) => context
                              .read<AccountCubit>()
                              .switchBiometricAccess(),
                        );
                      }),
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: Divider(
                          color: Colors.white10,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                Consumer<_ThisProvider>(
                  builder: (context, thisProvider, child) =>
                      OptionTabSwitchWidget(
                    enabled: false,
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
                  builder: (context, thisProvider, child) =>
                      OptionTabSwitchWidget(
                    enabled: false,
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
                  builder: (context, thisProvider, child) =>
                      OptionTabSwitchWidget(
                    enabled: false,
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
