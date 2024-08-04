import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_meal_planner/core/constants/firebase_constants.dart';
import 'package:flutter_meal_planner/core/failure.dart';
import 'package:flutter_meal_planner/core/provider/firebase_provider.dart';
import 'package:flutter_meal_planner/core/typedefs.dart';
import 'package:flutter_meal_planner/models/meal_model.dart';
import 'package:flutter_meal_planner/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.watch(firebaseFirestoreProvider),
    auth: ref.watch(firebaseAuthProvider),
    googleSignIn: ref.watch(googleSignInProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository(
      {required FirebaseFirestore firestore,
      required FirebaseAuth auth,
      required GoogleSignIn googleSignIn})
      : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.userCollection);

  Stream<User?> get authStateChange => _auth.authStateChanges();

  void signUpWithEmail(String username, String email, String password) async {
    try {
      final emailUser = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel userModel;

      if (emailUser.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          uid: const Uuid().v5(Uuid.NAMESPACE_URL, email),
          name: username,
          email: email,
          password: password,
          allergic: [],
          diet: [],
          todayMeals: [],
        );
        await _users.doc(userModel.uid).set(userModel.toMap());
      } else {
        throw "User already exists";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  void updateUserData(String uid, Map<String, dynamic> data) async {
    UserModel userModel = await getUserData(uid).first;

    userModel = userModel.copyWith(
      name: data['name'] ?? userModel.name,
      email: data['email'] ?? userModel.email,
      allergic: data['allergic'] ?? userModel.allergic,
      diet: data['diet'] ?? userModel.diet,
      todayMeals: data['todayMeals'] ?? userModel.todayMeals,
    );

    _users.doc(uid).update(userModel.toMap());
  }

  void updateUserTodayMeals(MealModel todayMeals) async {
    UserModel userModel = await getUserData(_auth.currentUser!.uid).first;

    if (userModel.todayMeals.length == 4) {
      throw "You have already added 4 meals for today";
    }

    for (var meal in userModel.todayMeals) {
      if (meal.name == todayMeals.name) {
        print("You have already added this meal");
      }
    }

    userModel.todayMeals.add(todayMeals);

    _users.doc(_auth.currentUser!.uid).update(userModel.toMap());
  }

  void updateUserAllergies(List<String> allergic) async {
    await _users.doc(_auth.currentUser!.uid).update({'allergic': allergic});
  }

  void updateUserDiets(List<String> diet) async {
    await _users.doc(_auth.currentUser!.uid).update({'diet': diet});
  }

  void addTodaysMeal(UserModel userModel) {
    _users.doc(userModel.uid).update(userModel.toMap());
  }

  FutureEither<UserModel> signInWithEmail(String email, String password) async {
    try {
      final emailUser = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      UserModel userModel;

      if (emailUser.additionalUserInfo!.isNewUser) {
        return left(Failure("User does not exist"));
      } else {
        String uid = const Uuid().v5(Uuid.NAMESPACE_URL, email);
        userModel = await getUserData(uid).first;
        return right(userModel);
      }
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken,
      );

      UserModel userModel;

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
            uid: userCredential.user?.uid ?? " ",
            name: userCredential.user?.displayName ?? "No Name",
            email: userCredential.user?.email ?? "No Email",
            allergic: [],
            diet: [],
            todayMeals: []);
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }

      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void signOut() {
    _auth.signOut();
    _googleSignIn.signOut();
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final users = await _users.get();
    return users.docs.map((e) => e.data() as Map<String, dynamic>).toList();
  }

  Stream<UserModel> getUserData(String uid) {
    return (_users.doc(uid).snapshots().map((event) {
      return UserModel.fromMap(event.data() as Map<String, dynamic>);
    }));
  }
}
