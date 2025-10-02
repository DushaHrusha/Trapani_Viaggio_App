import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/cubits/apartments_cubit.dart';
import 'bloc/cubits/bookmarks_cubit.dart';
import 'bloc/cubits/chat_cubit.dart';
import 'bloc/cubits/excursion_cubit.dart';
import 'bloc/cubits/vehicle_cubit.dart';
import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ApartmentCubit()),
        BlocProvider(create: (context) => ChatCubit()),
        BlocProvider(create: (context) => ExcursionCubit()),
        BlocProvider(create: (context) => VehicleCubit()),
        BlocProvider(create: (context) => BookmarksCubit()),
      ],
      child: //DevicePreview(
          //  enabled: true,
          //tools: const [...DevicePreview.defaultTools],
          //  builder: (context) =>
          const MyApp(),
      //   ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Trapani Viaggio App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
