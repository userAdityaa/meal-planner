import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meal_planner/core/common/showSnackBar.dart';
import 'package:flutter_meal_planner/features/auth/repository/auth_repository.dart';
import 'package:flutter_meal_planner/models/meal_model.dart';
import 'package:flutter_meal_planner/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final userProvider = StateProvider<UserModel?>((ref) => null);

final getUserDataProvider = StateProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  authController.getUserData(uid);
});

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  void signUpWithEmail(
      BuildContext context, String username, String email, String password) {
    _authRepository.signUpWithEmail(username, email, password);
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    return await _authRepository.getAllUsers();
  }

  void signInWithEmail(
      BuildContext context, String email, String password) async {
    state = true;
    final user = await _authRepository.signInWithEmail(email, password);

    state = false;

    user.fold(
      (l) => showSnackBar(context, l.message),
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void updateUserData(String uid, Map<String, dynamic> data) {
    _authRepository.updateUserData(uid, data);
  }

  void addTodaysMeal(UserModel userModel) {
    _authRepository.addTodaysMeal(userModel);
  }

  void signOut() {
    _authRepository.signOut();
  }

  void updateUserAllergies(List<String> allergic) {
    _authRepository.updateUserAllergies(allergic);
  }

  void updateUserDiets(List<String> diet) {
    _authRepository.updateUserDiets(diet);
  }

  void updateUserTodayMeals(MealModel todayMeals) {
    _authRepository.updateUserTodayMeals(todayMeals);
  }

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold((l) => showSnackBar(context, l.message), (userModel) {
      _ref.read(userProvider.notifier).update((state) => userModel);
    });
  }
}
