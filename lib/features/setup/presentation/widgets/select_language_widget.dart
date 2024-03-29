import 'package:biometric_storage/biometric_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/loading_popup.dart';
import 'package:polkadex/generated/l10n.dart';

class SelectLanguageWidget extends StatefulWidget {
  @override
  _SelectLanguageWidgetState createState() => _SelectLanguageWidgetState();
}

class _SelectLanguageWidgetState extends State<SelectLanguageWidget> {
  List<Widget> _buildLanguageListWidget() {
    List<Locale> locales = S.delegate.supportedLocales;

    return List<Widget>.generate(
      locales.length,
      (index) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () async {
              LoadingPopup.show(
                context: context,
                text: 'Changing the language...',
              );

              final languageStorage =
                  await BiometricStorage().getStorage('language',
                      options: StorageFileInitOptions(
                        authenticationRequired: false,
                      ));
              await languageStorage.write(locales[index].toString());

              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                children: [
                  Text(
                    LocaleNames.of(context)!.nameOf(locales[index].toString())!,
                    style: tsS18W600CFF,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.colorFFFFFF,
                        size: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: AppColors.color8BA1BE.withOpacity(0.20),
            height: 1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.4,
      minChildSize: 0.4,
      maxChildSize: 0.8,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.color2E303C,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.colorFFFFFF,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 51,
                  height: 3,
                ),
              ),
              Expanded(
                child: ListView(
                  physics: ClampingScrollPhysics(),
                  controller: scrollController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Choose a language',
                              style: tsS26W600CFF,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 21),
                            child: Text(
                              'Select the language you would like to use while running Polkadex Mobile App',
                              style: tsS18W400CFF,
                            ),
                          ),
                          Column(
                            children: _buildLanguageListWidget(),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
