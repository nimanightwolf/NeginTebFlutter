import 'package:flutter/material.dart';
import 'package:hotelino/features/onboarding/presentation/onboarding_provider.dart';
import 'package:hotelino/features/onboarding/presentation/widgets/onboarding_item.dart';
import 'package:provider/provider.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final onboardingProvider = Provider.of<OnboardingProvider>(context);

    final onboardingData = onboardingProvider.onboardingData;
    final int totalPages = onboardingData.length;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: PageView.builder(
            controller: _pageController,
            itemCount: totalPages,
            onPageChanged: onboardingProvider.updateCurrentPage,
            itemBuilder: (context, index) {
              final data = onboardingData[index];
              return OnboardingItem(
                  title: data["title"]!, description: data["description"]!, image: data["image"]!);
            },
          )),
        ],
      ),
    );
  }
}
