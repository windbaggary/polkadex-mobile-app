import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/configs/app_config.dart';

class IncorrectMnemonicWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: AppConfigs.size!.height * 0.8),
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: colorE6007A),
                      width: 60,
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: SvgPicture.asset(
                          'warning'.asAssetSvg(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Incorrect mnemonic phrase',
                        style: tsS26W600CFF,
                      ),
                    ),
                    Text(
                      'Please enter again.',
                      style: tsS18W400C93949A,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Icon(
                              Icons.arrow_downward,
                              color: colorFFFFFF,
                            ),
                          ),
                          Text(
                            'More details',
                            style: tsS16W400CFF,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 26,
                      ),
                      child: Text(
                        'One or more of your 12-24 words are incorrect, make sure that the order is correct or if there is a typing error.',
                        style: tsS18W400CFF,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
