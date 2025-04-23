import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpt/core/utils/assets_manager.dart';
import 'package:gpt/features/home/ui/cubit/chat_cubit.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: SvgPicture.asset(AssetsManager.menu),
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          Text(
            'ChatGPT',
            style: GoogleFonts.slabo13px(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          GestureDetector(
            onTap: () {
              context.read<ChatCubit>().startNewSession();
            },
            child: SvgPicture.asset(AssetsManager.edit),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);
}
