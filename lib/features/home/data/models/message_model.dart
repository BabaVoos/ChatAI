import 'dart:io';
import 'package:hive/hive.dart';

part 'message_model.g.dart';

@HiveType(typeId: 0)
class MessageModel extends HiveObject {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final bool isUser;

  @HiveField(2)
  final int timeInMillis;

  @HiveField(3)
  final String? imagePath;

  MessageModel({
    required this.text,
    required this.isUser,
    required DateTime time,
    File? image,
  })  : timeInMillis = time.millisecondsSinceEpoch,
        imagePath = image?.path;

  DateTime get time => DateTime.fromMillisecondsSinceEpoch(timeInMillis);
  File? get image => imagePath != null ? File(imagePath!) : null;
}