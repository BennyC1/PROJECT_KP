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
  late TextEditingController descriptionTitleController;

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.product.title);
    priceController = TextEditingController(text: widget.product.price.toString());
    salePriceController = TextEditingController(text: widget.product.salePrice.toString());
    stockController = TextEditingController(text: widget.product.stock.toString());
    descriptionController = TextEditingController(text: widget.product.description);
    descriptionTitleController = TextEditingController(text: widget.product.descriptiontitle);
  }

  Future<void> saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final updatedProduct = widget.product.copyWith(
      title: titleController.text.trim(),
      price: double.tryParse(priceController.text) ?? widget.product.price,
      salePrice: double.tryParse(salePriceController.text) ?? widget.product.salePrice,
      stock: int.tryParse(stockController.text) ?? widget.product.stock,
      description: descriptionController.text.trim(),
      descriptiontitle: descriptionTitleController.text.trim(),
    );

    await ProductRepository.instance.updateProduct(updatedProduct);

    setState(() => isLoading = false);
    Get.back();
    Get.snackbar('Sukses', 'Produk berhasil diperbarui');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    InputDecoration _inputDecoration(String label, {String? prefixText}) {
      return InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        floatingLabelStyle: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
        ),
        prefixText: prefixText,
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isDark ? Colors.white54 : Colors.black54),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isDark ? Colors.white : Colors.black, width: 2),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Produk'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Perbarui Data Produk",
                style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Nama Produk
              TextFormField(
                controller: titleController,
                decoration: _inputDecoration('Nama Produk'),
                validator: (value) => value == null || value.isEmpty ? 'Judul tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              // Harga
              TextFormField(
                controller: priceController,
                decoration: _inputDecoration('Harga', prefixText: 'Rp '),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final val = double.tryParse(value ?? '');
                  return (val == null || val <= 0) ? 'Harga tidak valid' : null;
                },
              ),
              const SizedBox(height: 16),

              // Harga Diskon
              TextFormField(
                controller: salePriceController,
                decoration: _inputDecoration('Harga Diskon', prefixText: 'Rp '),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final val = double.tryParse(value ?? '');
                  return (val == null || val < 0) ? 'Masukkan angka valid' : null;
                },
              ),
              const SizedBox(height: 16),

              // Stok
              TextFormField(
                controller: stockController,
                decoration: _inputDecoration('Stok'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final val = int.tryParse(value ?? '');
                  return (val == null || val < 0) ? 'Masukkan stok valid' : null;
                },
              ),
              const SizedBox(height: 16),

              // Judul Deskripsi
              TextFormField(
                controller: descriptionTitleController,
                decoration: _inputDecoration('Judul Deskripsi'),
                
                validator: (value) => value == null || value.isEmpty ? 'Judul deskripsi wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Deskripsi
              TextFormField(
                controller: descriptionController,
                decoration: _inputDecoration('Deskripsi'),
                maxLines: 4,
                validator: (value) => value == null || value.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
              ),
              const SizedBox(height: 24),

              // Tombol Simpan
              ElevatedButton.icon(
                onPressed: isLoading ? null : saveChanges,
                icon: const Icon(Icons.save),
                label: isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text("Simpan Perubahan"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
