import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SimpleBannerCarousel extends StatefulWidget {
  const SimpleBannerCarousel({super.key});

  @override
  State<SimpleBannerCarousel> createState() => _SimpleBannerCarouselState();
}

class _SimpleBannerCarouselState extends State<SimpleBannerCarousel> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentIndex = 0;

  // Default banner images
  final List<String> _bannerImages = [
    'https://img.freepik.com/free-photo/beautiful-sustainability-concept_23-2149261948.jpg?t=st=1741858512~exp=1741862112~hmac=a3bc469d1c6cecad6929917bb93c0cc9ade336165fb4c90a18d480068c1e708c&w=1480',
    'https://img.freepik.com/free-photo/beautiful-sustainability-concept_23-2149261946.jpg?t=st=1741858525~exp=1741862125~hmac=7a07692eb0f5d1627a90cc6493e06ea5060f4ef97da8ab6e6897b117d2a5e44c&w=1380',
    'https://img.freepik.com/free-vector/color-motivation-quote_2065-210.jpg?t=st=1741858541~exp=1741862141~hmac=6efc4f2002255205a347975523d0dd0da89327220431ce00c7b2a2ce88d13c4f&w=740',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              height: 150,
              aspectRatio: 16 / 9,
              viewportFraction: 0.9,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items: _bannerImages.map((imageUrl) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          ///indecator
          // const SizedBox(height: 12),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: _bannerImages
          //       .asMap()
          //       .entries
          //       .map((entry) {
          //     return GestureDetector(
          //       onTap: () => _carouselController.animateToPage(entry.key),
          //       child: Container(
          //         width: 8.0,
          //         height: 8.0,
          //         margin: const EdgeInsets.symmetric(horizontal: 4.0),
          //         decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           color: Theme
          //               .of(context)
          //               .primaryColor
          //               .withOpacity(
          //             _currentIndex == entry.key ? 1.0 : 0.4,
          //           ),
          //         ),
          //       ),
          //     );
          //   }).toList(),
          // ),
        ],
      ),
    );
  }
}
