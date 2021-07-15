import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/configs/app_config.dart';
import 'package:polkadex/features/app_settings_info/screens/app_settings_appearance.dart';
import 'package:polkadex/features/app_settings_info/screens/app_settings_change_logs_screen.dart';
import 'package:polkadex/features/app_settings_info/screens/app_settings_help_screen.dart';
import 'package:polkadex/features/app_settings_info/screens/app_settings_lang_curr.dart';
import 'package:polkadex/features/app_settings_info/screens/app_settings_notif_screen.dart';
import 'package:polkadex/features/app_settings_info/screens/app_settings_security.dart';
import 'package:polkadex/features/app_settings_info/screens/my_account_screen.dart';
import 'package:polkadex/features/app_settings_info/screens/privacy_policy_screen.dart';
import 'package:polkadex/features/app_settings_info/screens/terms_conditions_screen.dart';
import 'package:polkadex/features/landing/providers/notification_drawer_provider.dart';
import 'package:polkadex/features/notifications/screens/notif_deposit_screen.dart';
import 'package:polkadex/features/notifications/screens/notif_details_screen.dart';
import 'package:polkadex/features/setup/screens/intro_screen.dart';
import 'package:polkadex/utils/colors.dart';
import 'package:polkadex/utils/enums.dart';
import 'package:polkadex/utils/extensions.dart';
import 'package:polkadex/utils/styles.dart';
import 'package:polkadex/widgets/build_methods.dart';

import 'package:provider/provider.dart';

/// The left drawer width
const double APP_DRAWER_WIDTH = 300;

/// The right drawer width
double getAppDrawerNotifWidth() {
  print(AppConfigs.size!.width);
  // double ratio = 0.300;
  // if (Platform.isIOS) {
  // ratio = 0.750;
  // }
  // return math.min<double>(AppConfigs.size.width * ratio, 350.0);
  return AppConfigs.size!.width - 40;
}

/// XD_PAGE: 35
///
/// The drawer widget for the app.
/// The [AppDrawerProvider] must be inherited on parent widget to handle the
/// visible state
///
class AppDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: color1C2023,
        hoverColor: color1C2023,
        highlightColor: color1C2023,
        focusColor: color1C2023,
        buttonColor: color1C2023,
      ),
      child: SizedBox(
        height: double.infinity,
        width: APP_DRAWER_WIDTH,
        child: Container(
          decoration: BoxDecoration(
            color: color2E303C.withOpacity(0.30),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black.withOpacity(0.17),
                  blurRadius: 99,
                  offset: Offset(0.0, 100.0)),
            ],
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ThisProfileWidget(),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    decoration: BoxDecoration(
                        color: color2E303C,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        )),
                    padding: const EdgeInsets.symmetric(horizontal: 27),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeading(label: 'App Settings'),
                        ...EnumDrawerAppSettings.values
                            .map((e) => _buildAppSettingsItem(e))
                            .toList(),
                        _buildHeading(label: 'App Information'),
                        ...EnumDrawerAppInfo.values
                            .map((e) => _buildAppInfoItem(e))
                            .toList(),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the heading style widget with [label]
  /// Also include the padding to the top and bottom
  ///
  Widget _buildHeading({required String label}) => Padding(
        padding: const EdgeInsets.only(top: 49, bottom: 2),
        child: Text(
          label,
          style: tsS16W500CABB2BC,
        ),
      );

  ///  This method will be invoked when user tap on app settings item
  void _onTapAppSettingsItem(EnumDrawerAppSettings e, BuildContext context) {
    switch (e) {
      case EnumDrawerAppSettings.Notifications:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AppSettingsNotificationScreen(),
        ));
        break;
      case EnumDrawerAppSettings.Appearance:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AppSettingsAppearance(),
        ));
        break;
      case EnumDrawerAppSettings.LanguageCurrency:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AppSettingsLangCurrScreen(),
        ));
        break;
      case EnumDrawerAppSettings.PrivacySecurtiy:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AppSettingsSecurity(),
        ));
        break;
      case EnumDrawerAppSettings.MyAccount:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MyAccountScreen(),
        ));
        break;
    }
  }

  /// Builds the widget for the app setting item
  /// The method also handle onTap event
  Widget _buildAppSettingsItem(EnumDrawerAppSettings e) {
    String svg;
    String label;

    switch (e) {
      case EnumDrawerAppSettings.Notifications:
        svg = 'drawer_notification'.asAssetSvg();
        label = 'Notifications';
        break;
      case EnumDrawerAppSettings.Appearance:
        svg = 'drawer_toggle'.asAssetSvg();
        label = 'Appearance';
        break;
      case EnumDrawerAppSettings.LanguageCurrency:
        svg = 'drawer_flag'.asAssetSvg();
        label = 'Language & Currency';
        break;
      case EnumDrawerAppSettings.PrivacySecurtiy:
        svg = 'drawer_finger-print'.asAssetSvg();
        label = 'Privacy & Security';
        break;
      case EnumDrawerAppSettings.MyAccount:
        svg = 'drawer_avatar'.asAssetSvg();
        label = 'My Account';
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Builder(
        builder: (context) => _ThisDrawerItemWidget(
          label: label,
          svgAsset: svg,
          onTap: () => _onTapAppSettingsItem(e, context),
        ),
      ),
    );
  }

  /// The method returns the widget of [e]
  /// The method also handle onTap event
  Widget _buildAppInfoItem(EnumDrawerAppInfo e) {
    String svg;
    String label;

    switch (e) {
      case EnumDrawerAppInfo.TermsConditions:
        label = 'Terms and Conditions';
        svg = 'drawer_terms'.asAssetSvg();
        break;
      case EnumDrawerAppInfo.PrivacyPolicy:
        label = 'Privacy Policy';
        svg = 'drawer_privacy'.asAssetSvg();
        break;
      case EnumDrawerAppInfo.HelpSupport:
        label = 'Help & Support';
        svg = 'drawer_chat'.asAssetSvg();
        break;
      case EnumDrawerAppInfo.ChangeLog:
        label = 'Changelog';
        svg = 'drawer_news'.asAssetSvg();
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Builder(
        builder: (context) => _ThisDrawerItemWidget(
          label: label,
          svgAsset: svg,
          onTap: () => _onTapAppInfoItem(e, context),
        ),
      ),
    );
  }

  /// This method will be invoked when user tap on [e] in drawer
  void _onTapAppInfoItem(EnumDrawerAppInfo e, BuildContext context) {
    switch (e) {
      case EnumDrawerAppInfo.TermsConditions:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TermsConditionsScreen()));
        break;
      case EnumDrawerAppInfo.PrivacyPolicy:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()));
        break;
      case EnumDrawerAppInfo.HelpSupport:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AppSettingsHelpScreen()));
        break;
      case EnumDrawerAppInfo.ChangeLog:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AppSettingsChangeLogsScreen()));
        break;
    }
  }
}

/// The top widget of the drawer represents the name, profile pic and id
class _ThisProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 22,
        right: 22,
        top: 56,
        bottom: 43,
      ),
      child: Row(
        children: [
          Image.asset(
            'user_icon.png'.asAssetImg(),
            width: 56,
            height: 56,
            fit: BoxFit.contain,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Kas Pintxuki',
                  style: tsS21W600CFF,
                ),
                Text(
                  'ID: 18592080',
                  style: tsS13W500CFFOP50,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => IntroScreen()),
                  (route) => false);
            },
            borderRadius: BorderRadius.circular(12),
            child: SvgPicture.asset(
              'drawer_logout'.asAssetSvg(),
              width: 20,
              height: 25,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

/// The single item widget of the drawer
class _ThisDrawerItemWidget extends StatelessWidget {
  final String svgAsset;
  final String label;
  final VoidCallback? onTap;

  const _ThisDrawerItemWidget(
      {required this.svgAsset, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color8BA1BE.withOpacity(0.20),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(9),
              margin: const EdgeInsets.only(right: 12),
              child: SvgPicture.asset(svgAsset),
            ),
            Expanded(
              child: Text(
                label,
                style: tsS16W400CFF,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// XD_PAGE: 37
class NotificationDrawerWidget extends StatelessWidget {
  final VoidCallback? onClearTap;
  const NotificationDrawerWidget({this.onClearTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: getAppDrawerNotifWidth(),
      child: Container(
        decoration: BoxDecoration(
          color: color2E303C.withOpacity(0.30),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black.withOpacity(0.17),
                blurRadius: 99,
                offset: Offset(0.0, 100.0)),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
        ),
        margin: const EdgeInsets.only(left: 14),
        padding: const EdgeInsets.only(left: 12, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: Text(
                'Notifications Center',
                style: tsS21W600CFF,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Recent',
                            style: tsS18W500CFF,
                          ),
                        ),
                        InkWell(
                          onTap: onClearTap,
                          child: Container(
                            width: 31,
                            height: 28,
                            decoration: BoxDecoration(
                              color: color8BA1BE.withOpacity(0.30),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.all(8),
                            child: SvgPicture.asset('clean'.asAssetSvg()),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 9),
                    Consumer<NotificationDrawerProvider>(
                      builder: (context, provider, child) => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: provider.recentList
                            .map(
                              (model) => buildInkWell(
                                child: _ThisNotifItemWidget(
                                    svgItem: model.svgAsset,
                                    title: model.title,
                                    description: model.description,
                                    opacity: model.isSeen ? 0.5 : 1.0),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => NotifDepositScreen(
                                        screenType: model.enumType ==
                                                EnumDrawerNotificationTypes
                                                    .TransactionWithdraw
                                            ? EnumDepositScreenTypes.Withdraw
                                            : EnumDepositScreenTypes.Deposit,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    SizedBox(height: 20),
                    Opacity(
                      opacity: 0.50,
                      child: Text('20 February, 2021', style: tsS18W500CFF),
                    ),
                    SizedBox(height: 11),
                    Consumer<NotificationDrawerProvider>(
                      builder: (context, provider, child) => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: provider.oldList
                            .map((model) => InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NotifDetailsScreen()));
                                  },
                                  child: _ThisNotifItemWidget(
                                    svgItem: model.svgAsset,
                                    title: model.title,
                                    description: model.description,
                                    opacity: model.isSeen ? 0.5 : 1.0,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThisNotifItemWidget extends StatelessWidget {
  final String svgItem;
  final String title;
  final String description;
  final double opacity;
  const _ThisNotifItemWidget({
    required this.svgItem,
    required this.title,
    required this.description,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        decoration: BoxDecoration(
          color: color2E303C,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [bsDefault],
        ),
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
        margin: const EdgeInsets.only(bottom: 11),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              padding: const EdgeInsets.all(9),
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: color8BA1BE.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(svgItem),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    style: tsS14W500CFF,
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: tsS13W400CFFOP60.copyWith(height: 1.25),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
