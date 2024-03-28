import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddEditAddressPage extends StatefulWidget {
  const AddEditAddressPage({super.key});

  @override
  State<AddEditAddressPage> createState() => _AddEditAddressPageState();
}

class _AddEditAddressPageState extends State<AddEditAddressPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postcodeController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add/Edit Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'City'),
            ),
            TextField(
              controller: _postcodeController,
              decoration: const InputDecoration(labelText: 'Postcode'),
            ),
            TextField(
              controller: _stateController,
              decoration: const InputDecoration(labelText: 'State'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final success = await _saveAddress();
                if (success) {
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context, true);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _saveAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final address = _addressController.text;
    final city = _cityController.text;
    final postcode = _postcodeController.text;
    final state = _stateController.text;

    final newAddress = {
      'address': address,
      'city': city,
      'postcode': postcode,
      'state': state,
    };

    List<String> addressesJson = prefs.getStringList('addresses') ?? [];
    addressesJson.add(jsonEncode(newAddress));
    await prefs.setStringList('addresses', addressesJson);
    setState(() {});
    return true;
  }

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _postcodeController.dispose();
    _stateController.dispose();

    super.dispose();
  }
}
