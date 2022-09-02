import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:polkadex/common/widgets/loading_dots_widget.dart';
import 'package:polkadex/features/app_settings_info/widgets/app_settings_layout.dart';
import 'package:polkadex/common/utils/colors.dart';

/// XD_PAGE: 47
class PrivacyPolicyScreen extends StatefulWidget {
  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late PDFDocument localPdf;

  final String _pdfLink =
      'https://github.com/Polkadex-Substrate/Docs/raw/master/Polkadex_Privacy_Policy.pdf';
  final String _pdfLocalPath = 'assets/pdfs/Polkadex_Privacy_Policy.pdf';

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context);

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
            future: _fetchPdfs(
              _pdfLink,
              _pdfLocalPath,
            ),
            builder:
                (BuildContext context, AsyncSnapshot<PDFDocument> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: LoadingDotsWidget(
                    dotSize: 12,
                  ),
                );
              } else {
                final pdfDocument = snapshot.hasData ? snapshot.data : localPdf;

                return Theme(
                  // ignore accentColor deprecation since it's the only way to set desired pdf page on numberPicker
                  // ignore_for_file: deprecated_member_use
                  data: currentTheme.copyWith(
                    accentColor: AppColors.colorE6007A,
                    colorScheme: currentTheme.colorScheme.copyWith(
                      primary: AppColors.colorE6007A,
                    ),
                  ),
                  child: PDFViewer(
                    document: pdfDocument!,
                    pickerButtonColor: AppColors.colorE6007A,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<PDFDocument> _fetchPdfs(
    String link,
    String path,
  ) async {
    localPdf = await _pdfRequestFromAsset(path);

    return _pdfRequestFromURL(link);
  }

  Future<PDFDocument> _pdfRequestFromAsset(String path) =>
      PDFDocument.fromAsset(path);

  Future<PDFDocument> _pdfRequestFromURL(String link) =>
      PDFDocument.fromURL(link);
}
