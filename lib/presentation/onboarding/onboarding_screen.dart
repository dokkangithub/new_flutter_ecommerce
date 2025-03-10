import 'package:flutter/material.dart';
import 'package:laravel_ecommerce/config/routes.dart/routes.dart';
import 'package:provider/provider.dart';
import 'controller/provider.dart';
import 'data/onboarding_data.dart';
import 'data/onboarding_model.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingProvider(),
      child: Scaffold(
        body: Consumer<OnboardingProvider>(
          builder: (context, provider, _) {
            return Stack(
              children: [
                // PageView for onboarding pages
                PageView.builder(
                  itemCount: onboardingData.length,
                  onPageChanged: (index) {
                    provider.setPage(index);
                  },
                  itemBuilder: (context, index) {
                    return OnboardingPage(
                      model: onboardingData[index],
                    );
                  },
                ),

                // Bottom navigation (dots and button)
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      // Page indicator dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          onboardingData.length,
                              (index) =>
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5),
                                child: CircleAvatar(
                                  radius: 5,
                                  backgroundColor: provider.currentPage == index
                                      ? Colors.purple
                                      : Colors.grey.shade300,
                                ),
                              ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Next/Finish button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              provider.isLastPage
                                  ? AppRoutes.navigateToAndRemoveUntil(context, AppRoutes.login)
                                  :null
                              ;
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              provider.isLastPage ? 'Finish' : 'Next',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}


class OnboardingPage extends StatelessWidget {
  final OnboardingModel model;

  const OnboardingPage({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Column(
        children: [
          // Image section (takes approximately 2/3 of the screen)
          Expanded(
            flex: 3,
            child: Image.asset(
              model.imagePath,
              fit: BoxFit.cover,
            ),
          ),

          // Text content section (takes approximately 1/3 of the screen)
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    model.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    model.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
