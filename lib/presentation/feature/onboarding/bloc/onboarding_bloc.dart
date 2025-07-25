import 'dart:developer';

import 'package:ostrum_test/domain/repositories/onboarding/onboarding_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'onboarding_state.dart';

class OnboardingBloc extends Cubit<OnboardingState> {
  OnboardingBloc(this._repo) : super(const OnboardingState());

  final OnboardingRepository _repo;

  // final Repository _repo = Repository(); // Self-contained

  // void _showError(TryCatchError e) {
  //   emit(state.copyWith(error: true, isLoading: false));
  // }

  Future<void> completeOnboardingFlow() async {
    emit(state.copyWith(isLoading: true));
    try {
      await _repo.completeOnboarding();
      emit(state.copyWith(isCompleted: true, isLoading: false));
    } catch (_) {
      emit(state.copyWith(isLoading: false, error: true));
    }
  }

  void changeTab(int tabIndex) {
    emit(state.copyWith(currentTab: tabIndex));
  }

  void completeSlider() {
    // Trigger some action or log
    print('Slider successful');
  }

  void onSwipeUpdate(double delta, double maxDrag) {
    final newX = (state.dragX + delta).clamp(0.0, maxDrag);
    emit(state.copyWith(dragX: newX));
  }

  void updateDragX(double x) {
    emit(state.copyWith(dragX: x));
  }

  void onSwipeEnd(double maxDrag) {
    if (!state.sliderCompleted && state.dragX >= maxDrag) {
      log('slide completed');
      emit(state.copyWith(sliderCompleted: true));
      completeOnboardingFlow();
    }
  }
}
