import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mavazi/screens/login_screen.dart';
import 'package:mavazi/viewmodel/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class MockAuthViewModel extends ChangeNotifier implements AuthViewModel {
  AuthStatus _authStatus = AuthStatus.unauthenticated;
  String? _errorMessage;
  bool isLoading = false;

  @override
  AuthStatus get authStatus => _authStatus;

  @override
  set authStatus(AuthStatus value) {
    _authStatus = value;
  }

  @override
  String? get errorMesage => _errorMessage;

  @override
  set errorMesage(String? value) {
    _errorMessage = value;
  }

  bool loginCalled = false;
  bool loginReturnValue = true;

  @override
  Future<bool> login(String username, String password) async {
    loginCalled = true;
    return loginReturnValue;
  }

  @override
  Future<void> logout() async {
    _authStatus = AuthStatus.unauthenticated;
  }
}

Widget _wrap(MockAuthViewModel vm) {
  return MaterialApp(
    home: ChangeNotifierProvider<AuthViewModel>.value(
      value: vm,
      child: LoginScreen(),
    ),
  );
}

void main() {
  late MockAuthViewModel mockVm;

  setUp(() {
    mockVm = MockAuthViewModel();
  });

  testWidgets('shows validation errors', (tester) async {
    await tester.pumpWidget(_wrap(mockVm));

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();

    expect(find.text('Please enter username'), findsOneWidget);
    expect(find.text('Enter your password'), findsOneWidget);
    expect(mockVm.loginCalled, isFalse);
  });

  testWidgets('test login success', (tester) async {
    mockVm.loginReturnValue = true;
    await tester.pumpWidget(_wrap(mockVm));

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Username'),
      'diana',
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'dianapassw',
    );

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));

    await tester.pump();

    expect(mockVm.loginCalled, isTrue);
    expect(mockVm.loginReturnValue, isTrue);
  });

  testWidgets('test failed login', (tester) async {
    mockVm.loginReturnValue = false;
    mockVm.errorMesage = 'Invalid credentials';

    await tester.pumpWidget(_wrap(mockVm));

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Username'),
      'myusername',
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Password'),
      'apaasword',
    );

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));

    await tester.pump();

    expect(find.text('Invalid credentials'), findsOneWidget);
  });
}
