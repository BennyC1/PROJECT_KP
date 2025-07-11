
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/common/widgets/images/circular_image.dart';
import 'package:project_uas/common/widgets/texts/section_heading.dart';
import 'package:project_uas/features/personalization/controllers/user_controller.dart';
import 'package:project_uas/features/personalization/screens/profile/widgets/change_name.dart';
import 'package:project_uas/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/common/widgets/shimmer/shimmer.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sized.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super. key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: BAppBar(showBackArrow: true, title: Text('Profile', style: Theme.of(context).textTheme.headlineMedium)),
      // Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(BSize.defaultSpace),
          child: Column(
            children: [

              /// Profile Picture
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx(() {
                      final networkImage = controller.user.value.profilePicture;
                      final image = networkImage.isNotEmpty ? networkImage : BImages.user;
                      return controller.imageUploading.value
                        ? const BShimmerEffect(width: 80, height: 80, radius: 80)
                        : BCircularImage(image: image, width: 80, height: 80, isNetworkImage: networkImage.isNotEmpty);
                    }),
                    TextButton(onPressed: () => controller.uploadUserProfilePicture(), child: const Text( "Change Profile Picture")),
                  ],
                ),
              ),

              // DETAILS
              const SizedBox(height: BSize.spaceBtwItems / 2),
              const Divider (),
              const SizedBox (height: BSize.spaceBtwItems),

              /// Heading Profile Info
              const BSectionHeading(title: 'Profile Information', showActionButton: false),
              const SizedBox(height: BSize.spaceBtwItems),

              Obx(() => BProfileMenu(title: 'Name', value: controller.user.value.fullName, onPressed: () => Get.to(() => const ChangeName()))),
              BProfileMenu(
                title: 'Username',
                value: controller.user.value.username,
                onPressed: () {
                  Get.snackbar(
                    'Not Allowed',
                    'Username cannot be changed after registration.',
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(16),
                    backgroundColor: Colors.orange.withOpacity(0.1),
                    colorText: Colors.orange[900],
                    icon: const Icon(Icons.lock_outline, color: Colors.orange),
                    duration: const Duration(seconds: 2),
                  );
                },
              ),

              const SizedBox(height: BSize.spaceBtwItems),
              const Divider (),
              const SizedBox(height: BSize. spaceBtwItems),

              /// Heading Personal Info
              const BSectionHeading(title: 'Personal Information', showActionButton: false),
              const SizedBox (height: BSize.spaceBtwItems),

              BProfileMenu(
                title: 'User ID',
                value: controller.user.value.id,
                icon: Iconsax.copy,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: controller.user.value.id));
                  Get.snackbar(
                    'Copied',
                    'User ID has been copied to clipboard.',
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(16),
                    backgroundColor: Colors.green.withOpacity(0.1),
                    colorText: Colors.green[800],
                    icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                    duration: const Duration(seconds: 2),
                  );
                },
              ),
              BProfileMenu(
                title: 'E-mail',
                value: controller.user.value.email,
                onPressed: () {
                  Get.snackbar(
                    'Not Allowed',
                    'Email cannot be changed.',
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(16),
                    backgroundColor: Colors.red.withOpacity(0.1),
                    colorText: Colors.red,
                    icon: const Icon(Icons.lock, color: Colors.red),
                    duration: const Duration(seconds: 2),
                  );
                },
              ),
              Obx(
                () => BProfileMenu(title: 'Phone Number',
                  value: controller.user.value.phoneNumber.isEmpty ? 'Not Set' : controller.user.value.phoneNumber,
                  onPressed: () => controller.updatePhoneNumberDialog(context),
                ),
              ),
              Obx( ()=> BProfileMenu(title: 'Gender', value: controller.gender.value.isEmpty ? 'Not set' : controller.gender.value, onPressed: () => controller.selectGenderDialog())),
              Obx( ()=> BProfileMenu(title: 'Date of Birth', value: controller.dateOfBirth.value.isEmpty ? 'Not set' : controller.dateOfBirth.value, onPressed: () => controller.selectDateOfBirthDialog(context))),
              const Divider(),
              const SizedBox(height: BSize.spaceBtwItems),

              Center(
                child: TextButton(
                  onPressed: () => controller.deleteAccountWarningPopup(), 
                  child: const Text('Close Account', style: TextStyle(color: Colors.red)),
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}
     

