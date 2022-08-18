import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/loading_dots_widget.dart';

class LoadingOverlay {
  OverlayEntry? _overlay;

  bool get isActive => _overlay != null;

  void show({
    required BuildContext context,
    required String text,
  }) {
    if (_overlay == null) {
      _overlay = OverlayEntry(
        builder: (context) => ColoredBox(
          color: Color(0x80000000),
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
                  Stack(
                    children: [
                      Image.asset(
                        'loading_icon.png'.asAssetImg(),
                        fit: BoxFit.scaleDown,
                      ),
                      Positioned(
                        right: 0.0,
                        bottom: 10.0,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.color6745d2,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: LoadingDotsWidget(
                              dotSize: 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      text,
                      style: tsS20W500CFF,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 33),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: LinearProgressIndicator(
                        minHeight: 9,
                        color: AppColors.colorE6007A,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      Overlay.of(context)?.insert(_overlay!);
    }
  }

  void hide() {
    _overlay?.remove();
    _overlay = null;
  }
}
