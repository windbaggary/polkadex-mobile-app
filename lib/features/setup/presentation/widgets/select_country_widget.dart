import 'package:country_codes/country_codes.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/generated/l10n.dart';

class SelectCountryWidget extends StatefulWidget {
  @override
  _SelectCountryWidgetState createState() => _SelectCountryWidgetState();
}

class _SelectCountryWidgetState extends State<SelectCountryWidget> {
  List<Widget> _buildCountryListWidget() {
    List<Locale> locales = S.delegate.supportedLocales
        .where((locale) =>
            locale.countryCode != null && locale.countryCode!.isNotEmpty)
        .toList();

    return List<Widget>.generate(
      locales.length,
      (index) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () {}, //TODO: Implement country store
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Flag.fromString(
                      locales[index].countryCode!,
                      width: 24,
                      height: 16,
                    ),
                  ),
                  SizedBox(width: 18),
                  Text(
                    CountryCodes.detailsForLocale(locales[index])
                        .localizedName!,
                    style: tsS18W600CFF,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: colorFFFFFF,
                        size: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (index + 1 < locales.length)
            Divider(
              color: color8BA1BE.withOpacity(0.20),
              height: 1,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _buildCountryListWidget();
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.4,
      minChildSize: 0.4,
      maxChildSize: 0.8,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: color2E303C,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorFFFFFF,
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
                              'Select your country',
                              style: tsS26W600CFF,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 21),
                            child: Text(
                              'In some countries, due legal restrictions, some functionalities are not available or are limited.',
                              style: tsS18W400CFF,
                            ),
                          ),
                          Column(
                            children: _buildCountryListWidget(),
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
