import 'package:flutter/material.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/constants/text_string.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';


class BLoginHeader extends StatelessWidget {
  const BLoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          height: 150,
          image: AssetImage(dark ? BImages.lightAppLogo : BImages.darkAppLogo),
        ),
        Text(BText.loginTitle, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: BSize.sm),
        Text(BText.loginSubTitle, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}