import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/cubits/account_cubit.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/features/landing/presentation/providers/notification_drawer_provider.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/build_methods.dart';
import 'package:provider/provider.dart';

/// The left drawer width
const double appDrawerWidth = 300;

/// The right drawer width
double getAppDrawerNotifWidth() {
  // double ratio = 0.300;
  // if (Platform.isIOS) {
  // ratio = 0.750;
  // }
  // return math.min<double>(AppConfigs.size.width * ratio, 350.0);
  return AppConfigs.size.width - 40;
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
        splashColor: AppColors.color1C2023,
        hoverColor: AppColors.color1C2023,
        highlightColor: AppColors.color1C2023,
        focusColor: AppColors.color1C2023,
        buttonTheme: ButtonThemeData(buttonColor: AppColors.color1C2023),
      ),
      child: SizedBox(
        height: double.infinity,
        width: appDrawerWidth,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.color2E303C.withOpacity(0.30),
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
                        color: AppColors.color2E303C,
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
      case EnumDrawerAppSettings.notifications:
        Coordinator.goToAppSettingsNotificationScreen();
        break;
      case EnumDrawerAppSettings.appearance:
        Coordinator.goToAppSettingsAppearanceScreen();
        break;
      case EnumDrawerAppSettings.languageCurrency:
        Coordinator.goToAppSettingsLangCurrScreen();
        break;
      case EnumDrawerAppSettings.privacySecurtiy:
        Coordinator.goToAppSettingsSecurityScreen();
        break;
      case EnumDrawerAppSettings.myAccount:
        Coordinator.goToMyAccountScreen();
        break;
    }
  }

  /// Builds the widget for the app setting item
  /// The method also handle onTap event
  Widget _buildAppSettingsItem(EnumDrawerAppSettings e) {
    String svg;
    String label;

    switch (e) {
      case EnumDrawerAppSettings.notifications:
        svg = 'drawer_notification'.asAssetSvg();
        label = 'Notifications';
        break;
      case EnumDrawerAppSettings.appearance:
        svg = 'drawer_toggle'.asAssetSvg();
        label = 'Appearance';
        break;
      case EnumDrawerAppSettings.languageCurrency:
        svg = 'drawer_flag'.asAssetSvg();
        label = 'Language & Currency';
        break;
      case EnumDrawerAppSettings.privacySecurtiy:
        svg = 'drawer_finger-print'.asAssetSvg();
        label = 'Privacy & Security';
        break;
      case EnumDrawerAppSettings.myAccount:
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
      case EnumDrawerAppInfo.termsConditions:
        label = 'Terms and Conditions';
        svg = 'drawer_terms'.asAssetSvg();
        break;
      case EnumDrawerAppInfo.privacyPolicy:
        label = 'Privacy Policy';
        svg = 'drawer_privacy'.asAssetSvg();
        break;
      case EnumDrawerAppInfo.helpSupport:
        label = 'Help & Support';
        svg = 'drawer_chat'.asAssetSvg();
        break;
      case EnumDrawerAppInfo.changeLog:
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
      case EnumDrawerAppInfo.termsConditions:
        Coordinator.goToTermsConditionsScreen();
        break;
      case EnumDrawerAppInfo.privacyPolicy:
        Coordinator.goToPrivacyPolicyScreen();
        break;
      case EnumDrawerAppInfo.helpSupport:
        Coordinator.goToAppSettingsHelpScreen();
        break;
      case EnumDrawerAppInfo.changeLog:
        Coordinator.goToAppSettingsChangeLogsScreen();
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
          SvgPicture.asset(
            'drawer_avatar'.asAssetSvg(),
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
                  context.read<AccountCubit>().accountName,
                  style: tsS21W600CFF,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              await context.read<AccountCubit>().logout();
              Coordinator.goToIntroScreen();
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
                color: AppColors.color8BA1BE.withOpacity(0.20),
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
          color: AppColors.color2E303C.withOpacity(0.30),
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
                              color: AppColors.color8BA1BE.withOpacity(0.30),
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
                                onTap: () => Coordinator.goToNotifDepositScreen(
                                  enumDepositScreenTypes: model.enumType ==
                                          EnumDrawerNotificationTypes
                                              .transactionWithdraw
                                      ? EnumDepositScreenTypes.withdraw
                                      : EnumDepositScreenTypes.deposit,
                                ),
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
                                  onTap: () =>
                                      Coordinator.goToNotifDetailsScreen(),
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
          color: AppColors.color2E303C,
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
                color: AppColors.color8BA1BE.withOpacity(0.2),
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
