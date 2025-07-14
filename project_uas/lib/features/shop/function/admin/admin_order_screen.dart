import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_uas/common/widgets/appbar/appbar.dart';
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
  final TextEditingController _searchController = TextEditingController();
  List<OrderModel> _allOrders = [];
  List<OrderModel> _filteredOrders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
    _searchController.addListener(_applyFilters);
  }

  void _loadOrders() async {
    final orders = await controller.fetchAllOrdersForAdmin();
    setState(() {
      _allOrders = orders;
      _applyFilters();
    });
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    final statusFilter = selectedStatus;

    setState(() {
      _filteredOrders = _allOrders.where((order) {
        final matchesQuery = order.id.toLowerCase().contains(query);
        final matchesStatus = statusFilter == null
            ? order.status == OrderStatus.pending || order.status == OrderStatus.processing
            : order.status == statusFilter;
        return matchesQuery && matchesStatus;
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: BAppBar(showBackArrow: true, title: Text('Kelola Pesanan', style: Theme.of(context).textTheme.headlineSmall)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Field
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search Order ID... ',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),

                // Dropdown Filter
                DropdownButtonFormField<OrderStatus?>(
                  value: selectedStatus,
                  hint: const Text('Filter berdasarkan status'),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Semua')),
                    DropdownMenuItem(value: OrderStatus.pending, child: Text('Pending')),
                    DropdownMenuItem(value: OrderStatus.processing, child: Text('Processing')),
                    DropdownMenuItem(value: OrderStatus.completed, child: Text('Completed')),
                    DropdownMenuItem(value: OrderStatus.cancelled, child: Text('Cancelled')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                      _applyFilters();
                    });
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.filter_list),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),

          // List of Orders
          Expanded(
            child: _filteredOrders.isEmpty
                ? const Center(child: Text('Tidak ada pesanan ditemukan'))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    itemCount: _filteredOrders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final order = _filteredOrders[index];

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        color: isDark ? Colors.grey[900] : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.receipt_long_rounded, size: 30),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Order ID: ${order.id}',
                                            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 4),
                                        Text('User ID: ${order.userId}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                  DropdownButton<OrderStatus>(
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
                                        _loadOrders();
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(text: 'Total: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                    TextSpan(text: 'Rp ${order.totalAmount.toStringAsFixed(0)}\n'),
                                    const TextSpan(text: 'Status: ', style: TextStyle(fontWeight: FontWeight.bold)),
                                    TextSpan(text: order.orderStatusText),
                                  ],
                                ),
                              ),
                              if (order.paymentProofUrl != null && order.paymentProofUrl!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: GestureDetector(
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (_) => Dialog(
                                        child: InteractiveViewer(
                                          child: Image.network(order.paymentProofUrl!),
                                        ),
                                      ),
                                    ),
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
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
