import 'dart:async';
import 'dart:developer';
import 'package:gpt/features/home/data/models/chat_model.dart';
import 'package:gpt/features/home/data/models/message_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();

  factory CacheService() {
    return _instance;
  }

  CacheService._internal();

  static const String _boxName = 'chats';

  late Box<ChatModel> _box;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(MessageModelAdapter());
    Hive.registerAdapter(ChatModelAdapter());
    _box = await Hive.openBox<ChatModel>(_boxName);
    log('CacheService initialized with box name: $_boxName');
  }

  Future<String> addChat(List<MessageModel> messages) async {
    final chat = ChatModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      messages: messages,
      createdAt: DateTime.now(),
    );
    await _box.put(chat.id, chat);
    log('Chat added with ID: ${chat.id}');
    return chat.id;
  }

  Future<void> appendMessage(String chatId, MessageModel message) async {
    final chat = _box.get(chatId);
    if (chat != null) {
      // Create a deep copy of the messages list
      final updatedMessages = List<MessageModel>.from(
        chat.messages.map((msg) => msg),
      );

      updatedMessages.add(message);

      final updatedChat = chat.copyWith(messages: updatedMessages);

      await _box.put(chatId, updatedChat);

      log('Message appended to chat with ID: $chatId is ${message.text}');
    }
  }

  Future<List<MessageModel>> getChat(String chatId) async {
    return _box.get(chatId)?.messages ?? [];
  }

  Future<List<ChatModel>> getAllChats() async {
    final allChats = _box.values.toList();
    allChats.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return allChats;
  }

  Future<void> deleteChat(String chatId) async {
    await _box.delete(chatId);
  }
}
