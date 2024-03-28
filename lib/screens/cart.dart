import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_in/models/cart_item.dart';
import 'package:shop_in/screens/all_address.dart';
import 'package:shop_in/screens/order.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> _cartItems = [];
  String _address = '';

  @override
  void initState() {
    super.initState();
    _loadCartItemsFromPrefs();
    _loadAddressFromPrefs();
  }

  Future<void> _loadCartItemsFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItemsJson = prefs.getStringList('cartItems') ?? [];
    setState(() {
      _cartItems = cartItemsJson
          .map((json) => CartItem.fromJson(jsonDecode(json)))
          .toList();
    });
  }

  Future<void> _loadAddressFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final storedAddress = prefs.getString('address') ??
        ''; // Retrieve the address from SharedPreferences
    setState(() {
      _address = storedAddress;
    });
  }

  void _changeAddress() async {
    final newAddress = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const AllAddressesPage())); 
    if (newAddress != null && newAddress is String) {
      setState(() {
        _address = newAddress; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = _calculateTotalPrice();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = _cartItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(cartItem.productName),
                    subtitle: Text('Price: RM ${cartItem.price.toString()}'),
                    trailing: Text('Quantity: ${cartItem.quantity}'),
                    tileColor: Colors
                        .white, 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: const BorderSide(color: Colors.grey), 
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Shipping Address:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _address.isNotEmpty ? _address : 'No Address Selected',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _changeAddress(); 
            },
            child: const Text('Change'),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Total Price: RM ${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _clearCart();
                  },
                  child: const Text('Clear Cart'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    _createOrder(); 
                  },
                  child: const Text('Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _calculateTotalPrice() {
    int totalPrice = 0;
    for (var cartItem in _cartItems) {
      totalPrice += cartItem.quantity * cartItem.price;
    }
    return totalPrice;
  }

  Future<void> _clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartItems');
    setState(() {
      _cartItems = [];
    });
  }

  void _createOrder() async {
  final prefs = await SharedPreferences.getInstance();

  try {
    DateTime now = DateTime.now();
    final Map<String, dynamic> orderData = {
      'items': _cartItems.map((item) => item.toJson()).toList(),
      'totalPrice': _calculateTotalPrice(),
      'shippingAddress': _address,
      'createdAt': now.toString(),
    };
    await prefs.setString('orderData', jsonEncode(orderData));
    _clearCart();

    // Fetch existing orders or initialize an empty list
    final List<Map<String, dynamic>> existingOrders =
        jsonDecode(prefs.getString('orders') ?? '[]')
            .cast<Map<String, dynamic>>();

    // Add the newly created order to existing orders
    existingOrders.add(orderData);

    // Store the updated orders list
    await prefs.setString('orders', jsonEncode(existingOrders));

    // Navigate to the order details screen and pass the order data
    Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(order: orderData),
      ),
    );
  } catch (error) {
    // ignore: avoid_print
    print('Error creating order: $error');
  }
}
}
