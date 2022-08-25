import 'package:flutter/material.dart';
import 'package:polkadex/features/landing/presentation/providers/mnemonic_provider.dart';

abstract class ImportWalletUtils {
  static void editNextMnemonic(
    int index,
    int itemsPerPage,
    int totalPages,
    List<TextEditingController> controllers,
    List<FocusNode> focusNodes,
    PageController pageController,
    MnemonicProvider provider,
  ) async {
    if (index < focusNodes.length - 1 &&
        provider.suggestionsMnemonicWords.contains(controllers[index].text)) {
      provider.clearSuggestions();

      provider.indexWordEdited = index + 1;

      if (index + 1 >= itemsPerPage &&
          (pageController.page ?? 0) < totalPages - 1) {
        await pageController.nextPage(
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      }
      focusNodes[index + 1].requestFocus();
    }
  }

  static int pageMnemonicCount(
    BuildContext context,
    MnemonicProvider provider,
    int itemsPerPage,
  ) {
    return (provider.mnemonicWords.length / itemsPerPage).ceil();
  }
}
