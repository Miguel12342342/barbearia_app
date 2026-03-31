import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth;
  late final StreamSubscription<User?> _authSubscription;

  AuthCubit({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance,
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

  Future<void> signOut() async {
    await _auth.signOut();
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
