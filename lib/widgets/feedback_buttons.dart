import 'package:flutter/material.dart';

class FeedbackButtons extends StatelessWidget {
  final List<String> options;
  final Set<String> selected;
  final void Function(String, bool) onToggle;

  const FeedbackButtons({
    required this.options,
    required this.selected,
    required this.onToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 30,
      runSpacing: 10,
      children: options.map((label) {
        final isSelected = selected.contains(label);
        return ChoiceChip(
          label: Text(label),
          showCheckmark: false,
          selected: isSelected,
          selectedColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Colors.grey.shade200,
          labelStyle: TextStyle(
            color: isSelected ? const Color.fromARGB(255, 255, 255, 255) : Colors.black,
          ),
          onSelected: (selected) => onToggle(label, selected),
        );
      }).toList(),
    );
  }
}
