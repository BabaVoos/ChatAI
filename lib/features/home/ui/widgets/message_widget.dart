import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpt/features/home/data/models/message_model.dart';

class MessageWidget extends StatefulWidget {
  const MessageWidget({
    super.key,
    required this.message,
    required this.isLast,
    required this.scrollToBottom,
  });

  final MessageModel message;
  final bool isLast;
  final Function() scrollToBottom;

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  String visibleText = '';
  late String fullMessage;

  @override
  void initState() {
    super.initState();
    fullMessage = widget.message.text;
    if (!widget.message.isUser &&
        widget.isLast &&
        (DateTime.now().millisecondsSinceEpoch -
                widget.message.time.millisecondsSinceEpoch <=
            10000)) {
      typeWriterEffect();
    } else {
      visibleText = fullMessage;
    }
  }

  Future<void> typeWriterEffect() async {
    for (int i = 0; i < fullMessage.length; i++) {
      await Future.delayed(const Duration(milliseconds: 30));
      if (!mounted) return;
      setState(() {
        visibleText = fullMessage.substring(0, i + 1);
      });
    }
    widget.scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          widget.message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.7,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: widget.message.isUser ? Colors.grey.shade100 : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.message.image != null)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(widget.message.image!.path),
                    height: 300,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            GestureDetector(
              onLongPress: () async {
                await onMessageTapped(context);
              },
              child: SizedBox(
                child: Text(
                  visibleText == fullMessage ? visibleText : '$visibleText|',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onMessageTapped(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: fullMessage));
    if (mounted) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey.shade100,
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          content: const Text(
            'Message copied to clipboard',
            style: TextStyle(fontSize: 20, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
