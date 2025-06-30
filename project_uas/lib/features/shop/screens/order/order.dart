import 'package:flutter/material.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
import 'package:project_uas/features/shop/screens/order/widgets/orders_list.dart';
import 'package:project_uas/utils/constants/sized.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// -- AppBar
      appBar: BAppBar (title: Text('My Orders', style: Theme.of(context).textTheme.headlineSmall), showBackArrow: true),
      body: const Padding(
        padding: EdgeInsets.all(BSize.defaultSpace),

      // Orders
      child: BOrderListItems(),
      ), 
    );
  }
}