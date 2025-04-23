part of 'chat_cubit.dart';

sealed class ChatState {
  const ChatState();
}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatSuccess extends ChatState {
  final List<MessageModel> chats;
  const ChatSuccess(this.chats);
}

final class ChatError extends ChatState {
  final String error;
  const ChatError(this.error);
}

final class SendingMessage extends ChatState {}

final class MessageSent extends ChatState {}

final class MessageError extends ChatState {
  final String error;
  const MessageError(this.error);
}

final class WaitingForResponse extends ChatState {
  const WaitingForResponse();
}

final class ImagePicked extends ChatState {
  final File imagePath;
  const ImagePicked(this.imagePath);
}

final class ImageRemoved extends ChatState {
  const ImageRemoved();
}

final class GetChatsLoading extends ChatState {
  const GetChatsLoading();
}

final class GetChatsSuccess extends ChatState {
  final List<ChatModel> chats;
  const GetChatsSuccess(this.chats);
}

final class GetChatsError extends ChatState {
  final String error;
  const GetChatsError(this.error);
}
