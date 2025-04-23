import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt/core/utils/spacing.dart';
import 'package:gpt/features/home/ui/cubit/chat_cubit.dart';
import 'package:gpt/features/home/ui/widgets/drawer_item.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  void initState() {
    context.read<ChatCubit>().getAllChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      child: BlocBuilder<ChatCubit, ChatState>(
        buildWhen: (previous, current) => current is GetChatsSuccess,
        builder: (context, state) {
          final chats = state is GetChatsSuccess ? state.chats : [];
          return SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade100),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Chats',
                        style: GoogleFonts.slabo13px(
                          color: Colors.black,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                if (chats.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No chats yet',
                        style: TextStyle(color: Colors.grey, fontSize: 18),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      separatorBuilder:
                          (_, index) => const VerticalSpacing(height: 20),
                      itemCount: chats.length,
                      itemBuilder: (_, index) {
                        final chat = chats[index];
                        return DrawerItem(chat: chat);
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
