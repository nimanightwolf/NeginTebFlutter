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
          const SizedBox(
            height: 20,
          ),
          buildPageIndicator(onboardingProvider.currentPage, totalPages, context),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPageIndicator(int currentIndex, int totalPages, BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: currentIndex == index ? 12 : 8,
          height: currentIndex == index ? 12 : 8,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentIndex == index
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primary.withValues(alpha: 0.3)),
        ),
      ),
    );
  }
}
