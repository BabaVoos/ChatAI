import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpt/features/home/ui/cubit/chat_cubit.dart';
import 'package:gpt/features/home/ui/widgets/option_widget.dart';

class SendMessageButton extends StatelessWidget {
  const SendMessageButton({
    super.key,
    required this.isInputEmpty,
    required TextEditingController controller,
  }) : _controller = controller;

  final bool isInputEmpty;
  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      buildWhen:
          (previous, current) =>
              current is WaitingForResponse || current is ChatSuccess,
      builder: (context, state) {
        if (state is WaitingForResponse) {
          return const CircularProgressIndicator(
            color: Colors.black,
            constraints: BoxConstraints.tightFor(width: 20, height: 20),
          );
        }
        return OptionWidget(
          icon: Icons.arrow_upward,
          backgroundColor: Colors.black,
          onTap: () {
            context.read<ChatCubit>().sendMessage(_controller.text.trim());
            _controller.clear();
            context.read<ChatCubit>().removeImage();
            FocusManager.instance.primaryFocus?.unfocus();
          },
        );
      },
    );
  }
}
