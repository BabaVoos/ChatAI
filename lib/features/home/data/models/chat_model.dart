import 'package:hive/hive.dart';
import 'message_model.dart';

part 'chat_model.g.dart';

@HiveType(typeId: 1)
class ChatModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final List<MessageModel> messages;

  @HiveField(2)
  final DateTime createdAt;

  ChatModel({
    required this.id,
    required this.messages,
    required this.createdAt,
  });

  String get title => messages.isNotEmpty ? messages.first.text : 'New Chat';

  ChatModel copyWith({List<MessageModel>? messages}) {
    return ChatModel(
      id: id,
      messages: messages ?? this.messages,
      createdAt: createdAt,
    );
  }
}
