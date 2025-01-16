import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/circular_container.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BChoiceChip extends StatelessWidget {
  const BChoiceChip({
    super.key,
    required this.text,
    required this.selected,
    this.onSelected,
  });

  final String text;
  final bool selected;
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    final isColor =  BHelperFunctions.getColor(text) != null;

    return ChoiceChip(
      label: isColor ? const SizedBox() : Text(text),
      selected: selected,
      onSelected: onSelected,
      labelStyle: TextStyle(color: selected ? BColors.white : null),
      avatar: isColor ? BCircularContainer(width: 58, height: 50, backgroundColor: BHelperFunctions.getColor(text) !) : null,
      labelPadding: isColor ? const EdgeInsets.all(9) : null,
      padding: isColor ? const EdgeInsets.all(0) : null,
      shape: isColor ? const CircleBorder() : null,
      backgroundColor: isColor ? BHelperFunctions. getColor(text)! : null,
    );
  } 
}