import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:project_uas/common/widgets/products/sortable/sortable_products.dart';
import 'package:project_uas/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:project_uas/features/shop/controllers/all_product_controller.dart';
import 'package:project_uas/features/shop/models/product_model.dart';
import 'package:project_uas/utils/constants/sized.dart';

class AllProducts extends StatelessWidget {
  const AllProducts({super.key, required this.title, this.query, this.futureMethod,}) ;

  final String title;
  final Query? query;
  final Future<List<ProductModel>>? futureMethod;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllProductsController());
    
    return Scaffold(
      appBar: BAppBar(title: Text(title), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(BSize.defaultSpace),
          child: FutureBuilder(
            future: futureMethod ?? controller.fetchProductsByQuery(query),
            builder: (context, snapshot) {
              const loader = BVerticalProductShimmer();
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loader;
              }
              if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(child: Text('No Data Found!'));
              }

              if (snapshot. hasError) {
              return const Center(child: Text('Something went wrong.'));
              }

              // Products found!
              final products = snapshot.data !;

              return BSortableProducts(products: products);
            }
          ),
        )
      )
    );
  }
}

