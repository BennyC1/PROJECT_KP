import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/texts/section_heading.dart';
import 'package:project_uas/utils/constants/sized.dart';

class BBillingAddressSection extends StatelessWidget {
  const BBillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BSectionHeading(title: 'Address', showActionButton: false),
        const SizedBox(height: BSize.spaceBtwItems / 2),
        Row (
          children: [
            const Icon(Icons.phone, color: Colors.grey, size: 16),
            const SizedBox(width: BSize.spaceBtwItems),
            Text( '0822-8149-0401' , style: Theme.of(context).textTheme.bodyMedium),
          ]
        ),
        const SizedBox(height: BSize.spaceBtwItems/2),
        Row(
          children: [
            const Icon(Icons.location_history, color: Colors.grey, size: 16),
            const SizedBox(width: BSize.spaceBtwItems),
            Expanded(child: Text("D'Barbershop JL. Maskarebet Komplek Taman Indah CD/01 No.64", style: Theme.of(context).textTheme.bodyMedium, softWrap: true)),
          ],
        )
      ]
    );
  }
}
