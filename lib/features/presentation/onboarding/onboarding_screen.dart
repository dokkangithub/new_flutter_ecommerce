import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:laravel_ecommerce/core/utils/constants/app_assets.dart';
import 'package:laravel_ecommerce/core/utils/local_storage/local_storage_keys.dart';

import '../../../core/config/routes.dart/routes.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/utils/local_storage/secure_storage.dart';



class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, String>> onboardingData = [
    {
      'title': 'Browse the menu and order directly from the application',
      'image': AppSvgs.onboarding1,
    },
    {
      'title':
          'Your order will be immediately collected an sent by our courier',
      'image': AppSvgs.onboarding2,
    },
    {
      'title': 'Pick up delivery at your door and enjoy your food',
      'image': AppSvgs.onboarding3,
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final secureStorage = sl<SecureStorage>();
    return Scaffold(
      backgroundColor: Color(0xFFF2E2D0),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder:
                    (context, index) => OnboardingContent(
                      image: onboardingData[index]['image']!,
                      title: onboardingData[index]['title']!,
                    ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(
                        onboardingData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_currentPage == onboardingData.length - 1) {
                          AppRoutes.navigateToAndRemoveUntil(
                            context,
                            AppRoutes.login,
                          );
                          secureStorage.save(LocalStorageKey.hasCompletedOnboarding, true);
                        } else {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInToLinear,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.all(15),
                      ),
                      child: Icon(
                        _currentPage == onboardingData.length - 1
                            ? Icons.check
                            : Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 5),
      height: 10,
      width: _currentPage == index ? 20 : 10,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.black : Colors.black26,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    super.key,
    required this.image,
    required this.title,
  });

  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  AppRoutes.navigateToAndRemoveUntil(context, AppRoutes.login);
                  sl<SecureStorage>().save(LocalStorageKey.hasCompletedOnboarding, true);
                },
                child: Text("SKIP", style: TextStyle(color: Colors.black54)),
              ),
            ],
          ),
        ),
        Spacer(),
        SvgPicture.asset(image, height: 250),
        Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        Spacer(),
      ],
    );
  }
}
