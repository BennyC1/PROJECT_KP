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
        BSectionHeading(title: 'Shipping Address', buttonTitle: 'Change', onPressed: () {}),
        Text('STRESSSSS', style: Theme. of (context).textTheme.bodyLarge),
        const SizedBox(height: BSize.spaceBtwItems / 2),
        Row (
          children: [
            const Icon(Icons.phone, color: Colors.grey, size: 16),
            const SizedBox(width: BSize.spaceBtwItems),
            Text( '+62 77-7888-8888' , style: Theme.of(context) . textTheme. bodyMedium),
          ]
        ),
        const SizedBox(height: BSize.spaceBtwItems/2),
        Row(
          children: [
            const Icon(Icons.location_history, color: Colors.grey, size: 16),
            const SizedBox(width: BSize.spaceBtwItems),
            Expanded(child: Text( "Palembang, Ujung dunia No 124", style: Theme.of(context).textTheme.bodyMedium, softWrap: true)),
          ],
        )
      ]
    );
  }
}
