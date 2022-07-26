import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';
import 'package:polkadex/common/market_asset/domain/entities/asset_entity.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/math_utils.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_horizontal_slider.dart';
import 'package:polkadex/common/widgets/app_slide_button.dart';
import 'package:polkadex/common/widgets/build_methods.dart';
import 'package:polkadex/features/coin/presentation/cubits/withdraw_cubit/withdraw_cubit.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
import 'package:polkadex/features/landing/utils/token_utils.dart';
import 'package:provider/provider.dart';
import 'package:polkadex/injection_container.dart';
import 'package:shimmer/shimmer.dart';

/// XD_PAGE: 21
/// XD_PAGE: 28
class CoinWithdrawScreen extends StatefulWidget {
  const CoinWithdrawScreen({
    required this.asset,
  });

  final AssetEntity asset;

  @override
  _CoinWithdrawScreenState createState() => _CoinWithdrawScreenState();
}

class _CoinWithdrawScreenState extends State<CoinWithdrawScreen>
    with TickerProviderStateMixin {
  final TextEditingController _withdrawAmountController =
      TextEditingController(text: '0.0');

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
                    amountFree: double.parse(
                        balanceState.free.getBalance(widget.asset)));
              }

              return BlocConsumer<WithdrawCubit, WithdrawState>(
                listener: (context, withdrawState) {
                  if (withdrawState is WithdrawSuccess) {
                    buildAppToast(msg: withdrawState.message, context: context);
                  }

                  if (withdrawState is WithdrawError) {
                    buildAppToast(
                        msg:
                            '${widget.asset.symbol} withdraw failed. Please try again',
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
                                              asset: widget.asset,
                                              amount: withdrawState.amountFree,
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
                                              withdrawAmountController:
                                                  _withdrawAmountController,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      22, 40, 24, 0),
                                              child: AppHorizontalSlider(
                                                bgColor:
                                                    const Color(0xFF313236),
                                                activeColor:
                                                    AppColors.colorE6007A,
                                                onProgressUpdate: (progress) {},
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                _simplifiedWalletDataWidget(
                                                  title: context
                                                      .read<AccountCubit>()
                                                      .accountName,
                                                  address: context
                                                      .read<AccountCubit>()
                                                      .proxyAccountAddress,
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          22, 26, 22, 0.0),
                                                ),
                                                Icon(
                                                  Icons
                                                      .keyboard_double_arrow_down,
                                                  color: Colors.white,
                                                ),
                                                _simplifiedWalletDataWidget(
                                                  title: 'Main Wallet',
                                                  address: context
                                                      .read<AccountCubit>()
                                                      .mainAccountAddress,
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 22),
                                                ),
                                              ],
                                            ),
                                            Consumer<_ThisProvider>(
                                              builder: (context, provider, _) =>
                                                  AppSlideButton(
                                                enabled: withdrawState
                                                    is WithdrawValid,
                                                height: 60,
                                                onComplete: () =>
                                                    _onSlideToWithdrawComplete(
                                                  context.read<WithdrawCubit>(),
                                                  provider,
                                                ),
                                                label: 'Slide to withdraw',
                                                icon: Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        AppColors.color1C2023,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(14),
                                                  width: 45,
                                                  height: 45,
                                                  child: SvgPicture.asset(
                                                    'arrow'.asAssetSvg(),
                                                    fit: BoxFit.contain,
                                                    color:
                                                        AppColors.colorFFFFFF,
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.colorE6007A,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
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

  Widget _simplifiedWalletDataWidget({
    required String title,
    required String address,
    EdgeInsets margin = EdgeInsets.zero,
  }) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.fromLTRB(27, 14, 13, 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[bsDefault],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title:',
            style: tsS16W700CFF.copyWith(color: Colors.black),
          ),
          Text(
            address,
            style: tsS16W400CFF.copyWith(color: Colors.black),
          ),
        ],
      ),
    );
  }

  void _onSlideToWithdrawComplete(
      WithdrawCubit cubit, _ThisProvider provider) async {
    final currentState = cubit.state;

    await cubit.withdraw(
      asset: widget.asset.assetId,
      amountFree: currentState.amountFree,
      amountToBeWithdrawn: currentState.amountToBeWithdrawn,
      address: currentState.address,
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

    cubit.updateWithdrawParams(
      amountToBeWithdrawn: amountSlide,
      amountDisplayed: amountSlide.toString(),
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
                "Withdraw ${widget.asset.name} (${widget.asset.symbol})",
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
    required this.withdrawAmountController,
  });

  final double amount;
  final String amountDisplayed;
  final TextEditingController withdrawAmountController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 56,
        left: 21,
        right: 21,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: withdrawAmountController,
            style: tsS31W500CFF,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              errorBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
            ),
            keyboardType: TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            onChanged: (_) {},
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,4}'))
            ],
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
    );
  }
}

class _ThisCoinTitleWidget extends StatelessWidget {
  const _ThisCoinTitleWidget({
    required this.asset,
    required this.amount,
    required this.isLoaded,
  });

  final AssetEntity asset;
  final double amount;
  final bool isLoaded;

  @override
  Widget build(BuildContext context) {
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
              TokenUtils.tokenIdToAssetImg(asset.assetId),
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
                              text: amount.toString(),
                              style: tsS17W600C0CA564.copyWith(
                                  color: AppColors.colorFFFFFF),
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
