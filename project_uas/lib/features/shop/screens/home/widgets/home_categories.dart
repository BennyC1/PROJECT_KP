import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/images_text_widgets/vertical_image_text.dart';
import 'package:project_uas/common/widgets/shimmer/category_shimmer.dart';
import 'package:project_uas/features/shop/controllers/category_controller.dart';
import 'package:project_uas/features/shop/screens/sub_category/sub_categories.dart';

class BHomeCategories extends StatelessWidget {
  const BHomeCategories ({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());

    return Obx(() {
      if(categoryController.isLoading.value) return const BCategoryShimmer();

      if(categoryController.featuredCategories.isEmpty){
        return Center(child: Text('No Data Found! ', style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white)));
      }

      return SizedBox (
        height: 80,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: categoryController.featuredCategories.length,
          scrollDirection: Axis. horizontal,
          itemBuilder: (_, index) {
            final category = categoryController.featuredCategories[index];
            return BVerticalImageText(image: category.image, title: category.name, 
            onTap: () => Get.to(() => SubCategoriesScreen(category: category)));
          }
        )
      );
    });
  }
}
