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
    required this.controllers,
    required this.focusNodes,
    this.onChanged,
  });

  final PageController pageController;
  final ValueNotifier<int> currentPage;
  final int itemsPerPage;
  final int pageCount;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final Function(int)? onChanged;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MnemonicProvider>();

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 64.0 * itemsPerPage),
      child: PageView.builder(
        onPageChanged: (nextPage) {
          currentPage.value = nextPage;
          FocusScope.of(context).unfocus();
          context.read<MnemonicProvider>().clearSuggestions();
        },
        controller: pageController,
        itemCount: pageCount,
        itemBuilder: (context, position) {
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: _listMnemonicCount(context, position),
            itemBuilder: (context, index) {
              final wordIndex = (itemsPerPage * position) + index;

              return Padding(
                padding: EdgeInsets.only(
                  bottom: 10,
                  right: 10,
                ),
                child: EditableMnemonicWordWidget(
                  wordNumber: wordIndex + 1,
                  initialText: provider.mnemonicWords[wordIndex],
                  onChanged: (newValue) {
                    provider.changeMnemonicWord(wordIndex, newValue);
                    provider.searchSuggestions(newValue);

                    if (onChanged != null) {
                      onChanged!(wordIndex);
                    }
                  },
                  onTap: () {
                    provider.indexWordEdited = wordIndex;
                  },
                  controller: controllers[wordIndex],
                  focusNode: focusNodes[wordIndex],
                ),
              );
            },
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
            (context.read<MnemonicProvider>().mnemonicWords.length /
                    itemsPerPage)
                .ceil()
        ? context.read<MnemonicProvider>().mnemonicWords.length -
            (itemsPerPage * pagePosition)
        : itemsPerPage;
  }
}
