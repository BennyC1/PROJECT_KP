import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';
import 'package:project_uas/common/widgets/shimmer/shimmer.dart';

class BCircularImage extends StatelessWidget {
  const BCircularImage({
    super.key,
    this.width = 56,
    this.height = 56,
    this.overlayColor,
    this.backgroundColor,
    required this.image,
    this.fit = BoxFit.cover,
    this.padding = BSize.sm,
    this.isNetworkImage = false,
  });

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets. all (padding),
      decoration: BoxDecoration(
        // If image background color is nutt then switch it to Light and dark mode cotor design.
        color: backgroundColor ?? (BHelperFunctions.isDarkMode(context) ? BColors.black : BColors.white),
        borderRadius: BorderRadius.circular(180),
      ), // BoxDecoration
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Center(
          child: isNetworkImage 
          ? CachedNetworkImage(
            fit: fit,
            color: overlayColor,
            imageUrl: image,
            progressIndicatorBuilder: (context, url, downloadProgress) => const BShimmerEffect(width: 55, height: 55, radius: 55),
            errorWidget: (context, url, error) => const Icon(Icons. error),
          )
          : Image(
            fit: fit,
            image: isNetworkImage ? NetworkImage(image) : AssetImage(image) as ImageProvider,
            color: overlayColor
          )
        ),
      )
    );
  }
}