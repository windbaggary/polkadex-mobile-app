import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/cubits/account_cubit.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/math_utils.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_horizontal_slider.dart';
import 'package:polkadex/common/widgets/app_slide_button.dart';
import 'package:polkadex/common/widgets/build_methods.dart';
import 'package:polkadex/features/coin/presentation/cubits/withdraw_cubit.dart';
import 'package:polkadex/common/widgets/loading_dots_widget.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
import 'package:polkadex/features/landing/utils/token_utils.dart';
import 'package:provider/provider.dart';
import 'package:polkadex/injection_container.dart';
import 'package:shimmer/shimmer.dart';

/// XD_PAGE: 21
/// XD_PAGE: 28
class CoinWithdrawScreen extends StatefulWidget {
  const CoinWithdrawScreen({
    required this.tokenId,
  });

  final String tokenId;

  @override
  _CoinWithdrawScreenState createState() => _CoinWithdrawScreenState();
}

class _CoinWithdrawScreenState extends State<CoinWithdrawScreen>
    with TickerProviderStateMixin {
  final TextEditingController _addressController = TextEditingController();
  final double _conversionRate = 20.0;
  bool _areAmountUnitsSwapped = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => dependency<WithdrawCubit>()
        ..init(
          amountFree: 0.0,
          amountToBeWithdrawn: 0.0,
          amountDisplayed: '',
          address: '',
        ),
      child: ChangeNotifierProvider(
        create: (_) => _ThisProvider(),
        builder: (context, _) => Scaffold(
          backgroundColor: AppColors.color1C2023,
          body: BlocBuilder<BalanceCubit, BalanceState>(
            builder: (context, balanceState) {
              if (balanceState is BalanceLoaded) {
                context.read<WithdrawCubit>().updateWithdrawParams(
                    amountFree:
                        double.parse(balanceState.free[widget.tokenId] ?? '0'));
              }

              return BlocConsumer<WithdrawCubit, WithdrawState>(
                listener: (context, withdrawState) {
                  if (withdrawState is WithdrawSuccess) {
                    buildAppToast(msg: withdrawState.message, context: context);
                  }

                  if (withdrawState is WithdrawError) {
                    buildAppToast(
                        msg:
                            '${TokenUtils.tokenIdToAcronym(widget.tokenId)} withdraw failed. Please try again',
                        context: context);
                  }
                },
                builder: (context, withdrawState) {
                  return SafeArea(
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.color2E303C,
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
                                      color: AppColors.color1C2023,
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
                                            _ThisCoinTitleWidget(
                                              tokenId: widget.tokenId,
                                              amount: withdrawState.amountFree,
                                              areUnitsSwapped:
                                                  _areAmountUnitsSwapped,
                                              conversionRate: _conversionRate,
                                              isLoaded:
                                                  balanceState is BalanceLoaded,
                                            ),
                                            _ThisAmountWidget(
                                              amount: withdrawState
                                                  .amountToBeWithdrawn,
                                              amountDisplayed: context
                                                  .read<WithdrawCubit>()
                                                  .state
                                                  .amountDisplayed,
                                              conversionRate: _conversionRate,
                                              areUnitsSwapped:
                                                  _areAmountUnitsSwapped,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      22, 40, 24, 0),
                                              child: Consumer<_ThisProvider>(
                                                builder:
                                                    (context, thisProvider, _) {
                                                  return AppHorizontalSlider(
                                                    bgColor:
                                                        const Color(0xFF313236),
                                                    activeColor:
                                                        AppColors.colorE6007A,
                                                    initialProgress:
                                                        thisProvider.progress,
                                                    onProgressUpdate: (progress) =>
                                                        _onAmountSlideUpdate(
                                                            progress,
                                                            context.read<
                                                                WithdrawCubit>(),
                                                            thisProvider),
                                                  );
                                                },
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  22, 26, 22, 0.0),
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      27, 14, 13, 13),
                                              decoration: BoxDecoration(
                                                color: AppColors.colorFFFFFF
                                                    .withOpacity(0.05),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: <BoxShadow>[
                                                  bsDefault
                                                ],
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: TextField(
                                                      controller:
                                                          _addressController,
                                                      style: tsS16W500CFF,
                                                      decoration:
                                                          InputDecoration(
                                                        isDense: true,
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        hintText:
                                                            'Enter Dex address',
                                                        hintStyle: tsS16W500CFF
                                                            .copyWith(
                                                          color: AppColors
                                                              .colorFFFFFF
                                                              .withOpacity(0.5),
                                                        ),
                                                        border:
                                                            InputBorder.none,
                                                        errorBorder:
                                                            InputBorder.none,
                                                        enabledBorder:
                                                            InputBorder.none,
                                                        focusedBorder:
                                                            InputBorder.none,
                                                        disabledBorder:
                                                            InputBorder.none,
                                                        focusedErrorBorder:
                                                            InputBorder.none,
                                                      ),
                                                      onChanged: (address) => context
                                                          .read<WithdrawCubit>()
                                                          .updateWithdrawParams(
                                                              address: address),
                                                    ),
                                                  ),
                                                  buildInkWell(
                                                    onTap: () async {
                                                      final address =
                                                          await Coordinator
                                                              .goToQrCodeScanScreen();

                                                      if (address != null) {
                                                        _addressController
                                                            .text = address;
                                                        context
                                                            .read<
                                                                WithdrawCubit>()
                                                            .updateWithdrawParams(
                                                                address:
                                                                    address);
                                                      }
                                                    },
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: Container(
                                                      width: 43,
                                                      height: 43,
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .color8BA1BE
                                                            .withOpacity(0.2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12),
                                                      child: SvgPicture.asset(
                                                          'scan'.asAssetSvg()),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      22, 18, 22, 20.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 18),
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                      27,
                                                      9,
                                                      22,
                                                      9,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors
                                                          .colorFFFFFF
                                                          .withOpacity(0.05),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      boxShadow: <BoxShadow>[
                                                        bsDefault
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 100,
                                                          child: DropdownButton<
                                                              String>(
                                                            items: [
                                                              'DOT Chain',
                                                              'DOT 1',
                                                              'DOT 2'
                                                            ]
                                                                .map((e) =>
                                                                    DropdownMenuItem<
                                                                        String>(
                                                                      child:
                                                                          Text(
                                                                        e,
                                                                        style:
                                                                            tsS16W600CFF,
                                                                      ),
                                                                      value: e,
                                                                    ))
                                                                .toList(),
                                                            value: 'DOT Chain',
                                                            style: tsS16W600CFF,
                                                            underline:
                                                                Container(),
                                                            onChanged: (val) {},
                                                            isExpanded: true,
                                                            icon: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          0.0),
                                                              child: Icon(
                                                                Icons
                                                                    .keyboard_arrow_down_rounded,
                                                                color: AppColors
                                                                    .colorFFFFFF,
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
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Withdraw Fee',
                                                            style: tsS13W400CFFOP60.copyWith(
                                                                color: AppColors
                                                                    .colorFFFFFF
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
                                                if (!provider
                                                    .isKeyboardVisible) {
                                                  height = (10 *
                                                          (MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              759.27272727))
                                                      .clamp(
                                                          0.0, double.infinity);
                                                }
                                                return AnimatedSize(
                                                  duration: AppConfigs
                                                      .animDurationSmall,
                                                  child: SizedBox(
                                                    height: height,
                                                  ),
                                                );
                                              },
                                            ),
                                            Consumer<_ThisProvider>(
                                              builder: (context, provider, _) =>
                                                  AnimatedPadding(
                                                duration: AppConfigs
                                                    .animDurationSmall,
                                                padding: EdgeInsets.fromLTRB(
                                                  21,
                                                  0.0,
                                                  21.0,
                                                  provider.isKeyboardVisible
                                                      ? 400.0
                                                      : 0.0,
                                                ),
                                                child: Center(
                                                  child: withdrawState
                                                          is WithdrawLoading
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 25.0),
                                                          child:
                                                              LoadingDotsWidget(
                                                                  dotSize: 10),
                                                        )
                                                      : AppSlideButton(
                                                          enabled: withdrawState
                                                              is WithdrawValid,
                                                          height: 60,
                                                          onComplete: () =>
                                                              _onSlideToWithdrawComplete(
                                                            context.read<
                                                                WithdrawCubit>(),
                                                            provider,
                                                          ),
                                                          label:
                                                              'Slide to withdraw',
                                                          icon: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .color1C2023,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                            ),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(14),
                                                            width: 45,
                                                            height: 45,
                                                            child: SvgPicture
                                                                .asset(
                                                              'arrow'
                                                                  .asAssetSvg(),
                                                              fit: BoxFit
                                                                  .contain,
                                                              color: AppColors
                                                                  .colorFFFFFF,
                                                            ),
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: AppColors
                                                                .colorE6007A,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
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
                          builder: (context, provider, child) =>
                              Positioned.fill(
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
                              onKeypadNumberTapped: (number) =>
                                  _onKeyboardNumberTapped(
                                number,
                                context.read<WithdrawCubit>(),
                                provider,
                              ),
                              onSwapTapped: () =>
                                  _onSwapTapped(context.read<WithdrawCubit>()),
                              onEnterTapped: () => context
                                  .read<_ThisProvider>()
                                  .isKeyboardVisible = false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _onKeyboardNumberTapped(
    _EnumKeypadNumbers numberTapped,
    WithdrawCubit cubit,
    _ThisProvider provider,
  ) {
    final previousState = cubit.state;
    String _newEditableValue = previousState.amountDisplayed;

    switch (numberTapped) {
      case _EnumKeypadNumbers.one:
        _newEditableValue += "1";
        break;
      case _EnumKeypadNumbers.two:
        _newEditableValue += "2";
        break;
      case _EnumKeypadNumbers.three:
        _newEditableValue += "3";
        break;
      case _EnumKeypadNumbers.four:
        _newEditableValue += "4";
        break;
      case _EnumKeypadNumbers.five:
        _newEditableValue += "5";
        break;
      case _EnumKeypadNumbers.six:
        _newEditableValue += "6";
        break;
      case _EnumKeypadNumbers.seven:
        _newEditableValue += "7";
        break;
      case _EnumKeypadNumbers.eight:
        _newEditableValue += "8";
        break;
      case _EnumKeypadNumbers.nine:
        _newEditableValue += "9";
        break;
      case _EnumKeypadNumbers.zero:
        _newEditableValue += "0";
        if (_newEditableValue.length == 1) {
          _newEditableValue = "";
        }
        break;
      case _EnumKeypadNumbers.dot:
        if (_newEditableValue.contains('.')) {
          return;
        }
        _newEditableValue += ".";
        if (_newEditableValue.length == 1) {
          _newEditableValue = "0.";
        }
        break;
      case _EnumKeypadNumbers.back:
        if (_newEditableValue.isEmpty) break;
        if (_newEditableValue.isNotEmpty) {
          _newEditableValue =
              _newEditableValue.substring(0, _newEditableValue.length - 1);
        }
        break;
    }

    final double valInDouble = double.tryParse(_newEditableValue) ?? 0;
    final double newAmountToBeWithdrawn = _areAmountUnitsSwapped
        ? valInDouble * (1 / _conversionRate)
        : valInDouble;

    provider.progress =
        (newAmountToBeWithdrawn / previousState.amountFree).clamp(0.0, 1.0);
    cubit.updateWithdrawParams(
        amountToBeWithdrawn: newAmountToBeWithdrawn,
        amountDisplayed: _newEditableValue);
  }

  void _onSwapTapped(
    WithdrawCubit cubit,
  ) {
    cubit.updateWithdrawParams(
        amountDisplayed: !_areAmountUnitsSwapped
            ? (cubit.state.amountToBeWithdrawn * _conversionRate).toString()
            : cubit.state.amountToBeWithdrawn.toString());
    setState(() => _areAmountUnitsSwapped = !_areAmountUnitsSwapped);
  }

  void _onSlideToWithdrawComplete(
      WithdrawCubit cubit, _ThisProvider provider) async {
    final currentState = cubit.state;

    await cubit.withdraw(
      asset: widget.tokenId,
      amountFree: currentState.amountFree,
      amountToBeWithdrawn: currentState.amountToBeWithdrawn,
      address: currentState.address,
      signature: context.read<AccountCubit>().accountSignature,
    );

    _onAmountSlideUpdate(0.0, cubit, provider);
  }

  void _onAmountSlideUpdate(
    double progress,
    WithdrawCubit cubit,
    _ThisProvider provider,
  ) {
    final previousState = cubit.state;
    final amountSlide =
        previousState.amountFree * MathUtils.floorDecimalPrecision(progress, 2);
    final amountDisplayed =
        _areAmountUnitsSwapped ? amountSlide * _conversionRate : amountSlide;

    cubit.updateWithdrawParams(
      amountToBeWithdrawn: amountSlide,
      amountDisplayed: amountDisplayed.toString(),
    );
    provider.progress = progress;
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
                  color: AppColors.colorFFFFFF,
                ),
              ),
            ),
            Expanded(
              child: Text(
                "Withdraw ${TokenUtils.tokenIdToFullName(widget.tokenId)} (${TokenUtils.tokenIdToAcronym(widget.tokenId)})",
                style: tsS19W700CFF,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 50),
          ],
        ),
      );
}

class _ThisAmountWidget extends StatelessWidget {
  const _ThisAmountWidget({
    required this.amount,
    required this.amountDisplayed,
    required this.conversionRate,
    required this.areUnitsSwapped,
  });

  final double amount;
  final String amountDisplayed;
  final double conversionRate;
  final bool areUnitsSwapped;

  @override
  Widget build(BuildContext context) {
    String primaryAmount = amount.toString();
    String secondaryAmount = (amount * conversionRate).toString();

    if (areUnitsSwapped) {
      final temp = secondaryAmount;
      secondaryAmount = primaryAmount;
      primaryAmount = temp;
    }

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
                amountDisplayed.isEmpty ? '0' : amountDisplayed,
                style: tsS31W500CFF,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 4),
            Consumer<_ThisProvider>(
              builder: (context, provider, child) => Text(
                '~$secondaryAmount',
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
  const _ThisCoinTitleWidget({
    required this.tokenId,
    required this.amount,
    required this.areUnitsSwapped,
    required this.conversionRate,
    required this.isLoaded,
  });

  final String tokenId;
  final double amount;
  final bool areUnitsSwapped;
  final double conversionRate;
  final bool isLoaded;

  @override
  Widget build(BuildContext context) {
    String primaryAmount = '$amount ${TokenUtils.tokenIdToAcronym(tokenId)} ';
    String secondaryAmount = '\$${amount * conversionRate} ';

    if (areUnitsSwapped) {
      final temp = secondaryAmount;
      secondaryAmount = primaryAmount;
      primaryAmount = temp;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(21, 40, 21, 0.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.colorFFFFFF,
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(right: 11),
            padding: const EdgeInsets.all(5),
            width: 51,
            height: 51,
            child: Image.asset(
              TokenUtils.tokenIdToAssetImg(tokenId),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Available',
                  style: tsS16W400CFF.copyWith(
                    color: AppColors.colorFFFFFF.withOpacity(0.50),
                  ),
                ),
                SizedBox(height: 2),
                isLoaded
                    ? RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: primaryAmount,
                              style: tsS17W600C0CA564.copyWith(
                                  color: AppColors.colorFFFFFF),
                            ),
                            TextSpan(
                              text: secondaryAmount,
                              style: tsS17W600C0CA564.copyWith(
                                color: AppColors.colorFFFFFF.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      )
                    : _amountAvailableShimmerWidget(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _amountAvailableShimmerWidget() {
    return Shimmer.fromColors(
      highlightColor: AppColors.color8BA1BE,
      baseColor: AppColors.color2E303C,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black,
          ),
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: '0.0',
                  style:
                      tsS17W600C0CA564.copyWith(color: AppColors.colorFFFFFF),
                ),
                TextSpan(
                  text: '0.0',
                  style: tsS17W600C0CA564.copyWith(
                    color: AppColors.colorFFFFFF.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

/// The provider handles the events on the screen. Coin conversion keyboard, etc
class _ThisProvider extends ChangeNotifier {
  final double _availableAmount = 31.25;
  final double _availableUnit = 1.5;

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
        color: AppColors.color2E303C,
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
                        color: AppColors.color1C2023,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: <BoxShadow>[bsDefault],
                      ),
                      padding: const EdgeInsets.fromLTRB(11, 15, 11, 14),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.colorFFFFFF,
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
                                color: AppColors.color8BA1BE,
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
                            color: AppColors.colorE6007A,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: <BoxShadow>[bsDefault],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Enter',
                            style: tsS17W600C0CA564.copyWith(
                                color: AppColors.colorFFFFFF),
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
          color: AppColors.colorFFFFFF,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
