import 'package:clipboard/clipboard.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/common/widgets/build_methods.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
import 'package:polkadex/features/landing/utils/token_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

class BalanceDepositScreenOne extends StatefulWidget {
  BalanceDepositScreenOne({
    required this.tokenId,
  });

  final String tokenId;

  @override
  _BalanceDepositScreenState createState() => _BalanceDepositScreenState();
}

class _BalanceDepositScreenState extends State<BalanceDepositScreenOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color1C2023,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
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
                    "Deposit",
                    style: tsS19W700CFF,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 50),
              ],
            ),
            SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 12),
                    _coinTileWidget(),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.color2E303C,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 9),
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 0,
                              bottom: 27,
                              left: 23,
                              right: 4,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Network:',
                                  style: tsS16W600CFF,
                                ),
                                SizedBox(width: 36),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding:
                                        const EdgeInsets.fromLTRB(27, 8, 24, 8),
                                    child: DropdownButton<String>(
                                      items: [
                                        'DOT Chain',
                                        'DOT Chain 2',
                                        'DOT  3'
                                      ]
                                          .map((e) => DropdownMenuItem<String>(
                                                child: Text(
                                                  e,
                                                  style: tsS16W600CFF,
                                                ),
                                                value: e,
                                              ))
                                          .toList(),
                                      value: 'DOT Chain',
                                      style: tsS16W600CFF,
                                      underline: Container(),
                                      onChanged: (value) {},
                                      isExpanded: true,
                                      icon: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: AppColors.colorFFFFFF,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 14),
                            child: Text(
                              'Scan or share',
                              style: tsS20W600CFF,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Center(
                            child: Image.asset(
                              'qr-code.png'.asAssetImg(),
                              width: MediaQuery.of(context).size.width * 0.55,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24, bottom: 12),
                            child: buildInkWell(
                              onTap: () {
                                FlutterClipboard.copy(
                                        '3P3QsMVK89JBNqZQv5zMAKG8FK3k')
                                    .then((value) => buildAppToast(
                                        msg:
                                            'The address is copied to the clipboard',
                                        context: context));
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 24, 20, 26),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Your DEX Address',
                                      style: tsS16W600CFF,
                                    ),
                                    SizedBox(height: 7.3),
                                    Text(
                                      '3P3QsMVK89JBNqZQv5zMAKG8FK3k',
                                      style: tsS15W400CFF.copyWith(
                                        color: AppColors.colorFFFFFF
                                            .withOpacity(0.70),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: tsS14W400CFFOP50,
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Tap ',
                                    style: TextStyle(
                                      fontFamily: 'WorkSans',
                                    )),
                                TextSpan(
                                  text: 'Address',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'WorkSans',
                                  ),
                                ),
                                TextSpan(
                                  text: ' to copy',
                                  style: TextStyle(
                                    fontFamily: 'WorkSans',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(26, 30, 26, 48),
                      child: Text(
                        'Attention: Sending token other than DEX to this address may result in the loss of your deposit.',
                        style: tsS13W400CFFOP60.copyWith(
                            color: AppColors.colorFFFFFF),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: buildInkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => _onShare(context),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppColors.color0CA564,
                                ),
                                width: 48,
                                height: 48,
                                padding: const EdgeInsets.all(14),
                                child: Image.asset('share.png'.asAssetImg()),
                              ),
                            ),
                          ),
                          Text(
                            'Share',
                            style: tsS16W600CFF,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _coinTileWidget() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.color0CA564,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 9),
      padding: const EdgeInsets.all(10),
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
            child: SvgPicture.asset(
              TokenUtils.tokenIdToAssetSvg(widget.tokenId),
            ),
          ),
          Expanded(
            child: BlocBuilder<BalanceCubit, BalanceState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Available',
                      style: tsS16W400CFF,
                    ),
                    SizedBox(height: 2),
                    state is BalanceLoaded
                        ? RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: state.free.getBalance(widget.tokenId),
                                  style: tsS17W600C0CA564.copyWith(
                                      color: AppColors.colorFFFFFF),
                                ),
                                TextSpan(text: '\$31.25', style: tsS17W400CFF),
                              ],
                            ),
                          )
                        : _amountShimmerWidget(),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _amountShimmerWidget() {
    return Shimmer.fromColors(
      highlightColor: AppColors.colorABB2BC,
      baseColor: AppColors.color0CA564,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.color0CA564,
        ),
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: '1.5000 DEX',
                style: tsS17W600C0CA564.copyWith(color: AppColors.colorFFFFFF),
              ),
              TextSpan(text: '\$31.25', style: tsS17W400CFF),
            ],
          ),
        ),
      ),
    );
  }

  /// Share the qrcode to other apps
  _onShare(BuildContext context) async {
    final imgData = await rootBundle.load('qr-code.png'.asAssetImg());
    // final dir = await pathProvider.getTemporaryDirectory();
    // final file = File(path.join(dir.path, 'qrcode.png'));
    // if (!await file.exists()) {
    //   await file.create();
    // }
    // await file.writeAsBytes(imgData.buffer.asUint64List());
    if (!await Permission.storage.isGranted) {
      await Permission.storage.request();
    }

    if (!await Permission.manageExternalStorage.isGranted) {
      await Permission.manageExternalStorage.request();
    }
    final path = await FileSaver.instance.saveFile(
        'qrcode', imgData.buffer.asUint8List(), 'png',
        mimeType: MimeType.PNG);
    final box = context.findRenderObject() as RenderBox;

    /// Share the saved image and address
    Share.shareFiles(
      [path],
      subject: 'Polkadex',
      text: 'Polkadex DEX Address: 3P3QsMVK89JBNqZQv5zMAKG8FK3k',
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
      mimeTypes: ["image/png"],
    );
    // Share.share(
    //   'Polkadex DEX Address: 3P3QsMVK89JBNqZQv5zMAKG8FK3k',
    //   subject: 'Polkadex',
    // );
  }
}
