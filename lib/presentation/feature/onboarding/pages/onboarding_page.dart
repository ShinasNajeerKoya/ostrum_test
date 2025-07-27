import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../config/themes/colors.dart';
import '../../../../config/themes/units.dart';
import '../../../../generated/app_icons.dart';
import '../../../../shared/helper_functions/custom_svg_icon.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_state.dart';
import '../widgets/swipe_to_get_started_widget.dart';

@RoutePage()
class OnboardingPage extends StatelessWidget {
  static const id = '/onboardingPage';

  OnboardingPage({super.key});

  final PageController _controller = PageController();
  final onboardingBloc = GetIt.I<OnboardingBloc>();

  final List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      title: 'Welcome to Ostrum!',
      subtitle: 'Fetch and explore user comments in real-time from the cloud.',
    ),
    OnboardingPageModel(
      title: 'Smooth Loading Experience',
      subtitle: 'Enjoy a beautiful shimmer effect while your data loads.',
    ),
    OnboardingPageModel(
      title: 'Smart Cache Management',
      subtitle: 'Reload or clear cached comments with a single tap.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kCreamBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            verticalMargin20,

            // 🔴 Top container for SVG
            SizedBox(height: 380.h, width: double.infinity, child: CustomSvgIcon(AppIcons.kOnboardingLogo)),

            verticalMargin12,

            // 🟠 Middle: Carousel Text
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) => onboardingBloc.changeTab(index),
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return Padding(
                    padding: horizontalPadding24,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          page.title,
                          style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        verticalMargin20,
                        Text(
                          page.subtitle,
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // 🟢 Dot Indicator (wrapped in BlocBuilder)
            BlocSelector<OnboardingBloc, OnboardingState, int>(
              bloc: onboardingBloc,
              selector: (state) => state.currentTab,
              builder: (context, currentTab) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: horizontalPadding4,
                      width: currentTab == index ? 12.w : 6.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color:
                            currentTab == index ? AppColors.kCarousalPrimaryCream : AppColors.kCarousalSecondaryCream,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                );
              },
            ),
            verticalMargin24,

            SwipeToGetStartedWidget(onboardingBloc: onboardingBloc),
            verticalMargin24,
          ],
        ),
      ),
    );
  }
}

class OnboardingPageModel {
  final String title;
  final String subtitle;

  const OnboardingPageModel({required this.title, required this.subtitle});
}

