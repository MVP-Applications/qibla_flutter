import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'presentation/pages/splash_page.dart';
import 'presentation/cubits/qibla_cubit.dart';
import 'presentation/cubits/tilt_cubit.dart';
import 'presentation/cubits/ar_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Lock to portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  // Initialize dependency injection
  configureDependencies();
  
  runApp(const QiblaApp());
}

class QiblaApp extends StatelessWidget {
  const QiblaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<QiblaCubit>()),
        BlocProvider(create: (_) => getIt<TiltCubit>()),
        BlocProvider(create: (_) => getIt<ARCubit>()),
      ],
      child: MaterialApp(
        title: 'Qibla Finder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
        ),
        home: const SplashPage(),
      ),
    );
  }
}
