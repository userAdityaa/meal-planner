import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_meal_planner/core/constants/firebase_constants.dart';

class GroceryRepository {
  final FirebaseFirestore _firestore;
  GroceryRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;
  CollectionReference get _grocery =>
      _firestore.collection(FirebaseConstants.groceryCollection);
  void createItem(Map<String, dynamic> data) {}
}
