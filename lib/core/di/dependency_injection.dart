// core/di/injector.dart

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../network/api_client.dart';
import '../routes/route_config.dart';

final getIt = GetIt.instance;

class GetItHelper {
  static void init() {
    /// AppRouter
    getIt.registerSingleton<AppRouter>(AppRouter());


    /// Dio instance with headers
    getIt.registerSingleton<Dio>(
      Dio(BaseOptions(headers: {'User-Agent': 'Flutter-App'})),
    );

    /// ApiClient using the Dio instance
    // getIt.registerSingleton<ApiClient>(ApiClient(dio: getIt<Dio>()));

    /// service
    // getIt.registerSingleton<OstrumService>(OstrumService(getIt<ApiClient>()));

    /// Repositories -- add after each feature generation
    // getIt.registerSingleton<OstrumRepository>(OstrumRepositoryImpl(getIt<OstrumService>()));

    /// BloCs -- add after each feature generation
    // getIt.registerSingleton<OstrumBloc>(OstrumBloc(getIt<OstrumRepository>()));
  }

  void dispose() {
    // optional: clear bloc states or dispose streams if needed
  }
}
