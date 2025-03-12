import 'package:flutter/material.dart';
import 'shoe_card.dart';

class PopularShoes extends StatelessWidget {
  const PopularShoes({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Popular Shoes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See all',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ShoeCard(
                imageUrl: '/placeholder.svg?height=120&width=120',
                name: 'Nike Jordan',
                price: 302.00,
                isBestSeller: true,
                isFavorite: false,
                onFavoriteToggle: () {},
                onAddToCart: () {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ShoeCard(
                imageUrl: '/placeholder.svg?height=120&width=120',
                name: 'Nike Air Max',
                price: 752.00,
                isBestSeller: true,
                isFavorite: true,
                onFavoriteToggle: () {},
                onAddToCart: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

