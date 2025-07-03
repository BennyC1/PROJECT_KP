
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/utils/constants/sized.dart';

class BProfileMenu extends StatelessWidget {
    const BProfileMenu({
    super.key,
    this.onPressed,
    required this.title,
    required this.value,
    this.icon = Iconsax.arrow_right_34,
    });

  final IconData? icon;
  final VoidCallback? onPressed;
  final String title, value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: BSize.spaceBtwItems / 1.5),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (icon != null) Expanded(child: Icon(icon, size: 18)),
          ],
        ),
      ),
    );
  }
}