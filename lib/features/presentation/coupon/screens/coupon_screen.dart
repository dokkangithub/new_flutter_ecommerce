import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../controller/coupon_provider.dart';

class CouponScreen extends StatefulWidget {
  final Function(double)? onCouponApplied;
  
  const CouponScreen({
    super.key,
    this.onCouponApplied,
  });

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  final _couponController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isApplying = false;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply Coupon'),
        elevation: 0,
      ),
      body: Consumer<CouponProvider>(
        builder: (context, couponProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Coupon input form
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _couponController,
                    decoration: InputDecoration(
                      labelText: 'Coupon Code',
                      hintText: 'Enter coupon code',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _couponController.clear(),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a coupon code';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.characters,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Apply button
                ElevatedButton(
                  onPressed: _isApplying ? null : _applyCoupon,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: _isApplying
                      ? const CircularProgressIndicator()
                      : const Text('Apply Coupon'),
                ),
                
                const SizedBox(height: 24),
                
                // Applied coupon section
                if (couponProvider.appliedCoupon != null) ...[                  
                  _buildAppliedCouponCard(couponProvider),
                ],
                
                // Error message
                if (couponProvider.couponState == LoadingState.error) ...[                  
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      couponProvider.couponError,
                      style: TextStyle(color: Colors.red.shade800),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppliedCouponCard(CouponProvider couponProvider) {
    final appliedCoupon = couponProvider.appliedCoupon!;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    appliedCoupon.message,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            if (appliedCoupon.couponCode != null) ...[              
              const SizedBox(height: 8),
              Text(
                'Code: ${appliedCoupon.couponCode}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
            if (appliedCoupon.discountAmount != null) ...[              
              const SizedBox(height: 4),
              Text(
                'Discount: ${appliedCoupon.discountAmount}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: _removeCoupon,
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              label: const Text(
                'Remove Coupon',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyCoupon() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isApplying = true;
    });
    
    try {
      final couponCode = _couponController.text.trim();
      await context.read<CouponProvider>().applyCoupon(couponCode);
      
      final couponProvider = context.read<CouponProvider>();
      if (couponProvider.appliedCoupon?.success == true && 
          couponProvider.appliedCoupon?.discountAmount != null &&
          widget.onCouponApplied != null) {
        widget.onCouponApplied!(couponProvider.appliedCoupon!.discountAmount!);
      }
      
      if (mounted && couponProvider.appliedCoupon?.success == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(couponProvider.appliedCoupon!.message)),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isApplying = false;
        });
      }
    }
  }

  void _removeCoupon() async {
    setState(() {
      _isApplying = true;
    });
    
    try {
      await context.read<CouponProvider>().removeCoupon();
      
      if (mounted) {
        final couponProvider = context.read<CouponProvider>();
        if (couponProvider.appliedCoupon == null && widget.onCouponApplied != null) {
          widget.onCouponApplied!(0); // Reset discount to zero
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Coupon removed successfully')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isApplying = false;
        });
      }
    }
  }
}