import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/features/app_settings_info/providers/my_account_provider.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/build_methods.dart';
import 'package:polkadex/common/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';

/// XD_PAGE: 41
class MyAccountScreen extends StatelessWidget {
  final _isCheckedNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyAccountProfileProvider>(
            create: (_) => MyAccountProfileProvider()),
        ChangeNotifierProvider<MyAccountEditNameProvider>(
            create: (_) => MyAccountEditNameProvider()),
      ],
      builder: (context, _) => Scaffold(
        backgroundColor: color1C2023,
        body: SafeArea(
          child: CustomAppBar(
            onTapBack: () => Navigator.of(context).pop(),
            title: 'App Settings',
            child: Container(
              decoration: BoxDecoration(
                color: color1C2023,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 25, 20, 17),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Kas Pintxuki',
                                  style: tsS20W600CFF,
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
                              context
                                  .read<MyAccountProfileProvider>()
                                  .pickImgFile();
                            },
                            child: SizedBox(
                              width: 56,
                              height: 56,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 4,
                                    right: 4,
                                    bottom: 0,
                                    child: Consumer<MyAccountProfileProvider>(
                                      builder: (context, provider, child) {
                                        if (provider.hasImg) {
                                          return CircleAvatar(
                                            backgroundImage: FileImage(
                                                File(provider.imgFile)),
                                          );
                                        }
                                        return Image.asset(
                                          'user_avatar.png'.asAssetImg(),
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Image.asset(
                                      'edit.png'.asAssetImg(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: color2E303C,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 29, 16, 45),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          buildInkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              FlutterClipboard.copy('18592080').then((value) =>
                                  buildAppToast(
                                      msg:
                                          'The referral id is copied to the clipboard',
                                      context: context));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.20),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 23, horizontal: 28),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Referral ID',
                                    style: tsS13W400CFFOP60,
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    '18592080',
                                    style: tsS16W500CFF,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.20),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.fromLTRB(28, 23, 16, 23),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'Account Name',
                                        style: tsS13W400CFFOP60,
                                      ),
                                      SizedBox(height: 2),
                                      Consumer<MyAccountEditNameProvider>(
                                        builder: (context, provider, child) {
                                          if (provider.canEditName) {
                                            return TextField(
                                              controller: provider.controller,
                                              autofocus: true,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.zero,
                                                border: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                                focusedErrorBorder:
                                                    InputBorder.none,
                                                isDense: true,
                                              ),
                                              cursorColor: colorE6007A,
                                              style: tsS16W500CFF,
                                            );
                                          }

                                          return Text(
                                            provider.name,
                                            style: tsS16W500CFF,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    final provider = context
                                        .read<MyAccountEditNameProvider>();
                                    if (provider.canEditName) {
                                      provider.onSave();
                                    } else {
                                      provider.canEditName = true;
                                    }
                                  },
                                  child: AnimatedContainer(
                                    duration: AppConfigs.animDurationSmall,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: color8BA1BE.withOpacity(0.20),
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                    padding: const EdgeInsets.all(9),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'edit'.asAssetSvg(),
                                          fit: BoxFit.fitHeight,
                                        ),
                                        Consumer<MyAccountEditNameProvider>(
                                          builder: (context, provider, child) {
                                            if (provider.canEditName) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4.0),
                                                child: Text(
                                                  "Save",
                                                  style: tsS11W600CFF,
                                                ),
                                              );
                                            }
                                            return Container();
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 42),
                          Row(
                            children: [
                              Container(
                                width: 47,
                                height: 47,
                                decoration: BoxDecoration(
                                  color: color8BA1BE.withOpacity(0.20),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(11.5),
                                child: SvgPicture.asset(
                                    'deposit_download'.asAssetSvg()),
                              ),
                              SizedBox(width: 11.4),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Use DEX to pay fees',
                                      style: tsS16W400CFF,
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Enjoy 25% discount when trading.',
                                      style: tsS13W400CFFOP60,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 11.4),
                              SizedBox(
                                width: 48,
                                height: 48,
                                child: FittedBox(
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable: _isCheckedNotifier,
                                    builder: (context, value, child) => Switch(
                                      value: value,
                                      onChanged: (val) {
                                        _isCheckedNotifier.value = val;
                                      },
                                      inactiveTrackColor:
                                          Colors.white.withOpacity(0.15),
                                      activeColor: colorABB2BC,
                                      activeTrackColor:
                                          Colors.white.withOpacity(0.15),
                                      inactiveThumbColor: colorE6007A,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 36, bottom: 36),
                            child: Divider(
                              height: 1,
                              color: Colors.white10,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Current trading fee',
                                  style: tsS16W400CFF.copyWith(
                                    color: colorFFFFFF.withOpacity(0.5),
                                  ),
                                ),
                              ),
                              Text(
                                '0.02%',
                                style: tsS16W400CFF,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.125,
                        28,
                        MediaQuery.of(context).size.width * 0.125,
                        36,
                      ),
                      child: Text(
                        'Polkadex does not store any data , this is just a temporary data, if you uninstall the Polkadex App your name and referral ID will be removed.',
                        style: tsS14W400CFF,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
