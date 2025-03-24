import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProductEditState extends ChangeNotifier {
  bool _isEditing = false;
  bool get isEditing => _isEditing;

  void toggleEdit() {
    _isEditing = !_isEditing;
    notifyListeners();
  }
}

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final List<Color> colorVariants = [
    const Color(0xFFFF9E80),
    const Color(0xFF1E88E5),
    const Color(0xFF42A5F5),
    const Color(0xFF2962FF),
    const Color(0xFF212121),
  ];

  int selectedColorIndex = 0;
  bool isFavorite = false;
  final titleController = TextEditingController(text: 'Nike Air Max 270 Essential');
  final priceController = TextEditingController(text: '\$179.39');
  final descriptionController = TextEditingController(
    text: 'The Max Air 270 Unit Delivers Unrivaled, All-Day Comfort. The Sleek, Running-Inspired Design Roots You To Everything Nike......',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductHeader(),
            _buildProductImage(),
            _buildColorVariants(),
            _buildDescription(),
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final isEditing = context.watch<ProductEditState>().isEditing;

    return AppBar(
      leading: const BackButton(),
      title: const Text('Sneaker Shop'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => context.read<ProductEditState>().toggleEdit(),
        ),
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () {},
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProductHeader() {
    final isEditing = context.watch<ProductEditState>().isEditing;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isEditing)
            TextField(
              controller: titleController,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            )
          else
            Text(
              titleController.text,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 8),
          const Text(
            "Men's Shoes",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          if (isEditing)
            TextField(
              controller: priceController,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            )
          else
            Text(
              priceController.text,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Center(
      child: Container(
        height: 200,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Image.network(
          'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-cUG6lK39CF6TiggYm64KvGZ3SP3CGe.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildColorVariants() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: colorVariants.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => setState(() => selectedColorIndex = index),
            child: Container(
              width: 48,
              height: 48,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: colorVariants[index],
                shape: BoxShape.circle,
                border: selectedColorIndex == index
                    ? Border.all(color: Colors.blue, width: 2)
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDescription() {
    final isEditing = context.watch<ProductEditState>().isEditing;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isEditing)
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            )
          else
            Text(
              descriptionController.text,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          TextButton(
            onPressed: () {},
            child: const Text('Read More'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    final isEditing = context.watch<ProductEditState>().isEditing;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () => setState(() => isFavorite = !isFavorite),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (isEditing) {
                  context.read<ProductEditState>().toggleEdit();
                } else {
                  // Add to cart logic
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isEditing ? 'Save' : 'Add to Cart',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}