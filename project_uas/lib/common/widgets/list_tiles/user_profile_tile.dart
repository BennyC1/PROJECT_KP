
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/features/personalization/controllers/user_controller.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/common/widgets/shimmer/shimmer.dart';

import '../../../utils/constants/image_string.dart';
import '../images/circular_image.dart';

class BUserProfileTile extends StatelessWidget {
  const BUserProfileTile({
    super.key, 
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return ListTile(
      leading: Obx(() {
        final networkImage = controller.user.value.profilePicture;
        final image = networkImage.isNotEmpty ? networkImage : BImages.user;

        if (controller.imageUploading.value) {
          return const BShimmerEffect(width: 80, height: 80, radius: 80);
        }

        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => Dialog(
                backgroundColor: Colors.transparent,
                child: InteractiveViewer(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image(
                      image: networkImage.isNotEmpty
                          ? NetworkImage(networkImage)
                          : AssetImage(image) as ImageProvider,
                    ),
                  ),
                ),
              ),
            );
          },
          child: BCircularImage(
            image: image,
            width: 55,
            height: 55,
            isNetworkImage: networkImage.isNotEmpty,
          ),
        );
      }),
      title: Obx(()=> Text(controller.user.value.fullName, style: Theme.of(context).textTheme.headlineSmall!.apply(color: BColors.white))),
      subtitle: Text(controller.user.value.email, style: Theme.of(context).textTheme.bodyMedium !. apply(color: BColors.white)),
      trailing: IconButton (onPressed: onPressed, icon: const Icon(Iconsax.edit, color: BColors.white)),
    );
  }
}