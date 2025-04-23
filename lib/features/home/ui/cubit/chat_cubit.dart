import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpt/core/services/cache_service.dart';
import 'package:gpt/core/services/camera_service.dart';
import 'package:gpt/core/services/chat_service.dart';
import 'package:gpt/features/home/data/models/message_model.dart';
import 'package:gpt/features/home/data/models/chat_model.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required CacheService cacheService,
    required CameraService cameraService,
    required ChatService chatService,
  }) : _cacheService = cacheService,
       _cameraService = cameraService,
       _chatService = chatService,
       super(ChatInitial());

  final ChatService _chatService;
  final CameraService _cameraService;
  final CacheService _cacheService;

  List<MessageModel> _messages = [];
  String? _chatId;

  File? _selectedImage;

  void startNewSession() async {
    _messages = [];
    _chatId = null;
    _chatService.startNewSession();
    emit(ChatSuccess(_messages));
  }

  void startOldSession(String chatId) async {
    _messages = [];
    _chatId = chatId;
    _messages = await _cacheService.getChat(chatId);
    for (final message in _messages) {
      print('Message: ${message.text}');
    }
    emit(ChatSuccess(_messages));
  }

  Future<void> pickImage() async {
    final image = await _cameraService.pickImage();
    if (image != null) {
      _selectedImage = File(image.path);
      emit(ImagePicked(image));
    }
  }

  void removeImage() {
    _selectedImage = null;
    emit(const ImageRemoved());
  }

  Future<void> sendMessage(String message) async {
    emit(SendingMessage());
    try {
      final File? selectedImage = _selectedImage;

      final userMessage = MessageModel(
        text: message,
        isUser: true,
        time: DateTime.now(),
        image: _selectedImage,
      );

      // Add the user message to the message list
      _messages.add(userMessage);

      // Only save the messages to cache once after adding the user message
      if (_chatId == null) {
        // If there is no chat ID, create a new chat
        _chatId = await _cacheService.addChat([userMessage]);
      } else {
        await _cacheService.appendMessage(_chatId!, _messages.last);
      }

      // Emit the updated message list state
      emit(ChatSuccess(_messages));
      emit(const WaitingForResponse());

      // Get the response
      final response = await _chatService.sendMessage(message, selectedImage);

      final responseMessage = MessageModel(
        text: response ?? 'No response',
        isUser: false,
        time: DateTime.now(),
      );

      // Add the response to the message list
      _messages.add(responseMessage);

      // Only save the updated message list after receiving the response
      if (_chatId != null) {
        await _cacheService.appendMessage(_chatId!, responseMessage);
      }

      emit(MessageSent());
      emit(ChatSuccess(_messages));
    } catch (e) {
      emit(MessageError(e.toString()));
    }
  }

  Future<void> getAllChats() async {
    emit(const GetChatsLoading());
    try {
      final chats = await _cacheService.getAllChats();
      emit(GetChatsSuccess(chats));
    } catch (e) {
      emit(GetChatsError(e.toString()));
    }
  } 

  void deleteChat(String chatId) async {
    await _cacheService.deleteChat(chatId);
    getAllChats();
  }
}
