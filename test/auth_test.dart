import 'package:kanotes/services/auth/auth_exceptions.dart';
import 'package:kanotes/services/auth/auth_provider.dart';
import 'package:kanotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();

    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });

    test('Cannot log out if not initialized', () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    });

    test('Should be able to be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test(
      'Should be able to initialize in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('Create user should delegate to logIn function', () async {
      final wrongEmailUser = provider.createUser(
          email: 'wrong@email.com', password: 'anyPassword');
      expect(wrongEmailUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()));

      final badPassword =
          provider.createUser(email: 'anyg@email.com', password: 'teste1234');
      expect(badPassword,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(
          email: 'user@email.com', password: 'password1234');
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('Logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to log out and log in again', () async {
      await provider.logOut();
      await provider.logIn(email: 'user@email.com', password: 'password1234');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });

    test('Should send password reset link', () async {
      await provider.logOut();
      final hasSentPasswordReset =
          await provider.sendPasswordReset(toEmail: 'user@email.com');
      expect(true, hasSentPasswordReset);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;

  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'wrong@email.com') throw UserNotFoundAuthException();
    if (password == 'teste1234') throw WrongPasswordAuthException();
    final user = AuthUser(email: email, isEmailVerified: false, id: 'my_id');
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    const newUser =
        AuthUser(email: 'any@email.com', isEmailVerified: true, id: 'my_id');
    _user = newUser;
  }

  @override
  Future<bool> sendPasswordReset({required String toEmail}) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    try {
      sendPasswordReset(toEmail: toEmail);
      return true;
    } catch (_) {
      return false;
    }
  }
}
