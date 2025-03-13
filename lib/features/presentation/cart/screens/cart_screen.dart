import 'package:flutter/material.dart';
import '../../../../core/utils/widgets/custom_back_button.dart';
import '../../../../core/utils/widgets/product cards/custom_product_cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  List<Map<String, dynamic>> cartItems = [
    {
      'name': 'Nike Club Max',
      'price': 584.95,
      'image':
          'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-Q4eNlTtCLHyIDdbr0TQdmWwKkgVP5i.png',
      'quantity': 1,
    },
    {
      'name': 'Nike Air Max 200',
      'price': 94.05,
      'image':
          'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-Q4eNlTtCLHyIDdbr0TQdmWwKkgVP5i.png',
      'quantity': 1,
    },
    {
      'name': 'Nike Air Max 270 Essential',
      'price': 74.95,
      'image':
          'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-Q4eNlTtCLHyIDdbr0TQdmWwKkgVP5i.png',
      'quantity': 1,
    },
  ];

  double getItemTotal(Map<String, dynamic> item) {
    return (item['price'] as double) * (item['quantity'] as int);
  }

  @override
  Widget build(BuildContext context) {
    final double subtotal = cartItems.fold(
      0,
      (sum, item) => sum + getItemTotal(item),
    );
    final double deliveryFee = 60.20;
    final double totalCost = subtotal + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 100,
        leading: CustomBackButton(),
        title: const Text(
          'My Cart',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Cart item count
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${cartItems.length} Item${cartItems.length != 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
            ),
          ),

          // Cart items list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                // Use the ProductItemInCart widget with quantity controls
                return ProductItemInCart(
                  item: cartItems[index],
                  index: index,
                  onDelete: () {
                    setState(() {
                      cartItems.removeAt(index);
                    });
                  },
                  onQuantityChanged: (newQuantity) {
                    setState(() {
                      cartItems[index]['quantity'] = newQuantity;
                    });
                  },
                );
              },
            ),
          ),

          // Cost summary
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Subtotal',
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    Text(
                      '\$${subtotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Delivery',
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    Text(
                      '\$${deliveryFee.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Divider(color: Colors.grey, thickness: 1, height: 1),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Cost',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '\$${totalCost.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Checkout button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Checkout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
