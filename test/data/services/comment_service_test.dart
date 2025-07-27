import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ostrum_test/data/services/comment_service/comment_service.dart';
import 'package:ostrum_test/core/network/api_client.dart';

// Mock the ApiClient to control its network responses.
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late OstrumCommentService service;
  late MockApiClient apiClient;

  setUp(() {
    apiClient = MockApiClient();
    service = OstrumCommentService(apiClient);
  });

  // Test case 1: successful api response mockup.
  test('fetchCommentsRaw returns list of maps directly on successful API call', () async {
    // dummy data
    final Map<String, dynamic> apiResponse = {
      'data': [
        {
          "postId": 1,
          "id": 1,
          "name": "id labore ex et quam laborum",
          "email": "Eliseo@gardner.biz",
          "body": "laudantium enim quasi est quidem magnam voluptate ipsam eos",
        },
        {
          "postId": 1,
          "id": 2,
          "name": "quo vero reiciendis velit similique earum",
          "email": "Jayne_Kuhic@sydney.com",
          "body": "est natus enim nihil est dolore omnis voluptatem numquam",
        },
        {
          "postId": 1,
          "id": 3,
          "name": "odio adipisci rerum aut animi",
          "email": "Nikita@garfield.biz",
          "body": "quia molestiae reprehenderit quasi aspernatur",
        },
      ],
    };

    // mocking get method from api helper
    when(() => apiClient.get(any(), headers: any(named: 'headers'))).thenAnswer((_) async => apiResponse);

    final result = await service.fetchCommentsRaw();

    // expecting:
    // 1. successful result of list of maps for raw data.
    expect(result, isA<List<Map<String, dynamic>>>());
    // 2. verifying number of items.
    expect(result.length, 3);
    // 3. verifying extracted data to be proper.
    expect(result.first['email'], equals('Eliseo@gardner.biz'));
    expect(result[1]['name'], equals('quo vero reiciendis velit similique earum'));

    verify(() => apiClient.get(any(), headers: any(named: 'headers'))).called(1);
  });

  // Test case 2: testing for empty data as response.
  test('fetchCommentsRaw returns an empty list when API response has empty data', () async {
    // mocking empty list.
    final Map<String, dynamic> apiResponse = {'data': []};

    // mocking get method from api helper
    when(() => apiClient.get(any(), headers: any(named: 'headers'))).thenAnswer((_) async => apiResponse);

    final result = await service.fetchCommentsRaw();

    // expecting:
    // 1. successful result of list of maps for raw data.
    expect(result, isA<List<Map<String, dynamic>>>());
    // 2. verifying that the list is empty.
    expect(result, isEmpty);

    verify(() => apiClient.get(any(), headers: any(named: 'headers'))).called(1);
  });
}
