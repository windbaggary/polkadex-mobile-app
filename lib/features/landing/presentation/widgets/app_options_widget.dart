import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';

class AppOptionsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.color1C2023,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Theme(
        data: currentTheme.copyWith(
          canvasColor: currentTheme.colorScheme.primary,
          splashColor: currentTheme.colorScheme.background,
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
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(40),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
    );
  }

  Widget _buildHeading({required String label}) => Padding(
        padding: const EdgeInsets.only(top: 49, bottom: 2),
        child: Text(
          label,
          style: tsS16W500CABB2BC,
        ),
      );

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

class _ThisProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 32,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SvgPicture.asset(
              'logo_name'.asAssetSvg(),
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
            ),
          ),
          SizedBox(width: 16),
          InkWell(
            onTap: () async => await context.read<AccountCubit>().logout(),
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
