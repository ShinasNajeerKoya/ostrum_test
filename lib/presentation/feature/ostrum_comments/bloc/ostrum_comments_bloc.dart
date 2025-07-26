import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../../shared/helper_functions/future_try_catch_helper/future_try_catch_helper.dart';
import 'ostrum_comments_state.dart';
import 'package:ostrum_test/domain/repositories/ostrum_comments/ostrum_comments_repository.dart';

class OstrumCommentsBloc extends HydratedCubit<OstrumCommentsState> {
  OstrumCommentsBloc(this._repo) : super(const OstrumCommentsState());

  final OstrumCommentsRepository _repo;

  Future<void> fetchOstrum() async {
    emit(state.copyWith(isLoading: true));

    await futureTryCatch(
      () async {
        final data = await _repo.fetchComments();
        emit(state.copyWith(isLoading: false, comments: data));
      },
      onError: (error) {
        emit(state.copyWith(error: true, isLoading: false));
      },
    );
  }

  void reset() {
    emit(const OstrumCommentsState());
  }

  /// Clear cached hydrated state
  Future<void> clearCache() async {
    await HydratedBloc.storage.delete('OstrumBloc');
  }

  @override
  OstrumCommentsState fromJson(Map<String, dynamic> json) => OstrumCommentsState.fromJson(json);

  @override
  Map<String, dynamic> toJson(OstrumCommentsState state) => state.toJson();
}
