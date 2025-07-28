import 'package:flutter/material.dart';
import 'package:neginteb/features/onboarding/presentation/onboarding_provider.dart';
import 'package:neginteb/features/onboarding/presentation/widgets/onboarding_button.dart';
import 'package:neginteb/features/onboarding/presentation/widgets/onboarding_item.dart';
import 'package:neginteb/routes/app_route.dart';
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

    final theme = Theme.of(context);

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
              children: [
                OnboardingButton(
                    visible: onboardingProvider.currentPage > 0,
                    icon: Icons.arrow_back,
                    onPressed: () => _previosPage(),
                    backgroundColor: Colors.transparent,
                    iconColor: theme.colorScheme.primary),
                OnboardingButton(
                    visible: onboardingProvider.currentPage < totalPages - 1,
                    icon: Icons.arrow_forward,
                    onPressed: () => _nextPage(),
                    backgroundColor: theme.colorScheme.primary,
                    iconColor: Colors.white),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          if (totalPages > 1) ...[
            AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return SizeTransition(
                    child: child,
                    sizeFactor: animation,
                    axisAlignment: -1,
                  );
                },
                child: onboardingProvider.currentPage == totalPages - 1
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, AppRoute.home);
                              },
                              child: const Text('ورود به فروشگاه')),
                        ),
                      )
                    : null)
          ]
        ],
      ),
    );
  }

  void _nextPage() {
    final onboardingProvider = Provider.of<OnboardingProvider>(context, listen: false);
    if (onboardingProvider.currentPage < onboardingProvider.onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  void _previosPage() {
    final onboardingProvider = Provider.of<OnboardingProvider>(context, listen: false);
    if (onboardingProvider.currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
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
