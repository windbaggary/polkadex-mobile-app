import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:polkadex/common/widgets/loading_dots_widget.dart';
import 'package:polkadex/common/widgets/polkadex_progress_error_widget.dart';
import 'package:polkadex/features/app_settings_info/widgets/app_settings_layout.dart';
import 'package:polkadex/common/utils/colors.dart';

/// XD_PAGE: 47
class PrivacyPolicyScreen extends StatefulWidget {
  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final ValueNotifier<PDFDocument?> marketDropDownNotifier =
      ValueNotifier<PDFDocument?>(null);

  Future<PDFDocument> get _pdfRequest => PDFDocument.fromURL(
      'https://github.com/Polkadex-Substrate/Docs/raw/master/Polkadex_Privacy_Policy.pdf');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color1C2023,
      body: AppSettingsLayout(
        subTitle: 'Privacy Policy',
        mainTitle: 'Privacy Policy',
        isShowSubTitle: false,
        onBack: () => Navigator.of(context).pop(),
        contentChild: Container(
          decoration: BoxDecoration(
            color: AppColors.color2E303C,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: FutureBuilder(
            future: _pdfRequest,
            builder:
                (BuildContext context, AsyncSnapshot<PDFDocument> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: LoadingDotsWidget(
                    dotSize: 12,
                  ),
                );
              } else {
                if (snapshot.hasData) {
                  return Theme(
                    // ignore accentColor deprecation since it's the only way to set desired pdf page on numberPicker
                    // ignore_for_file: deprecated_member_use
                    data: Theme.of(context)
                        .copyWith(accentColor: AppColors.colorE6007A),
                    child: PDFViewer(
                      document: snapshot.data!,
                      pickerButtonColor: AppColors.colorE6007A,
                    ),
                  );
                }

                return Center(
                  child: PolkadexErrorRefreshWidget(
                    onRefresh: () async => setState(() {}),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
