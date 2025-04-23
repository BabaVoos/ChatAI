import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gpt/core/utils/assets_manager.dart';
import 'package:gpt/features/home/ui/cubit/chat_cubit.dart';
import 'package:gpt/features/home/ui/widgets/option_widget.dart';

class ImagePickerWidget extends StatelessWidget {
  const ImagePickerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      buildWhen:
          (previous, current) =>
              current is ImagePicked || current is ImageRemoved,
      builder: (context, state) {
        if (state is ImagePicked) {
          return Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  state.imagePath,
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap:
                      () => context.read<ChatCubit>().removeImage(),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(100),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return OptionWidget(
          icon: AssetsManager.image,
          onTap: () => context.read<ChatCubit>().pickImage(),
        );
      },
    );
  }
}
