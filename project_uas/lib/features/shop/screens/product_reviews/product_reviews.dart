
import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:project_uas/common/widgets/products/ratings/rating_indicator.dart';
import 'package:project_uas/features/shop/screens/product_reviews/widgets/rating_progress_indicator.dart';
import 'package:project_uas/utils/constants/sized.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Appbar
      appBar: const BAppBar(title: Text('Reviews & Ratings'), showBackArrow: true),

      /// Body
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(BSize.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Ratings and reviews are verified and are from people who use the same type of device that you use. "),
              const SizedBox(height: BSize.spaceBtwItems),

              // overall product rating
              const BOverallProductRating (),
              const BRatingBarIndicator(rating: 0),
              Text("0", style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: BSize.spaceBtwSections),
            ]
          )
        )
      )
    );
  }
}

