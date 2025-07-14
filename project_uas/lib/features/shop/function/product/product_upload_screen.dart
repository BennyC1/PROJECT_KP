import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:project_uas/features/shop/function/product/product_upload_form.dart';

class ProductUploadScreen extends StatelessWidget {
  const ProductUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BAppBar(showBackArrow: true, title: Text('Upload Product', style: Theme.of(context).textTheme.headlineSmall)),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: ProductUploadForm(),
      ),
    );
  }
}

