import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/configs/app_config.dart';

class WarningModalWidget extends StatefulWidget {
  WarningModalWidget({
    required this.title,
    this.subtitle,
    this.imagePath,
    this.details,
  });

  final String title;
  final String? subtitle;
  final String? imagePath;
  final String? details;

  @override
  _WarningModalWidgetState createState() => _WarningModalWidgetState();
}

class _WarningModalWidgetState extends State<WarningModalWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _expandController;
  late Animation<double> _animation;
  bool _isDetailsDisplayed = false;

  @override
  void initState() {
    super.initState();
    _prepareAnimations();
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _prepareAnimations() {
    _expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _evalDetailsPressed() {
    _isDetailsDisplayed = !_isDetailsDisplayed;

    if (_isDetailsDisplayed) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

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
            physics: ClampingScrollPhysics(),
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
                        widget.title,
                        style: tsS26W600CFF,
                      ),
                    ),
                    Text(
                      widget.subtitle ?? '',
                      style: tsS18W400C93949A,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical:
                              widget.imagePath != null || widget.details != null
                                  ? 28
                                  : 14),
                      child: Visibility(
                        visible:
                            widget.imagePath != null || widget.details != null,
                        child: GestureDetector(
                          onTap: () => setState(() => _evalDetailsPressed()),
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
                      ),
                    ),
                    SizeTransition(
                      axisAlignment: 1.0,
                      sizeFactor: _animation,
                      child: Column(
                        children: [
                          if (widget.imagePath != null)
                            Image.asset(
                              widget.imagePath!,
                              fit: BoxFit.contain,
                            ),
                          if (widget.details != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 26),
                              child: Text(
                                widget.details ?? '',
                                style: tsS18W400CFF,
                              ),
                            )
                        ],
                      ),
                    )
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
