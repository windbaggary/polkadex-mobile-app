import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';
import 'package:polkadex/features/landing/presentation/providers/mnemonic_provider.dart';

class SuggestionsWidget extends StatelessWidget {
  const SuggestionsWidget({
    required this.suggestions,
    required this.controllers,
    required this.focusNodes,
    this.onTapDown,
  });

  final List<String> suggestions;
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final Function(int)? onTapDown;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Suggestions',
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
                      final provider = context.read<MnemonicProvider>();
                      final indexWordEdited = provider.indexWordEdited;

                      if (indexWordEdited != null) {
                        controllers[indexWordEdited].text = suggestions[index];
                        provider.changeMnemonicWord(
                            indexWordEdited, suggestions[index]);

                        if (onTapDown != null) {
                          onTapDown!(index);
                        }
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.color8BA1BE.withOpacity(0.2),
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
