import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';

class SelectCountryWidget extends StatefulWidget {
  @override
  _SelectCountryWidgetState createState() => _SelectCountryWidgetState();
}

class _SelectCountryWidgetState extends State<SelectCountryWidget> {
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
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 24),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: Flag.fromString(
                                            'br',
                                            width: 24,
                                            height: 16,
                                          ),
                                        ),
                                        SizedBox(width: 18),
                                        Text(
                                          'Brazil',
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
                                  Divider(
                                    color: color8BA1BE.withOpacity(0.20),
                                    height: 1,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 24),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: Flag.fromString(
                                            'gb',
                                            width: 24,
                                            height: 16,
                                          ),
                                        ),
                                        SizedBox(width: 18),
                                        Text(
                                          'England',
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
                                  Divider(
                                    color: color8BA1BE.withOpacity(0.20),
                                    height: 1,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 24),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: Flag.fromString(
                                            'es',
                                            width: 24,
                                            height: 16,
                                          ),
                                        ),
                                        SizedBox(width: 18),
                                        Text(
                                          'Estonia',
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
                                  Divider(
                                    color: color8BA1BE.withOpacity(0.20),
                                    height: 1,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 24),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: Flag.fromString(
                                            'in',
                                            width: 24,
                                            height: 16,
                                          ),
                                        ),
                                        SizedBox(width: 18),
                                        Text(
                                          'India',
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
                                  Divider(
                                    color: color8BA1BE.withOpacity(0.20),
                                    height: 1,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 24),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: Flag.fromString(
                                            'jp',
                                            width: 24,
                                            height: 16,
                                          ),
                                        ),
                                        SizedBox(width: 18),
                                        Text(
                                          'Japan',
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
                                  Divider(
                                    color: color8BA1BE.withOpacity(0.20),
                                    height: 1,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 24),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: Flag.fromString(
                                            'no',
                                            width: 24,
                                            height: 16,
                                          ),
                                        ),
                                        SizedBox(width: 18),
                                        Text(
                                          'Norway',
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
                                  Divider(
                                    color: color8BA1BE.withOpacity(0.20),
                                    height: 1,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 24),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: Flag.fromString(
                                            'tr',
                                            width: 24,
                                            height: 16,
                                          ),
                                        ),
                                        SizedBox(width: 18),
                                        Text(
                                          'Turkey',
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
                                  Divider(
                                    color: color8BA1BE.withOpacity(0.20),
                                    height: 1,
                                  ),
                                ],
                              )
                            ],
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
