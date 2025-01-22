
import 'package:flutter/material.dart';
import 'package:project_uas/features/shop/screens/product_reviews/widgets/progress_indicator_and_rating.dart';

class BOverallProductRating extends StatelessWidget {
  const BOverallProductRating ({
    super . key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 3, child: Text( '0', style: Theme.of(context).textTheme.displayLarge)),
        const Expanded (
          flex: 7,
          child: Column(
            children: [
              BRatingProgressIndicator(text: '5', value: 0),
              BRatingProgressIndicator(text:'4', value: 0),
              BRatingProgressIndicator(text:'3', value: 0),
              BRatingProgressIndicator(text: '2', value: 0),
              BRatingProgressIndicator(text: '1', value: 0),
            ]
          ),
        )
      ]
    );
  }
}