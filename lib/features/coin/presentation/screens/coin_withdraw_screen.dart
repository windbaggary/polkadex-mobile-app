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
        ),
      child: ChangeNotifierProvider(
        create: (_) => _ThisProvider(),
        builder: (context, _) => Scaffold(
          backgroundColor: AppColors.color1C2023,
          body: BlocBuilder<BalanceCubit, BalanceState>(
            builder: (context, balanceState) {
              if (balanceState is BalanceLoaded) {
                context.read<WithdrawCubit>().updateWithdrawParams(
                      amountFree: double.tryParse(
                              balanceState.free[widget.asset.assetId]) ??
                          0.0,
                    );
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
                                              withdrawAmountController:
                                                  _withdrawAmountController,
                                            ),
                                            Consumer<_ThisProvider>(
                                              builder: (context, provider, _) =>
                                                  Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        22, 40, 24, 0),
                                                child: AppHorizontalSlider(
                                                  bgColor:
                                                      const Color(0xFF313236),
                                                  activeColor:
                                                      AppColors.colorE6007A,
                                                  initialProgress:
                                                      provider.progress,
                                                  onProgressUpdate:
                                                      (progress) =>
                                                          _onAmountSlideUpdate(
                                                    progress,
                                                    context
                                                        .read<WithdrawCubit>(),
                                                    provider,
                                                  ), //TODO: update onProgressUpdate callback
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 16),
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
                                                          22, 0.0, 22, 0.0),
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
                                            SizedBox(height: 16),
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
      padding: const EdgeInsets.fromLTRB(27, 16, 13, 13),
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
    WithdrawCubit cubit,
    _ThisProvider provider,
  ) async {
    final currentState = cubit.state;

    await cubit.withdraw(
      proxyAddress: context.read<AccountCubit>().proxyAccountAddress,
      mainAddress: context.read<AccountCubit>().mainAccountAddress,
      asset: widget.asset.assetId,
      amountFree: currentState.amountFree,
      amountToBeWithdrawn: currentState.amountToBeWithdrawn,
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
    );
    provider.progress = progress;
    _withdrawAmountController.text = amountSlide.toString();
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
    required this.withdrawAmountController,
  });

  final double amount;
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
            onChanged: (newAmount) => _onAmountControllerChange(
              newAmount,
              context.read<WithdrawCubit>(),
              context.read<_ThisProvider>(),
            ),
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

  void _onAmountControllerChange(
    String amountToWithdraw,
    WithdrawCubit cubit,
    _ThisProvider provider,
  ) {
    final previousState = cubit.state;
    final newAmountToWithdraw = double.tryParse(amountToWithdraw) ?? 0.0;

    provider.progress =
        (newAmountToWithdraw / previousState.amountFree).clamp(0.0, 1.0);
    cubit.updateWithdrawParams(amountToBeWithdrawn: newAmountToWithdraw);
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

  double get progress => _progress;

  set progress(double val) {
    _progress = val;
    _amount = (_availableAmount * val).toStringAsFixed(2);
    _unit = (_availableUnit * val).toStringAsFixed(2);
    notifyListeners();
  }

  String get unit => _unit;

  String get amount => "\$$_amount";
}
