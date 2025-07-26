import 'package:ostrum_test/domain/repositories/onboarding/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  @override
  Future<void> completeOnboarding() async {
    await Future.delayed(Duration(milliseconds: 100));
  }
}
