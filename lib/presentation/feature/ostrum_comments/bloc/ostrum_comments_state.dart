import 'package:freezed_annotation/freezed_annotation.dart';

part 'ostrum_comments_state.freezed.dart';
part 'ostrum_comments_state.g.dart';

@freezed
abstract class OstrumCommentsState with _$OstrumCommentsState {
  const factory OstrumCommentsState({
    @Default(false) bool error,
    @Default(false) bool isLoading,
  }) = _OstrumCommentsState;

  factory OstrumCommentsState.fromJson(Map<String, dynamic> json) =>
      _$OstrumCommentsStateFromJson(json);
}
