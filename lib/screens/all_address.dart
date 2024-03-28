import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_in/models/address.dart';
import 'package:shop_in/widget/add_edit_address.dart';

class AllAddressesPage extends StatefulWidget {
  const AllAddressesPage({super.key});

  @override
  State<AllAddressesPage> createState() => _AllAddressesPageState();
}

class _AllAddressesPageState extends State<AllAddressesPage> {
  List<Address> _addresses = [];

  void _navigateToAddAddress(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEditAddressPage()),
    );
    if (result != null) {
      // Handle new address saved
      _loadAddressesFromPrefs();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAddressesFromPrefs();
  }

  Future<void> _loadAddressesFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final addressesJson = prefs.getStringList('addresses') ?? [];
  setState(() {
    _addresses = addressesJson
        .map((json) => Address.fromJson(jsonDecode(json)))
        .toList();
  });
}

  Future<void> _saveAddressesToPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final addressesJson = _addresses.map((address) => jsonEncode(address.toJson())).toList();
  await prefs.setStringList('addresses', addressesJson);
}

  void _selectAddress() async {
    
  final selectedAddress = _addresses.firstWhere((address) => address.selected,
      orElse: () => Address(
          address: '',
          city: '',
          postcode: '',
          state: '')); // Get the selected address
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(
      'address',
      '${selectedAddress.address}, ${selectedAddress.city}, ${selectedAddress.postcode}, ${selectedAddress.state}'); // Save the selected address to SharedPreferences

  // Update the selected status for all addresses
  setState(() {
    for (var address in _addresses) {
      address.selected = (address == selectedAddress);
    }
  });

  _saveAddressesToPrefs(); // Save all addresses (including the selected one) to SharedPreferences
  Navigator.pop(
      // ignore: use_build_context_synchronously
      context,
      '${selectedAddress.address}, ${selectedAddress.city}, ${selectedAddress.postcode}, ${selectedAddress.state}'); // Return to the previous screen with the selected address
}

   void _removeSelectedAddresses() {
    setState(() {
      _addresses.removeWhere((address) => address.selected);
    });
    _saveAddressesToPrefs(); // Save the updated addresses to SharedPreferences
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('All Addresses'),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            _navigateToAddAddress(context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: _removeSelectedAddresses,
        ),
      ],
    ),
    body: ListView.builder(
      itemCount: _addresses.length,
      itemBuilder: (context, index) {
        final address = _addresses[index];
        return CheckboxListTile(
          title: Text('${address.address}, ${address.city}, ${address.postcode}, ${address.state}'),
          value: address.selected,
          onChanged: (value) {
            setState(() {
              // Clear the selected state of all addresses except the one being selected
              for (var addr in _addresses) {
                addr.selected = false;
              }
              address.selected = value ?? false;
            });
            _saveAddressesToPrefs(); // Save the updated addresses to SharedPreferences
          },
        );
      },
    ),
    floatingActionButton: ElevatedButton(
      onPressed: () {
        _selectAddress(); // Select the checked address
      },
      child: const Text('Select Address'),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
  );
}

}
