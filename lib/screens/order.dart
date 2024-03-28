import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late List<Map<String, dynamic>> _orders;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = prefs.getString('orders') ?? '[]';
    final List<dynamic> ordersList = jsonDecode(ordersJson);
    setState(() {
      _orders = ordersList.cast<Map<String, dynamic>>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (context, index) {
          final order = _orders[index];
          final createdAt = DateTime.parse(order['createdAt']);
          final formattedDate =
              '${createdAt.day}/${createdAt.month}/${createdAt.year}';
          final formattedTime = '${createdAt.hour}:${createdAt.minute}';

          // Extract item names and join them with commas
          final itemNames = order['items']
              .map<String>((item) => item['productName'] as String)
              .join(', ');

          return Card(
            child: ListTile(
              title: Text('Order #${index + 1}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Items: $itemNames'),
                  Text('Total Price: RM ${order['totalPrice']}'),
                  Text('Created On: $formattedDate at $formattedTime'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsScreen(order: order,),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({required this.order,super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Date: ${order['createdAt'].substring(0, 10)}', // Extract date
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Order Time: ${order['createdAt'].substring(11)}', // Extract time
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Delivery Address: ${order['shippingAddress']}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Items:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              itemCount: order['items'].length,
              itemBuilder: (context, index) {
                final item = order['items'][index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Item: ${item['productName']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('Quantity: ${item['quantity']}'),
                      Text('Price: RM ${item['price']}'),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Total Order Price: RM ${order['totalPrice']}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
