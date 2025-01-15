import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/primary_header_container.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/search_container.dart';
import 'package:project_uas/common/widgets/images_text_widgets/vertical_image_text.dart';
import 'package:project_uas/common/widgets/layouts/grid.layout.dart';
import 'package:project_uas/common/widgets/products/products_cards/product_card_vertical.dart';
import 'package:project_uas/common/widgets/texts/section_heading.dart';
import 'package:project_uas/features/authentication/screens/home/widgets/home_appbar.dart';
import 'package:project_uas/features/authentication/screens/home/widgets/promo_slider.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BPrimaryHeaderContainer(
              child: Column (
                children: [
                  // home
                  const BHomeAppBar(),
                  const SizedBox(height: BSize.spaceBtwSections),

                  //search
                  const BSearchContainer(text: 'Search in Store'),
                  const SizedBox(height: BSize.spaceBtwSections),

                  Padding(
                    padding: const EdgeInsets.only(left: BSize.defaultSpace),
                    child: Column(
                      children: [
                        //Heading
                        const BSectionHeading(title: 'Popular Categories', showActionButton: false, textColor: Colors.white,),
                        const SizedBox(height: BSize.spaceBtwItems),

                        //Categories
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: 6,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_, index) {
                              return BVerticalImageText(image: BImages.shoeIcon, title: 'Shoe', onTap: (){},);
                            },
                          ),
                        )

                        
                      ],
                    ) 
                  )
                ]
              )
            ),
            Padding(
              padding: const EdgeInsets.all(BSize.defaultSpace),
              child: Column(
                children: [
                  // slide promo 3
                  const BPromoSlider(banners: [BImages.promoBanner1, BImages.promoBanner2, BImages.promoBanner3]),
                  const SizedBox(height: BSize.spaceBtwSections),

                  // isi produk
                  BGridLayout(itemCount: 6, itemBuilder: (_, index) => const BProductCardVertical())
                ]
              )
            ),
          ]
        ),
      ),
    );
  }
}



