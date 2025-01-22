import 'package:flutter/material.dart';

import '../../../../../utils/constants/sized.dart';


class BCategoryCopy extends StatelessWidget {
  const BCategoryCopy({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding (
          padding: const EdgeInsets.all(BSize.defaultSpace),
          child: Column(
            children: [
            ],
          ),
        ),
      ]
    );
  }
}