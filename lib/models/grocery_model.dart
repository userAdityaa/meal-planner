// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Grocery {
  String name;
  double calories;
  double protien;
  double fat;
  double quantity;
  Grocery({
    required this.name,
    required this.calories,
    required this.protien,
    required this.fat,
    required this.quantity,
  });

  Grocery copyWith({
    String? name,
    double? calories,
    double? protien,
    double? fat,
    double? quantity,
  }) {
    return Grocery(
      name: name ?? this.name,
      calories: calories ?? this.calories,
      protien: protien ?? this.protien,
      fat: fat ?? this.fat,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'calories': calories,
      'protien': protien,
      'fat': fat,
      'quantity': quantity,
    };
  }

  factory Grocery.fromMap(Map<String, dynamic> map) {
    return Grocery(
      name: map['name'] as String,
      calories: map['calories'] as double,
      protien: map['protien'] as double,
      fat: map['fat'] as double,
      quantity: map['quantity'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Grocery.fromJson(String source) =>
      Grocery.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Grocery(name: $name, calories: $calories, protien: $protien, fat: $fat, quantity: $quantity)';
  }

  @override
  bool operator ==(covariant Grocery other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.calories == calories &&
        other.protien == protien &&
        other.fat == fat &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        calories.hashCode ^
        protien.hashCode ^
        fat.hashCode ^
        quantity.hashCode;
  }
}
