import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gpt/core/utils/assets_manager.dart';
import 'package:gpt/features/home/data/models/message_model.dart';
import 'package:gpt/features/home/ui/cubit/chat_cubit.dart';
import 'package:gpt/features/home/ui/widgets/message_widget.dart';

class MessageListView extends StatefulWidget {
  const MessageListView({super.key});

  @override
  State<MessageListView> createState() => _MessageListViewState();
}

class _MessageListViewState extends State<MessageListView> {
  late final ScrollController _scrollController;
  List<MessageModel> _lastMessages = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: BlocConsumer<ChatCubit, ChatState>(
        buildWhen: (previous, current) => current is ChatSuccess,
        listenWhen: (previous, current) {
          return current is ChatSuccess;
        },
        listener: (context, state) {
          if (state is ChatSuccess) {
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          if (state is ChatSuccess) {
            if (!_listsEqual(_lastMessages, state.chats)) {
              _lastMessages = state.chats;
            }

            if (_lastMessages.isEmpty) {
              return Center(
                child: SvgPicture.asset(AssetsManager.logo, height: 50),
              );
            }

            return ListView.builder(
              controller: _scrollController,
              itemCount: _lastMessages.length,
              itemBuilder: (context, index) {
                final message = _lastMessages[index];
                return MessageWidget(
                  key: ValueKey(message.time),
                  message: message,
                  isLast: index == _lastMessages.length - 1,
                  scrollToBottom: _scrollToBottom,
                );
              },
            );
          }

          return Center(
            child: SvgPicture.asset(AssetsManager.logo, height: 50),
          );
        },
      ),
    );
  }

  bool _listsEqual(List<MessageModel> a, List<MessageModel> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].text != b[i].text ||
          a[i].time != b[i].time ||
          a[i].isUser != b[i].isUser) {
        return false;
      }
    }
    return true;
  }
}
