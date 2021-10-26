import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/cubits/account_cubit.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/features/landing/screens/landing_screen.dart';
import 'package:polkadex/features/setup/presentation/screens/intro_screen.dart';
import 'package:provider/provider.dart';
import 'confirm_password_screen.dart';

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
    return Scaffold(
      backgroundColor: color1C2023,
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
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 16,
                                ),
                                backgroundColor: colorFFFFFF,
                                textColor: Colors.black,
                                onTap: () async {
                                  await context.read<AccountCubit>().logout();
                                  _onNavigateToIntro(context);
                                },
                              ),
                            ),
                            SizedBox(
                              width: 18,
                            ),
                            Expanded(
                              child: AppButton(
                                label: 'Authenticate',
                                padding: EdgeInsets.symmetric(
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
                                      _onNavigateToLanding(context);
                                    }
                                  } else {
                                    _onNavigateToConfirmPassword(context);
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
                  _onNavigateToIntro(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onNavigateToLanding(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: CurvedAnimation(
                parent: animation, curve: Interval(0.500, 1.00)),
            child: LandingScreen(),
          );
        },
      ),
      (route) => route.isFirst,
    );
  }

  void _onNavigateToConfirmPassword(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: CurvedAnimation(
                parent: animation, curve: Interval(0.500, 1.00)),
            child: ConfirmPasswordScreen(),
          );
        },
      ),
    );
  }

  void _onNavigateToIntro(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: CurvedAnimation(
                parent: animation, curve: Interval(0.500, 1.00)),
            child: IntroScreen(),
          );
        },
      ),
      (route) => route.isFirst,
    );
  }
}
