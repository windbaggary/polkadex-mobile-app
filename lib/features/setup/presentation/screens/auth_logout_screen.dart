import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/common/widgets/loading_overlay.dart';

class AuthLogoutScreen extends StatefulWidget {
  @override
  State<AuthLogoutScreen> createState() => _AuthLogoutScreenState();
}

class _AuthLogoutScreenState extends State<AuthLogoutScreen> {
  late Image polkadexLogo;

  final LoadingOverlay _loadingOverlay = LoadingOverlay();
  String _loadingOverlayText = 'Loading...';

  @override
  void initState() {
    super.initState();

    polkadexLogo = Image.asset(
      'logo_name.png'.asAssetImg(),
      fit: BoxFit.contain,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(polkadexLogo.image, context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountCubit, AccountState>(
      listener: (_, state) {
        state is AccountLoading
            ? _loadingOverlay.show(context: context, text: _loadingOverlayText)
            : _loadingOverlay.hide();
      },
      child: Scaffold(
        backgroundColor: AppColors.color1C2023,
        body: Center(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Center(
                child: polkadexLogo,
              ),
              BlocConsumer<AccountCubit, AccountState>(
                builder: (_, accountState) {
                  print(accountState.runtimeType);
                  return Visibility(
                    visible: accountState is AccountLoaded &&
                        accountState is! AccountLoggedIn,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  label: 'Logout',
                                  innerPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 16,
                                  ),
                                  backgroundColor: AppColors.colorFFFFFF,
                                  textColor: Colors.black,
                                  onTap: () => _onLogOutTapped(),
                                ),
                              ),
                              SizedBox(
                                width: 18,
                              ),
                              Expanded(
                                child: AppButton(
                                  label: 'Authenticate',
                                  innerPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 16,
                                  ),
                                  onTap: () => _onAuthenticateTapped(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                listener: (_, state) {
                  if (state is AccountLoggedIn) {
                    Coordinator.goToLandingScreen(state.account);
                  }

                  if (state is AccountNotLoaded) {
                    Coordinator.goToIntroScreen();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onAuthenticateTapped() async {
    _loadingOverlayText = 'Signing in...';
    final currentState = context.read<AccountCubit>().state;

    if (currentState is AccountLoaded) {
      currentState.account.biometricAccess
          ? await context.read<AccountCubit>().signInWithLocalAcc()
          : Coordinator.goToConfirmPasswordScreen();
    }
  }

  void _onLogOutTapped() async {
    _loadingOverlayText = 'Signing out...';
    await context.read<AccountCubit>().localAccountLogout();

    Coordinator.goToIntroScreen();
  }
}
