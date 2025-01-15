
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/common/widgets/images/circular_image.dart';
import 'package:project_uas/common/widgets/texts/section_heading.dart';
import 'package:project_uas/features/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:project_uas/utils/constants/image_string.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sized.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super. key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BAppBar(showBackArrow: true, title: Text('Profile')),
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
                    const BCircularImage(image: BImages.user, width: 80, height: 80),
                    TextButton(onPressed: (){}, child: const Text( "Change Profile Picture")),
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

              BProfileMenu(title: 'Name', value: 'BennyCuandraaa', onPressed: () {}),
              BProfileMenu(title: 'Username', value: 'BennyCuandraaa', onPressed: () {}),

              const SizedBox(height: BSize.spaceBtwItems),
              const Divider (),
              const SizedBox(height: BSize. spaceBtwItems),

              /// Heading Personal Info
              const BSectionHeading(title: 'Personal Information', showActionButton: false),
              const SizedBox (height: BSize. spaceBtwItems),

              BProfileMenu(title: 'User ID', value: '45689', icon: Iconsax.copy, onPressed: () {}),
              BProfileMenu(title: 'E-mail', value: 'nyakuuuu@yuhuu', onPressed: () {}),
              BProfileMenu(title: 'Phone Number', value: '123', onPressed: () {}),
              BProfileMenu(title: 'Gender :', value: 'GTW', onPressed: () {}),
              BProfileMenu(title: 'Date of Birth', value: 'KEPO', onPressed: () {}),
              const Divider(),
              const SizedBox(height: BSize. spaceBtwItems),

              Center(
                child: TextButton(
                  onPressed: () {}, 
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
     

