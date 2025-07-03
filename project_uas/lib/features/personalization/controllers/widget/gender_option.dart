import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/utils/constants/colors.dart';

class GenderOptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const GenderOptionCard({
    super.key, 
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 90,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? (Get.isDarkMode ? BColors.primary.withOpacity(0.2) : BColors.primary.withOpacity(0.1))
              : (Get.isDarkMode ? BColors.darkerGrey : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? BColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: selected ? BColors.primary : BColors.darkGrey),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? BColors.primary : BColors.darkGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
