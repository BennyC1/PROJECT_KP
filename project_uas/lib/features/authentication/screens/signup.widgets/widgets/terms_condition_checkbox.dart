import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:project_uas/features/authentication/controllers/signup/signup_controller.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/constants/text_string.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BTermConditionCheckbox extends StatelessWidget {
  const BTermConditionCheckbox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    final dark = BHelperFunctions.isDarkMode(context);
    return Row(
      children: [
        SizedBox(width: 24, height: 24, child: Obx( () => Checkbox(value: controller.privacyPolicy.value, onChanged: (value) => controller.privacyPolicy.value = !controller.privacyPolicy.value))),
        const SizedBox(width: BSize.spaceBtwItems),
        Text.rich(
          TextSpan(children: [
            TextSpan(text: '${BText.iAgreeTo} ', style: Theme.of(context).textTheme.bodySmall),
            TextSpan(text: '${BText.privacyPolicy} ', style: Theme.of(context).textTheme.bodyMedium!.apply(
              color: dark ? BColors.white : BColors.primary,
              decoration: TextDecoration.underline,
              decorationColor: dark ? BColors.white : BColors.primary,
            )),
            TextSpan(text: '${BText.and} ', style: Theme.of(context).textTheme.bodySmall),
            TextSpan(text: BText.termsOfUse, style: Theme.of(context).textTheme.bodyMedium!.apply(
              color: dark ? BColors.white : BColors.primary,
              decoration: TextDecoration.underline,
              decorationColor: dark ? BColors.white : BColors.primary,
            )),
          ])
        ),
      ],
    );
  }
}