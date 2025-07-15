import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_uas/features/shop/models/order_model.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';

class OrdersResultScreen extends StatelessWidget {
  const OrdersResultScreen({super.key});

  Future<List<OrderModel>> fetchCompletedOrders() async {
    final usersSnapshot = await FirebaseFirestore.instance.collection("Users").get();
    List<OrderModel> completedOrders = [];

    for (final userDoc in usersSnapshot.docs) {
      final ordersSnapshot = await userDoc.reference.collection("Orders").get();
      for (final orderDoc in ordersSnapshot.docs) {
        final data = orderDoc.data();
        if (data['status'] == 'OrderStatus.completed') {
          completedOrders.add(OrderModel.fromSnapshot(orderDoc));
        }
      }
    }

    return completedOrders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BAppBar(title: const Text('Completed Orders Report')),
      body: FutureBuilder<List<OrderModel>>(
        future: fetchCompletedOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          final orders = snapshot.data ?? [];

          if (orders.isEmpty) return const Center(child: Text("Tidak ada pesanan selesai."));

          return ListView.builder(
            itemCount: orders.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final o = orders[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text("Order ID: ${o.id}"),
                  subtitle: Text("Tanggal: ${o.formattedOrderDate}\nTotal: Rp ${o.totalAmount.toStringAsFixed(0)}\nUser: ${o.userId}"),
                  trailing: const Text("Completed", style: TextStyle(color: Colors.green)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
