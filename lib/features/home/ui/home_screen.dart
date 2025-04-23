import 'package:flutter/material.dart';
import 'package:gpt/features/home/ui/widgets/custom_app_bar.dart';
import 'package:gpt/features/home/ui/widgets/home_drawer.dart';
import 'package:gpt/features/home/ui/widgets/input_section.dart';
import 'package:gpt/features/home/ui/widgets/message_list_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override

  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      drawer: HomeDrawer(),
      body: Column(
        children: [Expanded(child: MessageListView()), InputSection()],
      ),
    );
  }
}
