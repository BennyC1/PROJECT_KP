import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:project_uas/features/personalization/screens/profile/widgets/update_name_controller.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/constants/text_string.dart';
import 'package:project_uas/utils/validators/validators.dart';

class ChangeName extends StatelessWidget {
  const ChangeName({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateNameController());
    return Scaffold(
      /// Custom Appbar
      appBar: BAppBar(
        showBackArrow: true,
        title: Text( 'Change Name' , style: Theme.of(context).textTheme.headlineSmall),
      ), 
      body: Padding(
        padding: const EdgeInsets.all(BSize.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Headings
            Text(
              "Use real name for easy verification. This name will appear on several pages.",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: BSize.spaceBtwSections),

            /// Text field and Button
            Form(
              key: controller. updateUserNameFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller. firstName,
                    validator: (value) => BValidator.validateEmptyText( 'First name', value),
                    expands: false,
                    decoration: const InputDecoration(labelText: BText.firstName, prefixIcon: Icon(Iconsax.user)),
                  ),
                  const SizedBox(height: BSize.spaceBtwInputFields),
                  TextFormField(
                    controller: controller.lastName,
                    validator: (value) => BValidator.validateEmptyText('Last name', value),
                    expands: false,
                    decoration: const InputDecoration(labelText: BText.lastName, prefixIcon: Icon(Iconsax.user)),
                  ),
                ]
              )),
            const SizedBox(height: BSize.spaceBtwSections),

            /// Sove Button
            SizedBox (
              width: double.infinity,
              child: ElevatedButton(onPressed: () => controller.updateUserName(), child: const Text('Save')),
            ),
          ]
        )
      )
    );
  }
}


