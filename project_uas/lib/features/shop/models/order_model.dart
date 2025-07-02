import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_uas/features/shop/models/cart_item_model.dart';
import 'package:project_uas/utils/constants/enums.dart';
import 'package:project_uas/utils/helpers/helper_function.dart';

class OrderModel {
  final String id;
  final String userId;
  final OrderStatus status;
  final double totalAmount;
  final DateTime orderDate;
  final String paymentMethod;
  // final AddressModel? address;
  final List<CartItemModel> items;

  OrderModel ({
    required this.id,
    this.userId = '',
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    this.paymentMethod = 'Qris',
    // this.address,
  });

  String get formattedOrderDate => BHelperFunctions.getFormattedDate(orderDate);

  String get orderStatusText => status == OrderStatus.pending
    ? 'Pending'
    : status == OrderStatus.processing
      ? 'Waiting For Payment'
      : 'Processing';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.toString(), // Enum to string
      'totalAmount': totalAmount,
      'orderDate': orderDate,
      'paymentMethod' : paymentMethod,
      // 'address': address ?. toJson(), // Convert AddressModel to map
      'items': items.map((item) => item.toJson()).toList(), // Convert CartItemModel to map
    };
  }

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return OrderModel(
      id: data['id'] as String,
      userId: data['userId'] as String,
      status: OrderStatus.values.firstWhere((e) => e.toString() == data['status']),
      totalAmount: data['totalAmount'] as double,
      orderDate: (data['orderDate'] as Timestamp).toDate(),
      paymentMethod: data['paymentMethod'] as String,
      // address: AddressModel. fromMap(data[ 'address' ] as Map<String, dynamic>),
      items: (data['items'] as List<dynamic>).map((itemData) => CartItemModel.fromJson(itemData as Map<String, dynamic>)).toList(),
    );
  }
}
  
