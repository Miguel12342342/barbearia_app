import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  late final StreamSubscription<User?> _authSubscription;

  AuthCubit({FirebaseAuth? auth, GoogleSignIn? googleSignIn})
      : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ??
            GoogleSignIn(
              clientId:
                  '504277009454-vasq38p4bt1i1b2sjvj1cqigk09lbgv5.apps.googleusercontent.com',
              serverClientId: kIsWeb
                  ? null
                  : '504277009454-vasq38p4bt1i1b2sjvj1cqigk09lbgv5.apps.googleusercontent.com',
            ),
        super(const AuthState(status: AuthStatus.initial)) {
    _authSubscription = _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(User? user) {
    if (user != null) {
      emit(AuthState(
        status: AuthStatus.authenticated,
        userId: user.uid,
        displayName: user.displayName,
        email: user.email,
      ));
    } else {
      emit(const AuthState(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // _onAuthStateChanged handles the success state
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: _mapFirebaseError(e.code),
      ));
    }
  }

  Future<void> registerWithEmail(
      String name, String email, String password) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await credential.user?.updateDisplayName(name);
      // _onAuthStateChanged handles the success state
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: _mapFirebaseError(e.code),
      ));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(state.copyWith(status: AuthStatus.initial));
        return;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      // _onAuthStateChanged handles success state
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: _mapFirebaseError(e.code),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Erro ao entrar com Google: $e',
      ));
    }
  }

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'invalid-credential':
        return 'Email ou senha inválidos.';
      case 'email-already-in-use':
        return 'Este email já está cadastrado.';
      case 'weak-password':
        return 'Senha muito fraca. Use ao menos 6 caracteres.';
      case 'invalid-email':
        return 'Email inválido.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente em instantes.';
      default:
        return 'Erro inesperado. Tente novamente.';
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
