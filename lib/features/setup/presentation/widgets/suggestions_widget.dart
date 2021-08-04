import 'package:flutter/cupertino.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/styles.dart';

class SuggestionsWidget extends StatelessWidget {
  const SuggestionsWidget({required this.suggestions});

  final List<String> suggestions;

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
        )
      ],
    );
  }
}
