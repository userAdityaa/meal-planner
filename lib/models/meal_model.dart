// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class MealModel {
  final String name;
  final String? image;
  final Map<String, dynamic> nutrients;
  final List<dynamic>? contents;
  MealModel({
    required this.name,
    this.image,
    required this.nutrients,
    this.contents,
  });

  MealModel copyWith({
    String? name,
    String? image,
    Map<String, dynamic>? nutrients,
    List<dynamic>? contents,
  }) {
    return MealModel(
      name: name ?? this.name,
      image: image ?? this.image,
      nutrients: nutrients ?? this.nutrients,
      contents: contents ?? this.contents,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'image': image,
      'nutrients': nutrients,
      'contents': contents,
    };
  }

  factory MealModel.fromMap(Map<String, dynamic> map) {
    return MealModel(
      name: map['name'] as String,
      image: map['image'] != null ? map['image'] as String : null,
      nutrients:
          Map<String, dynamic>.from((map['nutrients'] as Map<String, dynamic>)),
      contents: map['contents'] != null
          ? List<dynamic>.from((map['contents'] as List<dynamic>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MealModel.fromJson(String source) =>
      MealModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MealModel(name: $name, image: $image, nutrients: $nutrients, contents: $contents)';
  }

  @override
  bool operator ==(covariant MealModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.image == image &&
        mapEquals(other.nutrients, nutrients) &&
        listEquals(other.contents, contents);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        image.hashCode ^
        nutrients.hashCode ^
        contents.hashCode;
  }
}
