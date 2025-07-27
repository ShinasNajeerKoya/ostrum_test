import 'package:mocktail/mocktail.dart';
import 'package:ostrum_test/data/services/comment_service/comment_service.dart';
import 'package:ostrum_test/domain/repositories/ostrum_comments/ostrum_comments_repository.dart';

class MockOstrumCommentService extends Mock implements OstrumCommentService {}

class MockOstrumCommentsRepository extends Mock implements OstrumCommentsRepository {}
