import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_uas/features/shop/models/cart_item_model.dart';
import 'package:project_uas/utils/constants/enums.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class OrderModel {
  final String docId;
  final String id;
  final String userId;
  final OrderStatus status;
  final double totalAmount;
  final DateTime orderDate;
  final String paymentMethod;
  final List<CartItemModel> items;
  final String? paymentProofUrl;

  OrderModel ({
    required this.docId,
    required this.id,
    this.userId = '',
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    this.paymentMethod = 'Qris',
    this.paymentProofUrl,
  });

  String get formattedOrderDate => BHelperFunctions.getFormattedDate(orderDate);

  String get orderStatusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.completed:
        return 'Selesai';
      case OrderStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.toString(), // Enum to string
      'totalAmount': totalAmount,
      'orderDate': orderDate,
      'paymentMethod' : paymentMethod,
      'paymentProofUrl': paymentProofUrl,
      'items': items.map((item) {
        final data = item.toJson();
        data.remove('Stock'); 
        return data;
    }).toList(),
    };
  }

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return OrderModel(
      docId: snapshot.id, 
      id: data['id'] as String,
      userId: data['userId'] as String,
      status: OrderStatus.values.firstWhere((e) => e.toString() == data['status']),
      totalAmount: data['totalAmount'] as double,
      orderDate: (data['orderDate'] as Timestamp).toDate(),
      paymentMethod: data['paymentMethod'] as String,
      paymentProofUrl: data['paymentProofUrl'],
      items: (data['items'] as List<dynamic>).map((itemData) => CartItemModel.fromJson(itemData as Map<String, dynamic>)).toList(),
    );
  }
}
  
