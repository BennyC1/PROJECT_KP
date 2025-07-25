import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:project_uas/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:project_uas/features/shop/controllers/product/order_controller.dart';
import 'package:project_uas/navigation_menu.dart';
import 'package:project_uas/utils/constants/colors.dart';
import 'package:project_uas/utils/constants/enums.dart';
import 'package:project_uas/utils/constants/image_string.dart';
import 'package:project_uas/utils/constants/sized.dart';
import 'package:project_uas/utils/helpers/cloud_helper_functions.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';
import 'package:project_uas/utils/loaders/animation_loader.dart';



class BOrderListItems extends StatelessWidget {
  const BOrderListItems({super.key});
  
  @override
  Widget build (BuildContext context) {
    final dark = BHelperFunctions.isDarkMode(context);
    final controller = Get.find<OrderController>();

    return FutureBuilder(
      future: controller.fetchUserOrders(),
      builder: (context, snapshot) {
        /// Nothing Found Widget
        final emptyWidget = BAnimationLoaderWidget(
          text: 'Whoops! No Orders Yet!',
          animation: BImages.orderCompletedAnimation,
          showAction: true,
          actionText: 'Let\'s fill it',
          onActionPressed: () => Get.off(() => const NavigationMenu()),
        );

        /// Helper Function: Handle Loader, No Record, OR ERROR Message
        final response = BCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, nothingFound: emptyWidget);
        if (response != null) return response;

        ///  Record found.
        final orders = snapshot.data !;
        return ListView.separated(
          shrinkWrap: true,
          itemCount: orders.length,
          separatorBuilder: (_, __) => const SizedBox(height: BSize.spaceBtwItems),
          itemBuilder: (_, index) {
            final order = orders[index];
            return BRoundedContainer(           
              showBorder: true,
              padding: const EdgeInsets.all(BSize.md),
              backgroundcolor: dark? BColors.dark: BColors.light,
              child: Column (
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// row 1
                  Row(
                    children: [
                      /// 1 Icon
                      const Icon(Iconsax.ship),
                      const SizedBox (width: BSize.spaceBtwItems / 2),
            
                      /// 2 Status & Date
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.orderStatusText,
                              style: Theme.of(context).textTheme.bodyLarge!.apply(color: BColors.primary, fontWeightDelta: 1),
                            ),
                            Text(order.formattedOrderDate, style: Theme.of(context).textTheme.headlineSmall),
                          ]
                        ),
                      ),
                      // 3 icon
                      IconButton(onPressed: () {}, icon: const Icon(Iconsax.arrow_right_34, size: BSize.iconSm)),
                    ]
                  ),
                  const SizedBox(height: BSize.spaceBtwItems),
            
                  /// row 2
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            /// 1 Icon
                            const Icon(Iconsax.tag),
                            const SizedBox (width: BSize.spaceBtwItems / 2),
                        
                            /// 2 Status & Date
                            Flexible(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order', 
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.labelMedium),
                                  Text(
                                    order.id,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis, 
                                    style: Theme.of(context).textTheme.titleMedium),
                                ]
                              ),
                            ),
                          ]
                        ),
                      ),
                      // Order Date
                      Expanded(
                        child: Row(
                          children: [
                            /// 1 Icon
                            const Icon(Iconsax.calendar),
                            const SizedBox (width: BSize.spaceBtwItems / 2),
                        
                            /// 2 Status & Date
                            Flexible(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order Date!',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis, 
                                    style: Theme.of(context).textTheme.labelMedium),
                                  Text(
                                    order.formattedOrderDate,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis, 
                                    style: Theme.of(context).textTheme.titleMedium),
                                ]
                              ),
                            ),
                          ]
                        ),
                      ),
                    ],
                  ),
                  if (order.status == OrderStatus.pending) ...[
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final confirm = await Get.dialog(AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: const Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: Colors.red),
                            SizedBox(width: 8),
                            Text("Konfirmasi Pembatalan"),
                          ],
                        ),
                        content: const Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Apakah Anda yakin ingin membatalkan pesanan ini?",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 12),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: "• Bukti pembatalan dikirim via WhatsApp ke "),
                                  TextSpan(
                                    text: "0822-8600-0946",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(text: ".\n• "),
                                  TextSpan(
                                    text: "Biaya pajak tidak dapat dikembalikan.",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          OutlinedButton(
                            onPressed: () => Get.back(result: false),
                            child: const Text("Tidak Jadi"),
                          ),
                          FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                            onPressed: () => Get.back(result: true),
                            child: const Text("Ya, Batalkan"),
                          ),
                        ],
                      ));

                        if (confirm == true) {
                          await controller.cancelOrder(order);
                        }
                      },
                      icon: const Icon(Icons.cancel_outlined, size: 20),
                      label: const Text(
                        "Batalkan Pesanan",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                    ),
                  ],
                ]
              )          
            );
          }
        );
      }
    );
  }
}
