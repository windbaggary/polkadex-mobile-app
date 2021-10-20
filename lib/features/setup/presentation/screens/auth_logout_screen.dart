import 'package:biometric_storage/biometric_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/widgets/app_buttons.dart';
import 'package:polkadex/features/setup/domain/usecases/get_account_storage_usecase.dart';
import 'package:polkadex/injection_container.dart';

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
            Align(
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
          ],
        ),
      ),
    );
  }
}
