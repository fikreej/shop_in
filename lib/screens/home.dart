import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_in/screens/product_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _products = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String? _selectedCategory; 
  
  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/products'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
        if (decodedResponse.containsKey('products') && decodedResponse['products'] is List) {
          setState(() {
            _products = decodedResponse['products'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Invalid data format';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load products: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load products: $error';
      });
    }
  }

  void _navigateToProductDetails(BuildContext context, dynamic product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: product)),
    );
  }

  void _filterByCategory(String? category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
Widget build(BuildContext context) {
  List<dynamic> filteredProducts = _selectedCategory != null && _selectedCategory != 'All'
      ? _products.where((product) => product['category'] == _selectedCategory).toList()
      : _products;

  return Scaffold(
    
    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _errorMessage.isNotEmpty
            ? Center(child: Text(_errorMessage))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 8.0,
                    children: <Widget>[
                      FilterChip(
                        label: const Text('All'),
                        selected: _selectedCategory == null,
                        onSelected: (_) => _filterByCategory(null),
                      ),
                      FilterChip(
                        label: const Text('Smartphones'),
                        selected: _selectedCategory == 'smartphones',
                        onSelected: (_) => _filterByCategory('smartphones'),
                      ),
                      FilterChip(
                        label: const Text('Laptops'),
                        selected: _selectedCategory == 'laptops',
                        onSelected: (_) => _filterByCategory('laptops'),
                      ),
                      FilterChip(
                        label: const Text('Fragrances'),
                        selected: _selectedCategory == 'fragrances',
                        onSelected: (_) => _filterByCategory('fragrances'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (BuildContext context, int index) {
                        final product = filteredProducts[index];
                        return GestureDetector(
                          onTap: () => _navigateToProductDetails(context, product),
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  product['thumbnail'] ?? '',
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  product['title'] ?? '',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.0,),
                                ),
                                Text(
                                  'Price: \$${product['price'] ?? 'N/A'}',
                                  style: const TextStyle(color: Colors.black, fontSize: 10.0),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  product['description'] ?? 'No description available',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 9.0),
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
