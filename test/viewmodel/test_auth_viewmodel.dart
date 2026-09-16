import 'package:flutter_test/flutter_test.dart';
import 'package:mavazi/model/api_error.dart';
import 'package:mavazi/model/login_result.dart';
import 'package:mavazi/model/user.dart';
import 'package:mavazi/services/auth_api.dart';
import 'package:mavazi/viewmodel/auth_viewmodel.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthApi extends Mock implements AuthApi {}

User _mockUser = User(
  id: 1,
  username: 'queen',
  email: 'queen@gmail.com',
  firstName: 'Ines',
  lastName: 'Uwase',
  gender: 'female',
  image: 'https://imahe.url',
);

void main() {
  late MockAuthApi mockApi;

  setUpAll(() {
    registerFallbackValue(_mockUser);
  });

  setUp(() {
    mockApi = MockAuthApi();
  });

  group('login', () {
    test('successul login', () async {
      SharedPreferences.setMockInitialValues({});
      when(() => mockApi.login(any(), any())).thenAnswer(
        (_) async => LoginResult(
          user: _mockUser,
          accessToken: 'access123',
          refreshToken: 'refresh123',
        ),
      );
      final vm = AuthViewModel(authApi: mockApi);
      var success = await vm.login('queen', 'queenpassw');

      expect(vm.authStatus, AuthStatus.authenticated);
      expect(success, isTrue);
    });

    test('failed login', () async {
      SharedPreferences.setMockInitialValues({});
      when(
        () => mockApi.login(any(), any()),
      ).thenThrow(ApiError(message: 'Invalid credentials'));

      final vm = AuthViewModel(authApi: mockApi);
      var success = await vm.login('wrong', 'invalidpass');

      expect(success, isFalse);
      expect(vm.authStatus, AuthStatus.unauthenticated);
    });
  });
}
