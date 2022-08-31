import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';
import 'package:provider/provider.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';

class ConnectTradeAccountWidget extends StatelessWidget {
  const ConnectTradeAccountWidget({
    required this.child,
    this.onConnectTap,
  });

  final Widget child;
  final VoidCallback? onConnectTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(builder: (context, state) {
      if (state is AccountLoggedIn &&
          state.account.importedTradeAccountEntity != null) {
        return child;
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Connect a trading account',
            textAlign: TextAlign.center,
            style: tsS18W600CFF,
          ),
          AppButton(
            label: 'Connect',
            onTap: onConnectTap ??
                () {
                  Coordinator.goBackToLandingScreen();
                  Provider.of<PageController>(context, listen: false)
                      .animateToPage(3,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeOut);
                },
          ),
        ],
      );
    });
  }
}
