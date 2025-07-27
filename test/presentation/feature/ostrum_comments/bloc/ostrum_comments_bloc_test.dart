import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ostrum_test/domain/models/comment/comment_model.dart';
import 'package:ostrum_test/domain/repositories/ostrum_comments/ostrum_comments_repository.dart';
import 'package:ostrum_test/presentation/feature/ostrum_comments/bloc/ostrum_comments_bloc.dart';
import 'package:ostrum_test/presentation/feature/ostrum_comments/bloc/ostrum_comments_state.dart';

class MockRepo extends Mock implements OstrumCommentsRepository {}

class MockHydratedStorage extends Mock implements HydratedStorage {}

void main() {
  late MockRepo repo;
  late OstrumCommentsBloc bloc;
  late MockHydratedStorage hydratedStorage;

  setUpAll(() {
    // initialize MockHydratedStorage.
    hydratedStorage = MockHydratedStorage();

    // By default, read returns null, simulating no cached state.
    when(() => hydratedStorage.read(any())).thenReturn(null);
    // write, delete, and clear will do nothing.
    when(() => hydratedStorage.write(any(), any())).thenAnswer((_) async {});
    when(() => hydratedStorage.delete(any())).thenAnswer((_) async {});
    when(() => hydratedStorage.clear()).thenAnswer((_) async {});

    HydratedBloc.storage = hydratedStorage;
  });

  setUp(() {
    repo = MockRepo();
  });

  // to close the test after done
  tearDown(() {
    bloc.close();
  });

  // test sample data.
  final comment = CommentModel(postId: 1, id: 1, name: 'Test User', email: 'test@user.com', body: 'Comment body');

  // Group related tests for better organization.
  group('OstrumCommentsBloc', () {
    // mocking for testing successful data fetch.
    blocTest<OstrumCommentsBloc, OstrumCommentsState>(
      'emits [loading and success] when fetchOstrumComments is successful',
      build: () {
        // mocking the repo's [fetchOstrumComments] method to return a list of comments successfully.
        when(() => repo.fetchComments()).thenAnswer((_) async => [comment]);
        // passing repo value to bloc
        bloc = OstrumCommentsBloc(repo);
        return bloc; // returns the bloc instance
      },
      // fetching data operation
      act: (bloc) => bloc.fetchOstrumComments(),
      expect:
          () => [
            // expecting loading state while fetching
            const OstrumCommentsState(isLoading: true),
            // when successful expect data passing and loading to false
            OstrumCommentsState(isLoading: false, comments: [comment]),
          ],
    );

    // mocking for testing failed data fetch.
    blocTest<OstrumCommentsBloc, OstrumCommentsState>(
      'emits [loading and error] when fetchOstrumComments fails',
      build: () {
        // Mock the repo's fetchOstrumComments method to throw an exception and simulating a failure.
        when(() => repo.fetchComments()).thenThrow(Exception('Failed to fetch comments'));
        bloc = OstrumCommentsBloc(repo);
        return bloc;
      },
      act: (bloc) => bloc.fetchOstrumComments(),
      expect:
          () => [
            // loading state expecting
            const OstrumCommentsState(isLoading: true),
            // failure expecting
            const OstrumCommentsState(isLoading: false, error: true),
          ],
    );

    // mocking for testing successful cache clearing
    blocTest<OstrumCommentsBloc, OstrumCommentsState>(
      'emits [loading and success] and calls delete on storage when clearCache is successful',
      build: () {
        // prepare delete method to give the successful operation
        when(() => hydratedStorage.delete('OstrumCommentsBloc')).thenAnswer((_) async {});
        bloc = OstrumCommentsBloc(repo);
        return bloc;
      },
      // providing initial value through seed to perform delete operation
      seed: () => OstrumCommentsState(isLoading: false, comments: [comment]),
      act: (bloc) => bloc.clearCache(),
      expect:
          () => [
            // at starting the bloc will emit loading with data state
            OstrumCommentsState(isLoading: true, comments: [comment]),
            // after successful deletion, it will show loading false and null data
            const OstrumCommentsState(isLoading: false, comments: []),
          ],
      verify: (_) {
        // to check how many times the delete function is called while doing the operation
        verify(() => hydratedStorage.delete('OstrumCommentsBloc')).called(1);
      },
    );

    // mocking for testing failed cache clearing.
    blocTest<OstrumCommentsBloc, OstrumCommentsState>(
      'emits [loading and error] when clearCache fails',
      build: () {
        // prepare delete method to throw the error after the operation
        when(() => hydratedStorage.delete('OstrumCommentsBloc')).thenThrow(Exception('Failed to delete cache'));
        bloc = OstrumCommentsBloc(repo);
        return bloc;
      },
      // adding the data to state to perform delete operation
      seed: () => OstrumCommentsState(isLoading: false, comments: [comment]),
      act: (bloc) => bloc.clearCache(),
      expect:
          () => [
            // expecting loading and data state before operation
            OstrumCommentsState(isLoading: true, comments: [comment]),
            // failure of deletion with data still there and error state getting triggered
            OstrumCommentsState(isLoading: false, error: true, comments: [comment]),
          ],
      verify: (_) {
        // to check how many times the delete function is called while doing the operation
        verify(() => hydratedStorage.delete('OstrumCommentsBloc')).called(1);
      },
    );
  });
}
