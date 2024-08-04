// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:flutter_meal_planner/models/message_model.dart';

class ChatModel {
  final String id;
  final List<String> participants;
  final List<MessageModel> messages;
  ChatModel({
    required this.id,
    required this.participants,
    required this.messages,
  });

  ChatModel copyWith({
    String? id,
    List<String>? participants,
    List<MessageModel>? messages,
  }) {
    return ChatModel(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'participants': participants,
      'messages': messages.map((x) => x.toMap()).toList(),
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] as String,
      participants: List<String>.from(
        (map['participants']),
      ),
      messages: List<MessageModel>.from(
        (map['messages']).map<MessageModel>(
          (x) => MessageModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ChatModel(id: $id, participants: $participants, messages: $messages)';

  @override
  bool operator ==(covariant ChatModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        listEquals(other.participants, participants) &&
        listEquals(other.messages, messages);
  }

  @override
  int get hashCode => id.hashCode ^ participants.hashCode ^ messages.hashCode;
}
