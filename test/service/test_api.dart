import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mavazi/model/api_error.dart';
import 'package:mavazi/services/auth_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient mockClient;
  late AuthApi authApi;

  setUp(() {
    mockClient = MockHttpClient();
    authApi = AuthApi(client: mockClient);
    registerFallbackValue(Uri.parse('http://dummy.uri'));
  });

  group('login', () {
    test('test login success', () async {
      final mockReponse = {
        'id': 1,
        'username': 'Jack',
        'email': 'nancy@email.co',
        'firstName': 'Nancy',
        'lastName': 'Lavigne',
        'image': 'http:imga.url',
        'gender': 'female',
        'accessToken': 'access123',
        'refreshToken': 'refresh123',
      };

      when(
        () => mockClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => http.Response(jsonEncode(mockReponse), 200));

      final result = await authApi.login('nancy', 'nancypassw');
      expect(result.accessToken, 'access123');
      expect(result.user.firstName, 'Nancy');
    });

    test('test login failed', () async {
      when(
        () => mockClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer(
        (_) async =>
            http.Response(jsonEncode({'message': 'Invalid credentials'}), 400),
      );
      
      expect(
        () => authApi.login('wrong', 'invalid'),
        throwsA(
          isA<ApiError>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid credentials'),
          ),
        ),
      );
    });
  });
}
