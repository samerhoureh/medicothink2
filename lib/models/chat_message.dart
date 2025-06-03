import 'package:flutter/material.dart';

enum MessageType {
  text,
  voice,
  image,
  reminder
}

class ChatMessage {
  final String id;
  final String content;
  final bool isMe;
  final MessageType type;
  final DateTime timestamp;
  final String? mediaUrl; // For voice/image URLs
  final Duration? audioDuration; // For voice messages
  final ReminderData? reminder;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isMe,
    required this.type,
    required this.timestamp,
    this.mediaUrl,
    this.audioDuration,
    this.reminder,
  });
}

class ReminderData {
  final String title;
  final String description;
  final DateTime dateTime;
  final bool isRecurring;
  final RecurrenceType? recurrenceType;

  ReminderData({
    required this.title,
    required this.description,
    required this.dateTime,
    this.isRecurring = false,
    this.recurrenceType,
  });
}

enum RecurrenceType {
  daily,
  weekly,
  monthly
}