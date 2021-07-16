import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/configs/app_config.dart';
import 'package:polkadex/utils/colors.dart';
import 'package:polkadex/utils/extensions.dart';
import 'package:polkadex/utils/styles.dart';
import 'package:polkadex/widgets/app_horizontal_slider.dart';
import 'package:polkadex/widgets/app_slide_button.dart';
import 'package:polkadex/widgets/build_methods.dart';
import 'package:polkadex/widgets/qr_code_screen.dart';
import 'package:provider/provider.dart';

/// XD_PAGE: 21
/// XD_PAGE: 28
class CoinWithdrawScreen extends StatefulWidget {
  @override
  _CoinWithdrawScreenState createState() => _CoinWithdrawScreenState();
}

class _CoinWithdrawScreenState extends State<CoinWithdrawScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _ThisProvider(),
      builder: (context, _) => Scaffold(
          backgroundColor: color1C2023,
          body: SafeArea(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: color2E303C,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildAppbar(context),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: color1C2023,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(35),
                                topLeft: Radius.circular(35),
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Container(
                                // height:
                                //     MediaQuery.of(context).size.height - 120,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    _ThisCoinTitleWidget(),
                                    _ThisAmountWidget(),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          22, 40, 24, 0),
                                      child: Consumer<_ThisProvider>(
                                        builder: (context, thisProvider, _) {
                                          return AppHorizontalSlider(
                                            bgColor: const Color(0xFF313236),
                                            activeColor: colorE6007A,
                                            initialProgress:
                                                thisProvider.progress,
                                            onProgressUpdate: (progress) {
                                              thisProvider.progress = progress;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          22, 26, 22, 0.0),
                                      padding: const EdgeInsets.fromLTRB(
                                          27, 14, 13, 13),
                                      decoration: BoxDecoration(
                                        color: colorFFFFFF.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: <BoxShadow>[bsDefault],
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              style: tsS16W500CFF,
                                              decoration: InputDecoration(
                                                isDense: true,
                                                contentPadding: EdgeInsets.zero,
                                                hintText: 'Enter Dex address',
                                                hintStyle:
                                                    tsS16W500CFF.copyWith(
                                                  color: colorFFFFFF
                                                      .withOpacity(0.5),
                                                ),
                                                border: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                                focusedErrorBorder:
                                                    InputBorder.none,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 43,
                                            height: 43,
                                            padding: const EdgeInsets.all(12),
                                            child: SvgPicture.asset(
                                                'contacts'.asAssetSvg()),
                                          ),
                                          buildInkWell(
                                            onTap: () => _onTapQR(context),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Container(
                                              width: 43,
                                              height: 43,
                                              decoration: BoxDecoration(
                                                color: color8BA1BE
                                                    .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              padding: const EdgeInsets.all(12),
                                              child: SvgPicture.asset(
                                                  'scan'.asAssetSvg()),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          22, 18, 22, 20.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 18),
                                            padding: const EdgeInsets.fromLTRB(
                                              27,
                                              9,
                                              22,
                                              9,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  colorFFFFFF.withOpacity(0.05),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: <BoxShadow>[bsDefault],
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 100,
                                                  child: DropdownButton<String>(
                                                    items: [
                                                      'DOT Chain',
                                                      'DOT 1',
                                                      'DOT 2'
                                                    ]
                                                        .map((e) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                              child: Text(
                                                                e,
                                                                style:
                                                                    tsS16W600CFF,
                                                              ),
                                                              value: e,
                                                            ))
                                                        .toList(),
                                                    value: 'DOT Chain',
                                                    style: tsS16W600CFF,
                                                    underline: Container(),
                                                    onChanged: (val) {},
                                                    isExpanded: true,
                                                    icon: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 0.0),
                                                      child: Icon(
                                                        Icons
                                                            .keyboard_arrow_down_rounded,
                                                        color: colorFFFFFF,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Withdraw Fee',
                                                    style: tsS13W400CFFOP60
                                                        .copyWith(
                                                            color: colorFFFFFF
                                                                .withOpacity(
                                                                    0.5)),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    '0.012 DEX / \$0.02',
                                                    style: tsS15W600CFF,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Consumer<_ThisProvider>(
                                      builder: (context, provider, _) {
                                        double height = 0;
                                        if (!provider.isKeyboardVisible) {
                                          height = (10 *
                                                  (MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      759.27272727))
                                              .clamp(0.0, double.infinity);
                                        }
                                        return AnimatedSize(
                                          duration:
                                              AppConfigs.animDurationSmall,
                                          vsync: this,
                                          child: SizedBox(
                                            height: height,
                                          ),
                                        );
                                      },
                                    ),
                                    Consumer<_ThisProvider>(
                                      builder: (context, provider, _) =>
                                          AnimatedPadding(
                                        duration: AppConfigs.animDurationSmall,
                                        padding: EdgeInsets.fromLTRB(
                                          21,
                                          0.0,
                                          21.0,
                                          provider.isKeyboardVisible
                                              ? 400.0
                                              : 0.0,
                                        ),
                                        child: AppSlideButton(
                                          height: 60,
                                          onComplete: () {},
                                          label: 'Slide to withdraw',
                                          icon: Container(
                                            decoration: BoxDecoration(
                                              color: color1C2023,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            padding: const EdgeInsets.all(14),
                                            width: 45,
                                            height: 45,
                                            child: SvgPicture.asset(
                                              'arrow'.asAssetSvg(),
                                              fit: BoxFit.contain,
                                              color: colorFFFFFF,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            color: colorE6007A,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Consumer<_ThisProvider>(
                  builder: (context, provider, child) => Positioned.fill(
                    child: IgnorePointer(
                      ignoring: !provider.isKeyboardVisible,
                      child: GestureDetector(
                          onTap: () {
                            provider.isKeyboardVisible = false;
                          },
                          child: Container(
                            color: Colors.transparent,
                          )),
                    ),
                  ),
                ),
                Consumer<_ThisProvider>(
                  builder: (context, provider, _) => AnimatedPositioned(
                    duration: AppConfigs.animDurationSmall,
                    left: 0.0,
                    right: 0.0,
                    bottom: provider.isKeyboardVisible ? 0.0 : -400.0,
                    child: AppCustomKeyboard(
                      onSwapTapped: () => _onSwapTapped(context),
                      onKeypadNumberTapped: (number) =>
                          context.read<_ThisProvider>().setUnitEntered(number),
                      onEnterTapped: () => context
                          .read<_ThisProvider>()
                          .isKeyboardVisible = false,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  /// The app bar for the screen
  Widget _buildAppbar(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 16, top: 8),
        child: Row(
          children: [
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: SizedBox(
                width: 50,
                height: 50,
                child: Icon(
                  Icons.close,
                  color: colorFFFFFF,
                ),
              ),
            ),
            Expanded(
              child: Text(
                "Withdraw Polkadex (DEX)",
                style: tsS19W700CFF,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 50),
          ],
        ),
      );

  /// Navigate to QR code scanner screen and returns the data in navigator result
  void _onTapQR(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => QRCodeScanScreen()));
  }

  /// The method to toggle the keyboard
  void _onSwapTapped(BuildContext context) {
    context.read<_ThisProvider>().onSwap();
  }
}

class _ThisAmountWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<_ThisProvider>().isKeyboardVisible = true;
      },
      child: Padding(
        padding: const EdgeInsets.only(
          top: 56,
          left: 21,
          right: 21,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Consumer<_ThisProvider>(
              builder: (context, provider, child) => Text(
                provider.topValue,
                style: tsS31W500CFF,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 4),
            Consumer<_ThisProvider>(
              builder: (context, provider, child) => Text(
                '~${provider.bottomValue}',
                style: tsS15W400CFFOP50,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Enter amount',
              style: tsS16W400CFF.copyWith(
                color: Colors.white.withOpacity(0.50),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ThisCoinTitleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(21, 40, 21, 0.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: colorFFFFFF,
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(right: 11),
            padding: const EdgeInsets.all(5),
            width: 51,
            height: 51,
            child: Image.asset(
              'trade_open/trade_open_2.png'.asAssetImg(),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Available',
                  style: tsS16W400CFF.copyWith(
                    color: colorFFFFFF.withOpacity(0.50),
                  ),
                ),
                SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '1.5000 DEX ',
                        style: tsS17W600C0CA564.copyWith(color: colorFFFFFF),
                      ),
                      TextSpan(
                        text: '\$31.25',
                        style: tsS17W600C0CA564.copyWith(
                          color: colorFFFFFF.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

/// The provider handles the events on the screen. Coin conversion keyboard, etc
class _ThisProvider extends ChangeNotifier {
  final double _availableAmount = 31.25;
  final double _availableUnit = 1.5;
  bool _isSwap = false;

  double _progress = 0.0;
  String _unit = "0", _amount = "0";
  bool _isKeyboardVisible = false;

  bool get isKeyboardVisible => _isKeyboardVisible;
  double get progress => _progress;

  set progress(double val) {
    _progress = val;
    _amount = (_availableAmount * val).toStringAsFixed(2);
    _unit = (_availableUnit * val).toStringAsFixed(2);
    notifyListeners();
  }

  set isKeyboardVisible(bool val) {
    _isKeyboardVisible = val;
    notifyListeners();
  }

  String get unit => _unit;

  String get amount => "\$$_amount";

  String get topValue {
    if (_isSwap) {
      return amount;
    } else {
      return unit;
    }
  }

  String get bottomValue {
    if (_isSwap) {
      return unit;
    } else {
      return amount;
    }
  }

  void onSwap() {
    _isSwap = !_isSwap;
    notifyListeners();
  }

  void setUnitEntered(_EnumKeypadNumbers val) {
    String enteredString = _unit;
    if (_isSwap) {
      enteredString = _amount;
    }
    if (enteredString == "0") {
      enteredString = "";
    }
    switch (val) {
      case _EnumKeypadNumbers.one:
        enteredString += "1";
        break;
      case _EnumKeypadNumbers.two:
        enteredString += "2";

        break;
      case _EnumKeypadNumbers.three:
        enteredString += "3";

        break;
      case _EnumKeypadNumbers.four:
        enteredString += "4";

        break;
      case _EnumKeypadNumbers.five:
        enteredString += "5";

        break;
      case _EnumKeypadNumbers.six:
        enteredString += "6";

        break;
      case _EnumKeypadNumbers.seven:
        enteredString += "7";

        break;
      case _EnumKeypadNumbers.eight:
        enteredString += "8";

        break;
      case _EnumKeypadNumbers.nine:
        enteredString += "9";

        break;
      case _EnumKeypadNumbers.zero:
        enteredString += "0";

        break;
      case _EnumKeypadNumbers.dot:
        enteredString += ".";
        if (enteredString.length == 1) {
          enteredString = "0.";
        }

        break;
      case _EnumKeypadNumbers.back:
        if (enteredString.isEmpty) break;
        if (enteredString.isNotEmpty) {
          enteredString = enteredString.substring(0, enteredString.length - 1);
        }
        break;
    }
    try {
      enteredString = (enteredString.isEmpty) ? "0" : enteredString;
      print(enteredString);
      final double? valInDouble = double.tryParse(enteredString);

      if (_isSwap) {
        _progress = (valInDouble! / _availableAmount).clamp(0.0, 1.0);

        _amount = enteredString;
        _unit = (_availableUnit * _progress).toStringAsFixed(2);
      } else {
        _progress = (valInDouble! / _availableUnit).clamp(0.0, 1.0);

        _unit = enteredString;
        _amount = (_availableAmount * _progress).toStringAsFixed(2);
      }
    } catch (ex) {
      print(ex);
    }
    notifyListeners();
  }
}

enum _EnumKeypadNumbers {
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  zero,
  dot,
  back,
}

typedef _OnKeypadNumberTapped = void Function(_EnumKeypadNumbers number);

class AppCustomKeyboard extends StatefulWidget {
  final VoidCallback? onEnterTapped;
  final VoidCallback? onSwapTapped;
  final _OnKeypadNumberTapped onKeypadNumberTapped;
  const AppCustomKeyboard({
    this.onEnterTapped,
    this.onSwapTapped,
    required this.onKeypadNumberTapped,
  });

  @override
  AppCustomKeyboardState createState() => AppCustomKeyboardState();
}

class AppCustomKeyboardState extends State<AppCustomKeyboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color2E303C,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 19,
        vertical: 17,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      3,
                      (index) => Expanded(
                        child: InkWell(
                          onTap: () => widget.onKeypadNumberTapped(
                              _EnumKeypadNumbers.values[index]),
                          child: _ThisNumberItemWidget(
                            number: (index + 1).toString(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(
                      3,
                      (index) => Expanded(
                        child: InkWell(
                          onTap: () => widget.onKeypadNumberTapped(
                              _EnumKeypadNumbers.values[index + 3]),
                          child: _ThisNumberItemWidget(
                            number: (index + 1 + 3).toString(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: List.generate(
                      3,
                      (index) => Expanded(
                        child: InkWell(
                          onTap: () => widget.onKeypadNumberTapped(
                              _EnumKeypadNumbers.values[index + 6]),
                          child: _ThisNumberItemWidget(
                            number: (index + 1 + 6).toString(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => widget
                              .onKeypadNumberTapped(_EnumKeypadNumbers.dot),
                          child: _ThisNumberItemWidget(
                            number: '.',
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => widget
                              .onKeypadNumberTapped(_EnumKeypadNumbers.zero),
                          child: _ThisNumberItemWidget(
                            number: '0',
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => widget
                              .onKeypadNumberTapped(_EnumKeypadNumbers.back),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: SizedBox(
                              width: 26,
                              height: 20,
                              child: Icon(
                                Icons.backspace,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            IntrinsicWidth(
              child: Column(
                children: [
                  InkWell(
                    onTap: widget.onSwapTapped,
                    child: Container(
                      decoration: BoxDecoration(
                        color: color1C2023,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: <BoxShadow>[bsDefault],
                      ),
                      padding: const EdgeInsets.fromLTRB(11, 15, 11, 14),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: colorFFFFFF,
                              borderRadius: BorderRadius.circular(11),
                            ),
                            padding: const EdgeInsets.all(2.5),
                            width: 26,
                            height: 26,
                            child: Image.asset(
                              'trade_open/trade_open_2.png'.asAssetImg(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 11),
                            child: SvgPicture.asset(
                              'arrow-2'.asAssetSvg(),
                              width: 20,
                              height: 13,
                            ),
                          ),
                          Opacity(
                            opacity: 0.20,
                            child: Container(
                              decoration: BoxDecoration(
                                color: color8BA1BE,
                                borderRadius: BorderRadius.circular(11),
                              ),
                              padding: const EdgeInsets.all(8),
                              width: 26,
                              height: 26,
                              child: SvgPicture.asset(
                                'fiat'.asAssetSvg(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: InkWell(
                      onTap: widget.onEnterTapped,
                      child: AspectRatio(
                        aspectRatio: 118 / 150,
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorE6007A,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: <BoxShadow>[bsDefault],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Enter',
                            style:
                                tsS17W600C0CA564.copyWith(color: colorFFFFFF),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThisNumberItemWidget extends StatelessWidget {
  final String number;

  const _ThisNumberItemWidget({required this.number});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        number,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 30,
          fontWeight: FontWeight.w400,
          color: colorFFFFFF,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
