import 'package:hydrated_bloc/hydrated_bloc.dart';

mixin SafeEmitMixin<State> on HydratedCubit<State> {
  void safeEmit(State newState) {
    if (!isClosed) {
      emit(newState);
    }
  }
}
