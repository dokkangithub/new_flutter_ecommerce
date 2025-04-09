import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../controller/address_provider.dart';
import '../widgets/address_item_widget.dart';
import 'add_edit_address_screen.dart';

class AddressListScreen extends StatefulWidget {
  final bool isSelectable;
  
  const AddressListScreen({
    super.key,
    this.isSelectable = false,
  });

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressProvider>().fetchAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Addresses'),
        elevation: 0,
      ),
      body: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          if (addressProvider.addressState == LoadingState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (addressProvider.addressState == LoadingState.error) {
            return Center(
              child: Text(
                'Error: ${addressProvider.addressError}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (addressProvider.addresses.isEmpty) {
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
                  ElevatedButton.icon(
                    onPressed: () => _navigateToAddAddress(context),
                    icon: const Icon(Icons.add_location_alt),
                    label: const Text('Add New Address'),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: addressProvider.addresses.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final address = addressProvider.addresses[index];
                  return AddressItemWidget(
                    address: address,
                    isSelectable: widget.isSelectable,
                    onEdit: () => _navigateToEditAddress(context, address.id),
                    onDelete: () => _showDeleteConfirmation(context, address.id),
                    onSetDefault: () => addressProvider.makeAddressDefault(address.id),
                    onSelect: widget.isSelectable 
                      ? () => Navigator.pop(context, address)
                      : null,
                  );
                },
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  onPressed: () => _navigateToAddAddress(context),
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToAddAddress(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditAddressScreen(),
      ),
    ).then((_) {
      // Refresh the address list when returning from add screen
      context.read<AddressProvider>().fetchAddresses();
    });
  }

  void _navigateToEditAddress(BuildContext context, int addressId) {
    final addressProvider = context.read<AddressProvider>();
    final address = addressProvider.addresses.firstWhere((addr) => addr.id == addressId);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditAddressScreen(address: address),
      ),
    ).then((_) {
      // Refresh the address list when returning from edit screen
      addressProvider.fetchAddresses();
    });
  }

  void _showDeleteConfirmation(BuildContext context, int addressId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AddressProvider>().deleteAddress(addressId);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
