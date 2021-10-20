import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:polkadex/common/providers/account_provider.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/features/setup/presentation/screens/intro_screen.dart';
import 'package:provider/provider.dart';

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

    WidgetsBinding.instance?.addPostFrameCallback(
      (_) async {
        final provider = Provider.of<AccountProvider>(context, listen: false);

        await provider.loadAccountData();

        if (!provider.storeHasAccount) {
          _onNavigateToIntro(context);
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(polkadexLogo.image, context);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AccountProvider>(context).addListener(() {
      final account = Provider.of<AccountProvider>(context).storeHasAccount;

      print('foi');
      if (!account) {
        _onNavigateToIntro(context);
      }
    });

    return Scaffold(
      backgroundColor: color1C2023,
      body: Center(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Center(
              child: polkadexLogo,
            ),
            Consumer<AccountProvider>(
              builder: (context, provider, child) {
                return Visibility(
                  visible: provider.storeHasAccount,
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
                                  await Provider.of<AccountProvider>(context,
                                          listen: false)
                                      .logout();
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onNavigateToIntro(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => IntroScreen(),
      ),
      (route) => route.isFirst,
    );
  }
}
