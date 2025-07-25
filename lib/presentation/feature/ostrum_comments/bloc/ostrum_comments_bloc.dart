import 'ostrum_comments_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ostrum_test/domain/repositories/ostrum_comments/ostrum_comments_repository.dart';

class OstrumCommentsBloc extends Cubit<OstrumCommentsState> {
  OstrumCommentsBloc(this._repo) : super(const OstrumCommentsState());

  final OstrumCommentsRepository _repo;

  /// Add your business logic here
}
