import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/config/routes.dart/routes.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../../domain/address/entities/address.dart';
import '../../../domain/payment/entities/payment_type.dart';
import '../../address/controller/address_provider.dart';
import '../../address/screens/address_list_screen.dart';
import '../../address/screens/add_edit_address_screen.dart';
import '../../cart/controller/cart_provider.dart';
import '../../coupon/controller/coupon_provider.dart';
import '../controller/payment_provider.dart';

class NewCheckoutScreen extends StatefulWidget {
  const NewCheckoutScreen({super.key});

  @override
  State<NewCheckoutScreen> createState() => _NewCheckoutScreenState();
}

class _NewCheckoutScreenState extends State<NewCheckoutScreen> {
  Address? _selectedAddress;
  bool _isProcessingPayment = false;
  final _couponController = TextEditingController();
  bool _isApplyingCoupon = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _loadData() async {
    final addressProvider = context.read<AddressProvider>();
    final paymentProvider = context.read<PaymentProvider>();
    final cartProvider = context.read<CartProvider>();

    // Load addresses
    await addressProvider.fetchAddresses();

    // Load payment methods
    await paymentProvider.fetchPaymentTypes();

    // Refresh cart summary
    await cartProvider.fetchCartSummary();

    // Set default address if available
    if (addressProvider.addresses.isNotEmpty) {
      final defaultAddress = addressProvider.addresses.firstWhere(
        (addr) => addr.isDefault,
        orElse: () => addressProvider.addresses.first,
      );

      setState(() {
        _selectedAddress = defaultAddress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer3<AddressProvider, PaymentProvider, CartProvider>(
        builder: (context, addressProvider, paymentProvider, cartProvider, _) {
          if (addressProvider.addressState == LoadingState.loading ||
              paymentProvider.paymentTypesState == LoadingState.loading ||
              cartProvider.cartState == LoadingState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shipping Address Section
                _buildShippingAddressSection(addressProvider),

                // Payment Method Section
                _buildPaymentMethodSection(paymentProvider),

                // Coupon Section
                _buildCouponSection(context),

                // Order Summary Section
                _buildOrderSummarySection(cartProvider),

                // Payment Button
                _buildPaymentButton(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildShippingAddressSection(AddressProvider addressProvider) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Shipping to',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () => _navigateToAddressList(),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                child: const Text('Change'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (addressProvider.addresses.isEmpty)
            _buildNoAddressWidget()
          else
            Column(
              children:
                  addressProvider.addresses.map((address) {
                    final isSelected = _selectedAddress?.id == address.id;
                    return _buildAddressItem(address, isSelected);
                  }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildNoAddressWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_off, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No addresses found',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _navigateToAddressList(),
            child: const Text('Add New Address'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressItem(Address address, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Radio<int>(
            value: address.id,
            groupValue: _selectedAddress?.id,
            onChanged: (value) {
              setState(() {
                _selectedAddress = address;
              });
            },
            activeColor: Colors.red,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${address.phone}',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                Text(
                  address.address,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.grey),
            onPressed: () => _navigateToEditAddress(address.id),
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(8),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection(PaymentProvider paymentProvider) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Payment method',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          if (paymentProvider.paymentTypes.isEmpty)
            const Center(child: Text('No payment methods available'))
          else
            Column(
              children:
                  paymentProvider.paymentTypes.map((paymentType) {
                    final isSelected =
                        paymentProvider.selectedPaymentTypeKey ==
                        paymentType.paymentTypeKey;
                    return _buildPaymentMethodItem(
                      paymentType,
                      isSelected,
                      paymentProvider,
                    );
                  }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodItem(
    PaymentType paymentType,
    bool isSelected,
    PaymentProvider paymentProvider,
  ) {
    // Map payment type keys to the icons shown in the design
    Widget paymentIcon;

    if (paymentType.paymentTypeKey == 'kashier') {
      paymentIcon = Image.network(
        paymentType.image,
        width: 40,
        height: 24,
        fit: BoxFit.contain,
      );
    } else if (paymentType.paymentTypeKey == 'paypal') {
      paymentIcon = Image.asset(
        'assets/images/paypal.png',
        width: 40,
        height: 24,
        fit: BoxFit.contain,
        errorBuilder:
            (context, error, stackTrace) => const Icon(Icons.payment, size: 24),
      );
    } else if (paymentType.paymentTypeKey == 'google_pay') {
      paymentIcon = Image.asset(
        'assets/images/google_pay.png',
        width: 40,
        height: 24,
        fit: BoxFit.contain,
        errorBuilder:
            (context, error, stackTrace) =>
                const Icon(Icons.g_mobiledata, size: 24),
      );
    } else {
      // Default for cash on delivery or other methods
      paymentIcon = Image.network(
        paymentType.image,
        width: 40,
        height: 24,
        fit: BoxFit.contain,
        errorBuilder:
            (context, error, stackTrace) =>
                const Icon(Icons.credit_card, size: 24),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Radio<String>(
            value: paymentType.paymentTypeKey,
            groupValue: paymentProvider.selectedPaymentTypeKey,
            onChanged: (value) {
              paymentProvider.selectPaymentType(value!);
            },
            activeColor: Colors.red,
          ),
          paymentIcon,
          const SizedBox(width: 12),
          Text(paymentType.name, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildCouponSection(BuildContext context) {
    return Consumer2<CouponProvider, CartProvider>(
      builder: (context, couponProvider, cartProvider, _) {
        final bool hasCoupon =
            cartProvider.cartSummary?.couponApplied == true &&
            cartProvider.cartSummary?.couponCode != null &&
            cartProvider.cartSummary!.couponCode!.isNotEmpty;
        // Only set isLoading when we're actively applying/removing a coupon
        final bool isLoading = _isApplyingCoupon;

        return Container(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Discount Coupon',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              if (hasCoupon) ...[
                // Applied coupon display
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartProvider.cartSummary!.couponCode!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Coupon applied successfully',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      isLoading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : TextButton(
                            onPressed: () => _removeCoupon(couponProvider),
                            child: const Text(
                              'Remove',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                    ],
                  ),
                ),
              ] else ...[
                // Coupon input field
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _couponController,
                        decoration: InputDecoration(
                          hintText: 'Enter coupon code',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                        enabled: true, // Always enabled
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _applyCoupon(couponProvider),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed:
                            isLoading
                                ? null
                                : () => _applyCoupon(couponProvider),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A3AFF),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child:
                            isLoading
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text('Apply'),
                      ),
                    ),
                  ],
                ),
                if (couponProvider.couponState == LoadingState.error) ...[
                  const SizedBox(height: 8),
                  Text(
                    couponProvider.couponError,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderSummarySection(CartProvider cartProvider) {
    if (cartProvider.cartSummary == null) {
      return const SizedBox();
    }

    return Consumer<CouponProvider>(
      builder: (context, couponProvider, _) {
        final bool hasCoupon =
            cartProvider.cartSummary!.couponApplied &&
            cartProvider.cartSummary!.couponCode != null &&
            cartProvider.cartSummary!.couponCode!.isNotEmpty;

        return Container(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Price Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              // Subtotal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Subtotal',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  Text(
                    '${cartProvider.cartSummary!.currencySymbol}${cartProvider.cartSummary!.subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Shipping fee
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Shipping fee',
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  Text(
                    '${cartProvider.cartSummary!.currencySymbol}${cartProvider.cartSummary!.shippingCost.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              // Tax (if available)
              if (cartProvider.cartSummary!.tax > 0) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tax',
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    Text(
                      '${cartProvider.cartSummary!.currencySymbol}${cartProvider.cartSummary!.tax.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],

              // Discount (always show, will be 0 if no coupon)
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Discount',
                    style: TextStyle(
                      color: hasCoupon ? Colors.green : Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    hasCoupon
                        ? '-${cartProvider.cartSummary!.currencySymbol}${cartProvider.cartSummary!.discount.toStringAsFixed(2)}'
                        : '${cartProvider.cartSummary!.currencySymbol}0.00',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: hasCoupon ? Colors.green : Colors.black,
                    ),
                  ),
                ],
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: Colors.grey, thickness: 1, height: 1),
              ),

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  Text(
                    '${cartProvider.cartSummary!.currencySymbol}${cartProvider.cartSummary!.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              // Coupon savings message
              if (hasCoupon) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'You saved ${cartProvider.cartSummary!.currencySymbol}${cartProvider.cartSummary!.discount.toStringAsFixed(2)} with coupon ${cartProvider.cartSummary!.couponCode}!',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: _isProcessingPayment ? null : () => _processPayment(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A3AFF),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child:
            _isProcessingPayment
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                  'Payment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
      ),
    );
  }

  void _navigateToAddressList() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddressListScreen(isSelectable: true),
      ),
    );

    if (result != null && result is Address) {
      setState(() {
        _selectedAddress = result;
      });
    }
  }

  void _navigateToEditAddress(int addressId) async {
    final addressProvider = context.read<AddressProvider>();
    final address = addressProvider.addresses.firstWhere(
      (addr) => addr.id == addressId,
    );

    // Navigate to edit address screen
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditAddressScreen(address: address),
      ),
    );

    // Refresh addresses after editing
    addressProvider.fetchAddresses();
  }

  Future<void> _applyCoupon(CouponProvider couponProvider) async {
    final couponCode = _couponController.text.trim();
    if (couponCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a coupon code')),
      );
      return;
    }

    setState(() {
      _isApplyingCoupon = true;
    });

    try {
      await couponProvider.applyCoupon(couponCode);

      // Refresh cart summary regardless of success/failure to get latest data
      await context.read<CartProvider>().fetchCartSummary();

      if (couponProvider.appliedCoupon?.success == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(couponProvider.appliedCoupon!.message)),
        );

        // Clear the text field
        _couponController.clear();
      } else if (couponProvider.appliedCoupon?.success == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(couponProvider.appliedCoupon!.message)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error applying coupon: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isApplyingCoupon = false;
        });
      }
    }
  }

  Future<void> _removeCoupon(CouponProvider couponProvider) async {
    setState(() {
      _isApplyingCoupon = true;
    });

    try {
      await couponProvider.removeCoupon();

      // Refresh cart summary after removing coupon
      await context.read<CartProvider>().fetchCartSummary();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coupon removed successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing coupon: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isApplyingCoupon = false;
        });
      }
    }
  }

  void _processPayment(BuildContext context) async {
    // Validate address
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a delivery address')),
      );
      return;
    }

    print('ssssss${_selectedAddress!.title}');
    print('ssssss${_selectedAddress!.address}');
    print('ssssss${_selectedAddress!.phone}');
    print('ssssss${_selectedAddress!.stateId}');
    print('ssssss${_selectedAddress!.cityName}');
    // Check if all required address fields are filled
    if (_selectedAddress!.address.isEmpty ||
        _selectedAddress!.phone.isEmpty ||
        _selectedAddress!.stateId <= 0 ||
        _selectedAddress!.cityName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Required fields (name, address, phone, state, city) are missing in the selected address'),
        ),
      );
      return;
    }

    // Validate payment method
    final paymentProvider = context.read<PaymentProvider>();
    if (paymentProvider.selectedPaymentTypeKey.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }

    setState(() {
      _isProcessingPayment = true;
    });

    try {
      print(
        'Processing payment with method: ${paymentProvider.selectedPaymentTypeKey}',
      );
      print(
        'Address: ${_selectedAddress!.title}, ${_selectedAddress!.address}, ${_selectedAddress!.cityName}, ${_selectedAddress!.stateId}',
      );

      final response = await paymentProvider.createOrder(
        postalCode: _selectedAddress!.postalCode,
        stateId: _selectedAddress!.stateId.toString(),
        address: _selectedAddress!.address,
        city: _selectedAddress!.cityName,
        phone: _selectedAddress!.phone,
        additionalInfo: '',
        context: context,
      );

      if (response.result && mounted) {
        // Clear cart after successful order
        context.read<CartProvider>().fetchCartItems();
        context.read<CartProvider>().fetchCartCount();

        // Navigate to success screen
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.successScreen,
          (route) => route.settings.name == AppRoutes.homeScreen,
        );
      } else if (!response.result && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${response.message}')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingPayment = false;
        });
      }
    }
  }
}
