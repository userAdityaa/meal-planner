import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { Text, Image, Video, Audio }

class MessageModel {
  String? senderID;
  String? content;
  String? type; // Store MessageType as string
  Timestamp? sentAt;

  MessageModel({
    this.senderID,
    this.content,
    this.type,
    this.sentAt,
  });

  MessageModel copyWith({
    String? senderID,
    String? content,
    String? type,
    Timestamp? sentAt,
  }) {
    return MessageModel(
      senderID: senderID ?? this.senderID,
      content: content ?? this.content,
      type: type ?? this.type,
      sentAt: sentAt ?? this.sentAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'content': content,
      'type': type, // Store type as string
      'sentAt': sentAt,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderID: map['senderID'] as String,
      content: map['content'] as String,
      type: map['type'] as String, // Read type as string
      sentAt: map['sentAt'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MessageModel(senderID: $senderID, content: $content, type: $type, sentAt: $sentAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageModel &&
        other.senderID == senderID &&
        other.content == content &&
        other.type == type &&
        other.sentAt == sentAt;
  }

  @override
  int get hashCode {
    return senderID.hashCode ^
        content.hashCode ^
        type.hashCode ^
        sentAt.hashCode;
  }
}
