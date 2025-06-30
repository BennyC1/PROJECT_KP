import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class BCouponCode extends StatelessWidget {
  const BCouponCode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunctions.isDarkMode(context);
    
    return BRoundedContainer (
      showBorder: true,
      backgroundcolor: dark ? BColors.dark : BColors. white,
      padding: const EdgeInsets. only(top: BSize.sm, bottom: BSize.sm, right: BSize.sm, left: BSize.md),
      child: Row(
        children: [
          /// TextField
          Flexible(
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Have a promo code? Enter here',
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
            ),
          ),
    
          /// Button
          SizedBox(
            width: 80,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton. styleFrom(
                foregroundColor: dark ? BColors.white.withOpacity(0.5) : BColors.dark.withOpacity(0.5),
                backgroundColor: Colors.grey.withOpacity(.2),
                side: BorderSide(color: Colors.grey.withOpacity(0.1)),
              ),
              child: const Text('Apply' ),
            ),
          ),
        ],
      ),
    );
  }
}