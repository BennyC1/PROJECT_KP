import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/data/product/product_repository.dart';
import 'package:project_uas/features/shop/function/product/product_edit_form.dart';
import 'package:project_uas/features/shop/models/product_model.dart';

class ProductEditListScreen extends StatelessWidget {
  const ProductEditListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Product to Edit')),
      body: FutureBuilder<List<ProductModel>>(
        future: ProductRepository.instance.getAllProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('No products found'));

          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: Image.network(product.thumbnail, width: 40, height: 40, fit: BoxFit.cover),
                title: Text(product.title),
                subtitle: Text('Rp ${product.price}'),
                onTap: () => Get.to(() => ProductEditFormScreen(product: product)),
              );
            },
          );
        },
      ),
    );
  }
}
