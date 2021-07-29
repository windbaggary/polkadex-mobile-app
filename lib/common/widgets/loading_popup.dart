import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';

abstract class LoadingPopup {
  static void show({
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 61),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'loading_icon.png'.asAssetImg(),
                    fit: BoxFit.scaleDown,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'We are almost there...',
                      style: tsS20W500CFF,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 33),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: LinearProgressIndicator(
                        minHeight: 9,
                        color: colorE6007A,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
