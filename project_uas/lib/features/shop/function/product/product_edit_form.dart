import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/features/shop/models/product_model.dart';
import 'package:project_uas/data/product/product_repository.dart';

class ProductEditFormScreen extends StatefulWidget {
  final ProductModel product;
  const ProductEditFormScreen({super.key, required this.product});

  @override
  State<ProductEditFormScreen> createState() => _ProductEditFormScreenState();
}

class _ProductEditFormScreenState extends State<ProductEditFormScreen> {
  late TextEditingController titleController;
  late TextEditingController priceController;
  late TextEditingController salePriceController;
  late TextEditingController stockController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.product.title);
    priceController = TextEditingController(text: widget.product.price.toString());
    salePriceController = TextEditingController(text: widget.product.salePrice.toString());
    stockController = TextEditingController(text: widget.product.stock.toString());
    descriptionController = TextEditingController(text: widget.product.description);
  }

  void saveChanges() async {
    final updatedProduct = widget.product.copyWith(
      title: titleController.text,
      price: double.tryParse(priceController.text) ?? widget.product.price,
      salePrice: double.tryParse(salePriceController.text) ?? widget.product.salePrice,
      stock: int.tryParse(stockController.text) ?? widget.product.stock,
      description: descriptionController.text,
    );

    await ProductRepository.instance.updateProduct(updatedProduct);
    Get.back(); // Kembali ke daftar
    Get.snackbar('Success', 'Product updated successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
            TextField(controller: salePriceController, decoration: const InputDecoration(labelText: 'Sale Price'), keyboardType: TextInputType.number),
            TextField(controller: stockController, decoration: const InputDecoration(labelText: 'Stock'), keyboardType: TextInputType.number),
            TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),

            const SizedBox(height: 20),
            ElevatedButton(onPressed: saveChanges, child: const Text('Save Changes')),
          ],
        ),
      ),
    );
  }
}
