import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_in/models/cart_item.dart';
import 'package:shop_in/screens/cart.dart';
import 'package:shop_in/widget/add_to_cart_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  final dynamic product;

  const ProductDetailsScreen({required this.product,super.key});

  void _navigateToCartScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>  const CartScreen(),
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['title'] ?? ''),
        actions: [IconButton(onPressed: () => _navigateToCartScreen(context), icon: const Icon(Icons.trolley),)],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            Image.network(
              product['thumbnail'] ?? '',
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Rating: ${product['rating'] ?? 'N/A'}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                Text(
                    'Price: RM${product['price'] ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20.0),
            Text(
              product['description'] ?? 'No description available',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
            onPressed: () {
            showAddToCartModal(context, product,_addToCart);
            },
            child: const Text('Add to Cart'),
            )
          ],
        ),
      ),
    );
  }
  void _addToCart(CartItem newItem) async {
    final prefs = await SharedPreferences.getInstance();
    final cartItemsJson = prefs.getStringList('cartItems') ?? [];
    cartItemsJson.add(jsonEncode(newItem.toJson()));
    await prefs.setStringList('cartItems', cartItemsJson);
  }
}