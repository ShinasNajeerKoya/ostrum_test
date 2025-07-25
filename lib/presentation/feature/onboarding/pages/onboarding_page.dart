import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:ostrum_test/core/routes/route_config.gr.dart';

import '../../../../config/themes/colors.dart';
import '../../../../config/themes/units.dart';
import '../../../../generated/app_icons.dart';
import '../../../../shared/helper_functions/custom_svg_icon.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_state.dart';

@RoutePage()
class OnboardingPage extends StatelessWidget {
  static const id = '/onboardingPage';

  OnboardingPage({super.key});

  final PageController _controller = PageController();
  final onboardingBloc = GetIt.I<OnboardingBloc>();

  final List<OnboardingPageModel> pages = [
    OnboardingPageModel(title: '', subtitle: ''),
    OnboardingPageModel(title: 'ss', subtitle: 'sldls'),
    OnboardingPageModel(title: 'sds', subtitle: 'fdf'),
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
            BlocBuilder<OnboardingBloc, OnboardingState>(
              bloc: onboardingBloc,
              buildWhen: (prev, curr) => prev.currentTab != curr.currentTab,
              builder: (context, state) {
                final currentTab = state.currentTab;

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

            SwipeToGetStarted(onboardingBloc: onboardingBloc),
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

class SwipeToGetStarted extends StatefulWidget {
  final double maxDrag;
  final OnboardingBloc onboardingBloc;

  const SwipeToGetStarted({super.key, this.maxDrag = 200.0, required this.onboardingBloc});

  @override
  State<SwipeToGetStarted> createState() => _SwipeToGetStartedState();
}

class _SwipeToGetStartedState extends State<SwipeToGetStarted> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  void _animateToEnd() {
    final currentX = widget.onboardingBloc.state.dragX;
    final distanceLeft = widget.maxDrag - currentX;

    _controller.reset();
    final tween = Tween<double>(begin: currentX, end: widget.maxDrag);

    _animation =
        tween.animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
          ..addListener(() {
            widget.onboardingBloc.updateDragX(_animation.value);
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              widget.onboardingBloc.onSwipeEnd(widget.maxDrag);
            }
          });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      bloc: widget.onboardingBloc,
      buildWhen: (prev, curr) => prev.dragX != curr.dragX || prev.sliderCompleted != curr.sliderCompleted,
      builder: (context, state) {
        if (state.sliderCompleted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.router.replaceAll([OstrumCommentsRoute()]);
          });
        }

        return SizedBox(
          height: 60.h,
          width: widget.maxDrag + 60.w,
          child: Stack(
            children: [
              // Background container
              Container(
                height: 60.h,
                width: double.infinity,
                padding: leftPadding40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                alignment: Alignment.center,
                child: Text('swipe to get startedddd', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500)),
              ),

              // Swipe button
              Positioned(
                top: 6.h,
                left: state.dragX + 6.w,
                child: GestureDetector(
                  onTap: () {
                    if (!state.sliderCompleted) {
                      _animateToEnd();
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    _isDragging = true;
                    double newX = widget.onboardingBloc.state.dragX + details.delta.dx;

                    // Limit backward drag after reaching max drag
                    if (widget.onboardingBloc.state.sliderCompleted) {
                      double minAllowedX = widget.maxDrag - (widget.maxDrag / 5.w);
                      newX = newX.clamp(minAllowedX, widget.maxDrag);
                    } else {
                      newX = newX.clamp(0.0, widget.maxDrag);
                    }

                    widget.onboardingBloc.updateDragX(newX);
                  },
                  onHorizontalDragEnd: (_) {
                    if (_isDragging) {
                      _isDragging = false;

                      final currentX = widget.onboardingBloc.state.dragX;

                      // If near start, slide back to zero
                      if (currentX <= widget.maxDrag * 0.2) {
                        final tween = Tween<double>(begin: currentX, end: 0.0);
                        _controller.reset();
                        _animation = tween.animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
                          ..addListener(() {
                            widget.onboardingBloc.updateDragX(_animation.value);
                          });
                        _controller.forward();
                      } else {
                        _animateToEnd();
                      }
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    height: 48.h,
                    width: 48.w,
                    padding: allPadding14,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [BoxShadow(color: Colors.grey.shade400, spreadRadius: 1, blurRadius: 10)],
                    ),
                    child: CustomSvgIcon(AppIcons.kDoubleArrowMark, color: AppColors.kCarousalPrimaryCream),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
