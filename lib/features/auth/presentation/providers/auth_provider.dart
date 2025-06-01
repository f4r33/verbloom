import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:verbloom/features/auth/domain/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  User? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._authService) {
    _init();
  }

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  void _init() {
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
      _error = null;
      if (_authService.currentUser != null) {
        await _createUserDocument(_authService.currentUser!);
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _error = null;
      if (_authService.currentUser != null) {
        await _createUserDocument(_authService.currentUser!);
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithGoogle() async {
    _setLoading(true);
    try {
      await _authService.signInWithGoogle();
      _error = null;
      if (_authService.currentUser != null) {
        await _createUserDocument(_authService.currentUser!);
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithApple() async {
    _setLoading(true);
    try {
      await _authService.signInWithApple();
      _error = null;
      if (_authService.currentUser != null) {
        await _createUserDocument(_authService.currentUser!);
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInAnonymously() async {
    _setLoading(true);
    try {
      await _authService.signInAnonymously();
      _error = null;
      if (_authService.currentUser != null) {
        await _createUserDocument(_authService.currentUser!);
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _createUserDocument(User user) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final userDoc = await userRef.get();
    if (!userDoc.exists) {
      await userRef.set({
        'displayName': user.displayName ?? '',
        'email': user.email ?? '',
        'totalXP': 0,
        'currentLevel': 1,
        'streak': 0,
        'highestStreak': 0,
        'gamesPlayed': 0,
        'gamesWon': 0,
        'perfectScores': 0,
        'lastPlayedDate': null,
        'achievements': [],
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
} 