import 'package:flutter/material.dart';
import 'package:shop_in/screens/cart.dart';
import 'package:shop_in/screens/home.dart';
import 'package:shop_in/screens/order.dart';
import 'package:shop_in/screens/profile.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  late final List<Widget> _pages;
  late final List<String> _pageTitles;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeScreen(),
      const OrdersScreen(), 
      const ProfileScreen(),
    ];
    _pageTitles = ['Welcome to Shop In !', 'Orders', 'Profile'];
  }

  void _selectPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _navigateToCartScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_currentIndex]),
        actions: [
          IconButton(
            onPressed: () => _navigateToCartScreen(context),
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _selectPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_outlined),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}