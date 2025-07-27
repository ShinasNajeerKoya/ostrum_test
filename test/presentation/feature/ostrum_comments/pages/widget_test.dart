import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ostrum_test/presentation/feature/ostrum_comments/pages/ostrum_comments_page.dart';
import 'package:shimmer/shimmer.dart';

import 'package:ostrum_test/domain/models/comment/comment_model.dart';
import 'package:ostrum_test/presentation/feature/ostrum_comments/bloc/ostrum_comments_bloc.dart';
import 'package:ostrum_test/presentation/feature/ostrum_comments/bloc/ostrum_comments_state.dart';
import 'package:ostrum_test/presentation/feature/ostrum_comments/widgets/comments_tile.dart';
import 'package:ostrum_test/presentation/feature/ostrum_comments/widgets/loading_comment_tile.dart';

class MockOstrumCommentsBloc extends Mock implements OstrumCommentsBloc {}

void main() {
  late MockOstrumCommentsBloc mockBloc;
  final getIt = GetIt.instance;

  // dummy comment data for tests
  final CommentModel testComment1 = CommentModel(
    postId: 1,
    id: 1,
    name: 'Test User 1',
    email: 'test1@example.com',
    body: 'This is the first test comment body.',
  );

  final CommentModel testComment2 = CommentModel(
    postId: 1,
    id: 2,
    name: 'Test User 2',
    email: 'test2@example.com',
    body: 'This is the second test comment body.',
  );

  setUpAll(() {
    registerFallbackValue(const OstrumCommentsState());
    registerFallbackValue(testComment1);
    registerFallbackValue(<CommentModel>[]);
  });

  setUp(() {
    mockBloc = MockOstrumCommentsBloc();

    if (getIt.isRegistered<OstrumCommentsBloc>()) {
      getIt.unregister<OstrumCommentsBloc>();
    }
    getIt.registerSingleton<OstrumCommentsBloc>(mockBloc);

    when(() => mockBloc.state).thenReturn(const OstrumCommentsState());
    when(() => mockBloc.stream).thenAnswer((_) => Stream.fromIterable([const OstrumCommentsState()]));

    when(() => mockBloc.fetchOstrumComments()).thenAnswer((_) async {});
    when(() => mockBloc.clearCache()).thenAnswer((_) async {});
    when(() => mockBloc.close()).thenAnswer((_) async {});
  });

  // close everything after use.
  tearDown(() {
    getIt.reset();
    mockBloc.close();
  });

  // mocking necessary widgets
  Widget makeTestableWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => MaterialApp(home: child),
    );
  }

  group('OstrumCommentsPage', () {
    testWidgets('displays initial state with "Welcome" message and "Get Data" button', (tester) async {
      when(() => mockBloc.state).thenReturn(const OstrumCommentsState());
      when(() => mockBloc.stream).thenAnswer((_) => Stream.fromIterable([const OstrumCommentsState()]));

      await tester.pumpWidget(makeTestableWidget(const OstrumCommentsPage()));
      await tester.pumpAndSettle();

      // for initial text
      expect(find.text('Welcome, Please load the data'), findsOneWidget);

      expect(find.widgetWithText(ElevatedButton, 'Get Data'), findsOneWidget);

      expect(find.byType(LoadingCommentTile), findsNothing);
      expect(find.byType(CommentsTile), findsNothing);
    });

    testWidgets('displays loading state with shimmer tiles', (tester) async {
      // mocking loading state
      when(() => mockBloc.state).thenReturn(const OstrumCommentsState(isLoading: true));
      when(() => mockBloc.stream).thenAnswer((_) => Stream.fromIterable([const OstrumCommentsState(isLoading: true)]));

      await tester.pumpWidget(makeTestableWidget(const OstrumCommentsPage()));
      // adding timer for shimmer catch
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byKey(Key('loadingCommentTileKey')), findsWidgets);
      expect(find.byKey(Key('loadingAvatarPlaceholder')), findsWidgets);
      // checking shimmer widget present
      expect(find.byType(Shimmer), findsWidgets);
      // checking if the result is not initial state or error state
      expect(find.text('Welcome, Please load the data'), findsNothing);
      expect(find.text('Something went wrong while loading comments.'), findsNothing);
    });

    testWidgets('displays error message when hasError is true', (tester) async {
      // mocking error
      when(() => mockBloc.state).thenReturn(const OstrumCommentsState(error: true));
      when(() => mockBloc.stream).thenAnswer((_) => Stream.fromIterable([const OstrumCommentsState(error: true)]));

      await tester.pumpWidget(makeTestableWidget(const OstrumCommentsPage()));
      await tester.pumpAndSettle();

      expect(find.text('Something went wrong while loading comments.'), findsOneWidget);

      expect(find.byType(LoadingCommentTile), findsNothing);
      expect(find.byType(CommentsTile), findsNothing);
    });

    testWidgets('displays comments and delete button when data is loaded successfully', (tester) async {
      // mocking success state
      when(() => mockBloc.state).thenReturn(OstrumCommentsState(comments: [testComment1, testComment2]));
      when(() => mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          OstrumCommentsState(comments: [testComment1, testComment2]),
        ]),
      );

      await tester.pumpWidget(makeTestableWidget(const OstrumCommentsPage()));
      await tester.pumpAndSettle();

      expect(find.byType(CommentsTile), findsNWidgets(2));
      expect(find.text(testComment1.name!), findsOneWidget);
      expect(find.text(testComment2.email!), findsOneWidget);
      expect(find.byKey(ValueKey('commentTile_${testComment1.id}')), findsOneWidget);
      expect(find.byKey(ValueKey('commentTile_${testComment2.id}')), findsOneWidget);

      // checking through icon
      expect(find.byIcon(CupertinoIcons.delete), findsOneWidget);

      expect(find.byType(LoadingCommentTile), findsNothing);
      expect(find.text('Welcome, Please load the data'), findsNothing);
    });

    testWidgets('calls fetchOstrumComments when "Get Data" button is tapped', (tester) async {
      when(() => mockBloc.state).thenReturn(const OstrumCommentsState());
      when(() => mockBloc.stream).thenAnswer((_) => Stream.fromIterable([const OstrumCommentsState()]));

      await tester.pumpWidget(makeTestableWidget(const OstrumCommentsPage()));
      await tester.pumpAndSettle();

      // expect by text
      expect(find.text("Get Data"), findsOneWidget);
      // mocking tap
      await tester.tap(find.text("Get Data"));
      // added due to debouncer
      await tester.pump(const Duration(milliseconds: 510));

      verify(() => mockBloc.fetchOstrumComments()).called(1);
    });

    testWidgets('calls clearCache when delete button is tapped', (tester) async {
      when(() => mockBloc.state).thenReturn(OstrumCommentsState(comments: [testComment1]));
      when(() => mockBloc.stream).thenAnswer(
        (_) => Stream.fromIterable([
          OstrumCommentsState(comments: [testComment1]),
        ]),
      );

      await tester.pumpWidget(makeTestableWidget(const OstrumCommentsPage()));
      await tester.pumpAndSettle();

      expect(find.byIcon(CupertinoIcons.delete), findsOneWidget);
      await tester.tap(find.byIcon(CupertinoIcons.delete));
      // added due to debouncer with some delay
      await tester.pump(const Duration(milliseconds: 550));

      verify(() => mockBloc.clearCache()).called(1);
    });
  });

  // --- widget Tests for individual components ---

  group('CommentsTile Section', () {
    testWidgets('displays comment details correctly', (tester) async {
      await tester.pumpWidget(makeTestableWidget(CommentsTile(comment: testComment1)));
      await tester.pumpAndSettle();

      expect(find.text('${testComment1.id}'), findsOneWidget);
      expect(find.text(testComment1.name!), findsOneWidget);
      expect(find.text(testComment1.email!), findsOneWidget);
      expect(find.text(testComment1.body!), findsOneWidget);
    });

    testWidgets('displays "No name" for null name', (tester) async {
      final commentWithNullName = CommentModel(
        postId: 1,
        id: 3,
        name: null,
        email: 'nullname@example.com',
        body: 'Comment with no name.',
      );
      await tester.pumpWidget(makeTestableWidget(CommentsTile(comment: commentWithNullName)));
      await tester.pumpAndSettle();
      expect(find.text('No name'), findsOneWidget);
      expect(find.text(commentWithNullName.email!), findsOneWidget);
      expect(find.text(commentWithNullName.body!), findsOneWidget);
    });

    testWidgets('displays "No email" for null email', (tester) async {
      final commentWithNullEmail = CommentModel(
        postId: 1,
        id: 4,
        name: 'User With No Email',
        email: null,
        body: 'Comment with no email.',
      );
      await tester.pumpWidget(makeTestableWidget(CommentsTile(comment: commentWithNullEmail)));
      await tester.pumpAndSettle();
      expect(find.text('User With No Email'), findsOneWidget);
      expect(find.text('No email'), findsOneWidget);
      expect(find.text(commentWithNullEmail.body!), findsOneWidget);
    });

    testWidgets('displays "No body" for null body', (tester) async {
      final commentWithNullBody = CommentModel(
        postId: 1,
        id: 5,
        name: 'User With No Body',
        email: 'nobody@example.com',
        body: null,
      );
      await tester.pumpWidget(makeTestableWidget(CommentsTile(comment: commentWithNullBody)));
      await tester.pumpAndSettle();
      expect(find.text('User With No Body'), findsOneWidget);
      expect(find.text('nobody@example.com'), findsOneWidget);
      expect(find.text('No body'), findsOneWidget);
    });
  });

  group('LoadingCommentTile Section', () {
    testWidgets('displays shimmer effect and placeholder shapes', (tester) async {
      await tester.pumpWidget(makeTestableWidget(const LoadingCommentTile()));
      // adding some delay due to shimmer
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(Shimmer), findsOneWidget);
      expect(find.byKey(Key('loadingCommentTileKey')), findsWidgets);

      expect(find.byType(Container), findsWidgets);
    });
  });
}
