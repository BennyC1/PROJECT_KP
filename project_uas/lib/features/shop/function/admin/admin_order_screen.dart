import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/features/shop/controllers/product/order_controller.dart';
import 'package:project_uas/features/shop/models/order_model.dart';
import 'package:project_uas/utils/constants/enums.dart';

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  final controller = Get.put(OrderController());
  OrderStatus? selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Pesanan')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<OrderStatus?>(
              value: selectedStatus,
              hint: const Text('Filter berdasarkan status'),
              items: const [
                DropdownMenuItem(value: null, child: Text('Semua')),
                DropdownMenuItem(value: OrderStatus.pending, child: Text('Pending')),
                DropdownMenuItem(value: OrderStatus.processing, child: Text('Processing')),
                DropdownMenuItem(value: OrderStatus.completed, child: Text('Completed')),
                DropdownMenuItem(value: OrderStatus.cancelled, child: Text('Cancelled')),
              ],
              onChanged: (value) => setState(() => selectedStatus = value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.filter_list),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<OrderModel>>(
              future: controller.fetchAllOrdersForAdmin(),
              builder: (context, snapshot) {
                
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Tidak ada pesanan ditemukan'));
                }

                final filtered = selectedStatus == null
                  ? snapshot.data!.where((o) =>
                      o.status == OrderStatus.pending || o.status == OrderStatus.processing).toList()
                  : snapshot.data!.where((o) => o.status == selectedStatus).toList();


                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final order = filtered[index];
                    return ListTile(
                      title: Text('Order ID: ${order.id}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('User: ${order.userId}'),
                          Text('Total: Rp ${order.totalAmount.toStringAsFixed(0)}'),
                          Text('Status: ${order.orderStatusText}'),
                          if (order.paymentProofUrl != null && order.paymentProofUrl!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => Dialog(
                                      child: InteractiveViewer(
                                        child: Image.network(order.paymentProofUrl!),
                                      ),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    order.paymentProofUrl!,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      trailing: DropdownButton<OrderStatus>(
                        value: order.status,
                        underline: const SizedBox(),
                        items: OrderStatus.values.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(status.name.capitalizeFirst!),
                          );
                        }).toList(),
                        onChanged: (newStatus) async {
                          if (newStatus != null && newStatus != order.status) {
                            await controller.updateOrderStatus(order, newStatus);
                            setState(() {}); // Refresh tampilan
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
