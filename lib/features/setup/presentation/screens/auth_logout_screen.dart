import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';
import 'package:polkadex/common/navigation/coordinator.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/common/widgets/loading_popup.dart';

class AuthLogoutScreen extends StatefulWidget {
  @override
  State<AuthLogoutScreen> createState() => _AuthLogoutScreenState();
}

class _AuthLogoutScreenState extends State<AuthLogoutScreen> {
  late Image polkadexLogo;

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
        if (state is AccountPasswordValidating) {
          LoadingPopup.show(
            context: context,
            text: 'We are almost there...',
          );
        }
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
                builder: (_, state) {
                  return Visibility(
                    visible: state is AccountLoaded,
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
                                  onTap: () async {
                                    await context.read<AccountCubit>().logout();
                                    Coordinator.goToIntroScreen();
                                  },
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
                                  onTap: () async {
                                    if (state is AccountLoaded &&
                                        state.account.biometricAccess) {
                                      final authenticated = await context
                                          .read<AccountCubit>()
                                          .authenticateBiometric();
                                      if (authenticated) {
                                        Coordinator.goToLandingScreen(
                                            state.account);
                                      }
                                    } else {
                                      Coordinator.goToConfirmPasswordScreen();
                                    }
                                  },
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
}
