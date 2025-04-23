import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OptionWidget extends StatelessWidget {
  const OptionWidget({
    super.key,
    required this.icon,
    this.backgroundColor,
    this.onTap,
  });

  // ignore: prefer_typing_uninitialized_variables
  final icon;
  final Color? backgroundColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          border: Border.all(color: Colors.grey.shade100, width: 1.5),
          shape: BoxShape.circle,
        ),
        child:
            icon.runtimeType == String
                ? SvgPicture.asset(icon)
                : Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
