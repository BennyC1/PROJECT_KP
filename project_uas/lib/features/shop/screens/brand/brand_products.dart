import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:project_uas/common/widgets/brands/brand_card.dart';
import 'package:project_uas/common/widgets/products/sortable/sortable_products.dart';
import 'package:project_uas/utils/constants/sized.dart';

class BrandProducts extends StatelessWidget {
  const BrandProducts({super.key});

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      appBar: BAppBar(title: Text('Aki Mobil')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(BSize. defaultSpace),
          child: Column(
            children: [
              /// Brand Detail
              BBrandCard (showBorder: true),
              SizedBox(height: BSize. spaceBtwSections),
              BSortableProducts(),
            ]
          ), 
        )
      )
    );
  }
} 