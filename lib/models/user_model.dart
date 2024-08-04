// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:flutter_meal_planner/models/meal_model.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? password;
  final List<String> allergic;
  final List<String> diet;
  final List<MealModel> todayMeals;
  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.password,
    required this.allergic,
    required this.diet,
    required this.todayMeals,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? password,
    List<String>? allergic,
    List<String>? diet,
    List<MealModel>? todayMeals,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      allergic: allergic ?? this.allergic,
      diet: diet ?? this.diet,
      todayMeals: todayMeals ?? this.todayMeals,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
      'allergic': allergic,
      'diet': diet,
      'todayMeals': todayMeals.map((x) => x.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        uid: map['uid'] ?? '',
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        password: map['password'] != null ? map['password'] ?? '' : null,
        allergic: List<String>.from((map['allergic'])),
        diet: List<String>.from((map['diet'])),
        todayMeals: List<MealModel>.from(
          (map['todayMeals']).map<MealModel>(
            (x) => MealModel.fromMap(x),
          ),
        ));
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, password: $password, allergic: $allergic, diet: $diet, todayMeals: $todayMeals)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.password == password &&
        listEquals(other.allergic, allergic) &&
        listEquals(other.diet, diet) &&
        listEquals(other.todayMeals, todayMeals);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        password.hashCode ^
        allergic.hashCode ^
        diet.hashCode ^
        todayMeals.hashCode;
  }
}
