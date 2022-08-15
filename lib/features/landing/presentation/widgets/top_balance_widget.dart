import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/build_methods.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';

class TopBalanceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BalanceCubit, BalanceState>(
      builder: (context, state) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: AppConfigs.size.width / 3),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 42,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.color8BA1BE.withOpacity(0.30),
                    ),
                    padding: const EdgeInsets.all(11),
                    child: SvgPicture.asset('wallet_selected'.asAssetSvg()),
                  ),
                ),
                Text(
                  context.read<AccountCubit>().accountName,
                  style: tsS20W600CFF,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        FlutterClipboard.copy(context
                                .read<AccountCubit>()
                                .proxyAccountAddress)
                            .then((value) => buildAppToast(
                                msg:
                                    'Wallet address has been copied to the clipboard',
                                context: context));
                      },
                      child: SvgPicture.asset(
                        'copy'.asAssetSvg(),
                      ),
                    ),
                    SizedBox(width: 2),
                    Flexible(
                      child: Text(
                        context.read<AccountCubit>().proxyAccountAddress,
                        overflow: TextOverflow.ellipsis,
                        style:
                            tsS14W400CFF.copyWith(color: AppColors.colorABB2BC),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
