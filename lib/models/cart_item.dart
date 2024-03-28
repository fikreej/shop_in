class CartItem {
  final String productName;
  final int quantity;
  final int price;

  CartItem({
    required this.productName,
    required this.quantity,
    required this.price,
   
  });

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'quantity': quantity,
      'price': price,
      
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productName: json['productName'],
      quantity: json['quantity'] ?? 0,
      price: json['price'] ?? 0,
    );
  }
}