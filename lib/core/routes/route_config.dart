import 'package:auto_route/auto_route.dart';
import 'package:ostrum_test/core/routes/route_config.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter({super.navigatorKey});
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: OnboardingRoute.page, initial: true),
    AutoRoute(page: OstrumCommentsRoute.page),
  ];
}
