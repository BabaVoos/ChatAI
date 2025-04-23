import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt/features/home/ui/cubit/chat_cubit.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({super.key, required this.chat});

  final dynamic chat;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (_) => context.read<ChatCubit>().deleteChat(chat.id),
      key: ValueKey(chat.id),
      child: GestureDetector(
        onTap: () {
          context.read<ChatCubit>().startOldSession(chat.id);
          Navigator.pop(context);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            chat.title,
            style: GoogleFonts.slabo13px(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
