
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/utils/constants/colors.dart';

import '../../../utils/constants/image_string.dart';
import '../images/circular_image.dart';

class BUserProfileTile extends StatelessWidget {
  const BUserProfileTile({
  super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const BCircularImage(image: BImages.user, width: 50, height: 50, padding: 0),
      title: Text( "BennyCuandraaa", style: Theme.of(context).textTheme.headlineSmall!.apply(color: BColors.white)),
      subtitle: Text('support@nyawaku.com', style: Theme.of(context). textTheme.bodyMedium !. apply(color: BColors.white)),
      trailing: IconButton (onPressed: () {}, icon: const Icon(Iconsax.edit, color: BColors.white)),
    );
  }
}