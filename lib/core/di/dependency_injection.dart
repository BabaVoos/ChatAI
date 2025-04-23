import 'package:get_it/get_it.dart';
import 'package:gpt/core/services/cache_service.dart';
import 'package:gpt/core/services/camera_service.dart';
import 'package:gpt/core/services/chat_service.dart';
import 'package:gpt/features/home/ui/cubit/chat_cubit.dart';

GetIt sl = GetIt.instance;

Future<void> initSl() async {
  sl.registerLazySingleton(() => CameraService());
  sl.registerLazySingleton(() => CacheService());

  sl.registerFactory(() => ChatService());

  await sl<CacheService>().init();

  sl.registerLazySingleton(
    () => ChatCubit(cacheService: sl(), cameraService: sl(), chatService: sl()),
  );
}
