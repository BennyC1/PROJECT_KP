import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:project_uas/common/widgets/products/sortable/sortable_products.dart';
import 'package:project_uas/utils/constants/sized.dart';

class AllProducts extends StatelessWidget {
  const AllProducts( {super. key}) ;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: BAppBar(title: Text('Popular Products'), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(BSize.defaultSpace),
          child: BSortableProducts(),
        )
      )
    );
  }
}

