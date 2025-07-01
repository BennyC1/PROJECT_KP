class CartItemModel {
  String productId;
  String title;
  double price;
  String? image;
  int quantity;
  String? brandName;
  int stock;

  /// Constructor
  CartItemModel({
    required this.productId,
    required this.quantity,
    this.image = '',
    this.price = 0.0,
    this.title = '',
    this.brandName,
    required this.stock,
  });

  /// Empty Cart
  static CartItemModel empty() => CartItemModel(productId: '', quantity: 0, stock: 0);

  /// Convert a CartItem to a JSON Map
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'image': image,
      'quantity': quantity,
      'brandName': brandName,
      'stock': stock,
    };
  }
 
  /// create cart item from JSON Map
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId : json['productId'],
      title : json['title'],
      price : json['price']?.toDouble(),
      image : json['image'],
      quantity : json['quantity'],
      brandName : json['brandName'],
      stock: json['stock'] ?? 0,
    );
  }
}