import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qibla_ar_finder/qibla_ar_finder.dart';
import 'package:qibla_ar_finder/src/core/di/injection.dart';
import 'package:qibla_ar_finder/src/presentation/controllers/ar_cubit.dart';
import 'package:qibla_ar_finder/src/presentation/controllers/qibla_cubit.dart';
import 'package:qibla_ar_finder/src/presentation/controllers/tilt_cubit.dart';

void main() {
  // Initialize dependency injection
  configureDependencies();
  
  runApp(const QiblaARFinderExample());
}

class QiblaARFinderExample extends StatelessWidget {
  const QiblaARFinderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<QiblaCubit>()),
        BlocProvider(create: (_) => getIt<TiltCubit>()),
        BlocProvider(create: (_) => getIt<ARCubit>()),
      ],
      child: MaterialApp(
        title: 'Qibla AR Finder Example',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
        ),
        home: const ExampleHomePage(),
      ),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qibla AR Finder'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.mosque,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            const Text(
              'Qibla AR Finder',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Find Qibla direction using AR',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: context.read<QiblaCubit>()),
                        BlocProvider.value(value: context.read<TiltCubit>()),
                        BlocProvider.value(value: context.read<ARCubit>()),
                      ],
                      child: const QiblaARPage(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.view_in_ar),
              label: const Text('Open AR View'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
