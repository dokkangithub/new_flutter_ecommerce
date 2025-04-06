import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/enums/loading_state.dart';
import '../../product/controller/product_provider.dart';
import '../controller/reviews_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductReviews extends StatefulWidget {
  const ProductReviews({super.key});

  @override
  State<ProductReviews> createState() => _ProductReviewsState();
}

class _ProductReviewsState extends State<ProductReviews> {
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0.0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final productProvider = Provider.of<ProductDetailsProvider>(context, listen: false);
    if (productProvider.selectedProduct != null) {
      Provider.of<ReviewProvider>(context, listen: false)
          .fetchReviews(productProvider.selectedProduct!.id);
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        final productProvider = Provider.of<ProductDetailsProvider>(context, listen: false);
        if (productProvider.selectedProduct != null) {
          Provider.of<ReviewProvider>(context, listen: false)
              .loadMoreReviews(productProvider.selectedProduct!.id);
        }
      }
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ProductDetailsProvider, ReviewProvider>(
      builder: (context, productProvider, reviewProvider, child) {
        final product = productProvider.selectedProduct;

        if (product == null) {
          return const Center(child: Text('No product selected'));
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Reviews'),
          ),
          body: Column(
            children: [
              // Product Rating Summary
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.rating.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    RatingBarIndicator(
                      rating: product.rating,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20.0,
                    ),
                    const SizedBox(width: 8),
                    Text('(${product.ratingCount} reviews)'),
                  ],
                ),
              ),

              // Reviews List
              Expanded(
                child: reviewProvider.reviewState == LoadingState.loading
                    ? const Center(child: CircularProgressIndicator())
                    : reviewProvider.reviews.isEmpty
                    ? const Center(child: Text('No reviews yet'))
                    : ListView.builder(
                  controller: _scrollController,
                  itemCount: reviewProvider.reviews.length + (reviewProvider.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == reviewProvider.reviews.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final review = reviewProvider.reviews[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(review.avatar),
                      ),
                      title: Text(review.userName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RatingBarIndicator(
                            rating: review.rating,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 15.0,
                          ),
                          Text(review.comment),
                          Text(review.time),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showReviewDialog(context, product.id),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showReviewDialog(BuildContext context, int productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Review'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  _rating = rating;
                },
              ),
              TextField(
                controller: _reviewController,
                decoration: const InputDecoration(labelText: 'Your Review'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (_rating > 0 && _reviewController.text.isNotEmpty) {
                final success = await Provider.of<ReviewProvider>(context, listen: false)
                    .submitNewReview(productId, _rating, _reviewController.text);
                if (success) {
                  Navigator.pop(context);
                  _reviewController.clear();
                  _rating = 0.0;
                }
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}