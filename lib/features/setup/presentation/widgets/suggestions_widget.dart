import 'package:flutter/material.dart';
import 'package:polkadex/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/features/setup/presentation/providers/mnemonic_provider.dart';

class SuggestionsWidget extends StatelessWidget {
  const SuggestionsWidget({
    required this.suggestions,
    required this.controllers,
  });

  final List<String> suggestions;
  final List<TextEditingController> controllers;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          S.of(context).suggestions,
          style: tsS15W600CFF,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                suggestions.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTapDown: (_) {
                      final indexWordEdited =
                          context.read<MnemonicProvider>().indexWordEdited;

                      if (indexWordEdited != null) {
                        controllers[indexWordEdited].text = suggestions[index];
                        context.read<MnemonicProvider>().changeMnemonicWord(
                            indexWordEdited, suggestions[index]);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: color8BA1BE.withOpacity(0.2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Text(
                          suggestions[index],
                          style: tsS15W400CFF,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
