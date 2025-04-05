import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryWithoutImageShimmer extends StatelessWidget {
  final int itemCount; // Allow customization of the number of shimmer items

  const CategoryWithoutImageShimmer({
    super.key,
    this.itemCount = 5, // Default to 5 shimmer categories
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 50,
        margin: const EdgeInsets.only(top: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return Container(
              width: 100, // Fixed width to simulate category chips
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            );
          },
        ),
      ),
    );
  }
}