import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../core/error/app_exception.dart';

class FirebaseAuthDataSource {
  FirebaseAuthDataSource({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  }) : _firebaseAuth = firebaseAuth,
       _googleSignIn = googleSignIn;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        throw const AppException('Google sign-in cancelled by user.');
      }

      final GoogleSignInAuthentication authentication =
          await account.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (error) {
      throw AppException(error.message ?? 'Google sign-in failed.');
    } catch (error) {
      if (error is AppException) {
        rethrow;
      }
      throw AppException('Google sign-in failed: $error');
    }
  }

  Future<void> signInWithApple() async {
    try {
      final bool available = await SignInWithApple.isAvailable();
      if (!available) {
        throw const AppException(
          'Apple sign-in is not available on this device.',
        );
      }

      final String rawNonce = _generateNonce();
      final String hashedNonce = _sha256OfString(rawNonce);

      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
            scopes: const <AppleIDAuthorizationScopes>[
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            nonce: hashedNonce,
          );

      final OAuthCredential credential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
        rawNonce: rawNonce,
      );

      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (error) {
      throw AppException(error.message ?? 'Apple sign-in failed.');
    } catch (error) {
      if (error is AppException) {
        rethrow;
      }
      throw AppException('Apple sign-in failed: $error');
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait(<Future<void>>[
        _googleSignIn.signOut(),
        _firebaseAuth.signOut(),
      ]);
    } on FirebaseAuthException catch (error) {
      throw AppException(error.message ?? 'Sign out failed.');
    } catch (error) {
      throw AppException('Sign out failed: $error');
    }
  }

  String _generateNonce([int length = 32]) {
    const String charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final Random random = Random.secure();
    return List<String>.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256OfString(String input) {
    final List<int> bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }
}
