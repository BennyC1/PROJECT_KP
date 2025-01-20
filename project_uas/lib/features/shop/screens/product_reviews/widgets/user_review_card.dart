import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:project_uas/common/widgets/products/ratings/rating_indicator.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';
import 'package:readmore/readmore.dart';

class UserReviewCard extends StatelessWidget {
  const UserReviewCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = BHelperFunctions.isDarkMode(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(backgroundImage: AssetImage(BImages.userProfileImage1)),
                const SizedBox(width: BSize.spaceBtwItems),
                Text('John Doe', style: Theme.of(context). textTheme.titleLarge),
              ]
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ]
        ),
        const SizedBox(width: BSize.spaceBtwItems),

        /// Review
        Row(
          children: [
            const BRatingBarIndicator(rating: 4),
            const SizedBox(width: BSize.spaceBtwItems),
            Text('01 Nov, 2023', style: Theme.of(context).textTheme.bodyMedium),
          ]
        ),
        const SizedBox(height: BSize.spaceBtwItems),
        const ReadMoreText("The user interface of the app is quite intuitive. I was able to navigate and make purchases seamlessly. Great job!",
          trimLines: 2,
          trimMode: TrimMode. Line,
          trimExpandedText: ' show Less',
          trimCollapsedText: 'show more',
          moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: BColors.primary),
          lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: BColors.primary),
        ),
        const SizedBox(height: BSize.spaceBtwItems),

        /// Company Review
        BRoundedContainer(
          backgroundcolor: dark ? BColors.darkerGrey : BColors.grey,
          child: Padding(
            padding: const EdgeInsets.all(BSize.md),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("T's Store", style: Theme. of(context) . textTheme.titleMedium),
                    Text('02 Nov, 2023', style: Theme.of(context). textTheme. bodyMedium),
                  ]
                ),
                const SizedBox(height: BSize.spaceBtwItems),
                const ReadMoreText(
                  "The user interface of the app is quite intuitive. I was able to navigate and make purchases seamlessly. Great",
                  trimLines : 2,
                  trimMode: TrimMode.Line,
                  trimExpandedText: ' show Less',
                  trimCollapsedText: 'show mone',
                  moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: BColors.primary),
                  lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: BColors.primary),
                )
              ]
            ),
          ),
        ),
        const SizedBox(height: BSize.spaceBtwItems),
      ]
    );
  }
}



              
