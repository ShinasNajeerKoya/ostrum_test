import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ostrum_test/data/repositories/ostrum_comments/ostrum_comments_repository_impl.dart';
import 'package:ostrum_test/data/services/comment_service/comment_service.dart';
import 'package:ostrum_test/domain/models/comment/comment_model.dart';

class MockOstrumCommentService extends Mock implements OstrumCommentService {}

void main() {
  late OstrumCommentsRepositoryImpl repository;
  late MockOstrumCommentService mockService;

  setUp(() {
    mockService = MockOstrumCommentService();
    repository = OstrumCommentsRepositoryImpl(mockService);
  });

  // test case 1: verifies that fetchComments correctly maps JSON data to CommentModel.
  test('fetchComments maps json to CommentModel', () async {
    // raw data mocking
    final List<Map<String, dynamic>> rawJson = [
      {'postId': 1, 'id': 1, 'name': 'Test', 'email': 'test@email.com', 'body': 'Sample'},
    ];

    // mocking fetchCommentsRaw from service file
    when(() => mockService.fetchCommentsRaw()).thenAnswer((_) async => rawJson);

    final result = await repository.fetchComments();

    // 1. checking if the data properly converted to list of model
    expect(result, isA<List<CommentModel>>());
    // 2. checking if the data has intended number of entry
    expect(result.length, 1);
    // 3. checking if the data has properly converted and no loss of data or corruption of data
    expect(result.first.name, 'Test');
    expect(result.first.email, 'test@email.com');
    expect(result.first.body, 'Sample');

    verify(() => mockService.fetchCommentsRaw()).called(1);
  });

  // Test case 2: testing for empty list
  test('fetchComments returns an empty list when service returns empty', () async {
    when(() => mockService.fetchCommentsRaw()).thenAnswer((_) async => []);

    final result = await repository.fetchComments();

    // 1. checking if the return type is list of comment model.
    expect(result, isA<List<CommentModel>>());
    // 2. Verify that the list is null.
    expect(result, isEmpty);

    verify(() => mockService.fetchCommentsRaw()).called(1);
  });

  // Test case 3: test to confirm error handling while converting
  test('fetchComments throws an exception when service fails', () async {
    final Exception serviceException = Exception('Network error');

    when(() => mockService.fetchCommentsRaw()).thenThrow(serviceException);

    // expecting any type of exception error
    await expectLater(() async {
      try {
        await repository.fetchComments();
      } catch (e) {
        debugPrint('Caught exception in test: $e');
        rethrow;
      }
    }, throwsA(isA<Exception>()));

    verify(() => mockService.fetchCommentsRaw()).called(1);
  });

  // Test case 4: testing for multiple data mapping to model
  test('fetchComments maps multiple json entries to CommentModel list', () async {
    final List<Map<String, dynamic>> rawJson = [
      {'postId': 1, 'id': 1, 'name': 'User One', 'email': 'one@email.com', 'body': 'Body one'},
      {'postId': 1, 'id': 2, 'name': 'User Two', 'email': 'two@email.com', 'body': 'Body two'},
      {'postId': 1, 'id': 3, 'name': 'User Three', 'email': 'three@email.com', 'body': 'Body three'},
    ];

    when(() => mockService.fetchCommentsRaw()).thenAnswer((_) async => rawJson);

    final result = await repository.fetchComments();

    // 1. checking if the return type is list of comment model.
    expect(result, isA<List<CommentModel>>());
    // 2. checking if the data has intended number of entry
    expect(result.length, 3);
    // 3. checking if the data has properly converted and no loss of data or corruption of data
    expect(result[0].name, 'User One');
    expect(result[1].email, 'two@email.com');
    expect(result[2].body, 'Body three');

    verify(() => mockService.fetchCommentsRaw()).called(1);
  });

  // Test case 5: testing for missing keys from json (nullable field)
  test('fetchComments handles malformed json by setting missing fields to null', () async {
    //
    final List<Map<String, dynamic>> malformedJson = [
      {'postId': 1, 'id': 1, 'email': 'test@email.com', 'body': 'Sample'}, // name is missing
    ];

    when(() => mockService.fetchCommentsRaw()).thenAnswer((_) async => malformedJson);

    final result = await repository.fetchComments();

    // 1. checking if the return type is list of comment model.
    expect(result, isA<List<CommentModel>>());
    // 2. checking if the data has intended number of entry
    expect(result.length, 1);
    // 3. checking if the data has properly managed to map the missing field ( name )
    expect(result.first.name, isNull);
    // 4. checking if the data has properly converted and no loss of data or corruption of data
    expect(result.first.email, 'test@email.com');
    expect(result.first.body, 'Sample');

    verify(() => mockService.fetchCommentsRaw()).called(1);
  });
}
