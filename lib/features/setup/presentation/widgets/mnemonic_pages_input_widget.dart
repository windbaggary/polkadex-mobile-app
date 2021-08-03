import 'package:flutter/material.dart';
import 'package:polkadex/features/setup/presentation/providers/mnemonic_provider.dart';
import 'package:provider/provider.dart';
import 'editable_mnemonic_word_widget.dart';

class MnemonicPagesInputWidget extends StatelessWidget {
  const MnemonicPagesInputWidget({
    required this.pageController,
    required this.currentPage,
    required this.itemsPerPage,
    required this.pageCount,
    required this.pageHeight,
  });

  final PageController pageController;
  final ValueNotifier<int> currentPage;
  final int itemsPerPage;
  final int pageCount;
  final double pageHeight;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: pageHeight),
      child: PageView.builder(
        onPageChanged: (nextPage) => currentPage.value = nextPage,
        controller: pageController,
        itemCount: pageCount,
        itemBuilder: (context, position) {
          final provider = Provider.of<MnemonicProvider>(context);

          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: _listMnemonicCount(context, position),
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                bottom: 10,
                right: 10,
              ),
              child: EditableMnemonicWordWidget(
                wordNumber: (itemsPerPage * position) + (index + 1),
                onChanged: (newValue) {
                  provider.changeMnemonicWord(
                      (itemsPerPage * position) + index, newValue);
                },
              ),
            ),
          );
        }, // Can be null
      ),
    );
  }

  int _listMnemonicCount(
    BuildContext context,
    int pagePosition,
  ) {
    return pagePosition + 1 >=
            (Provider.of<MnemonicProvider>(context).mnemonicWords.length /
                    itemsPerPage)
                .ceil()
        ? Provider.of<MnemonicProvider>(context).mnemonicWords.length -
            (itemsPerPage * pagePosition)
        : itemsPerPage;
  }
}
