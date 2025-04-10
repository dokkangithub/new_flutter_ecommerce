import 'package:flutter/material.dart';
import '../../../../core/utils/widgets/custom_button.dart';

class EmptyAddressWidget extends StatelessWidget {
  final VoidCallback onAddAddress;

  const EmptyAddressWidget({
    Key? key,
    required this.onAddAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No addresses found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add a new address to continue',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Add New Address',
            onPressed: onAddAddress,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(fontSize: 16),
            icon: 'assets/icons/location_add.png', // Make sure this asset exists or remove this line
          ),
        ],
      ),
    );
  }
}
