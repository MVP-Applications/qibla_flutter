import 'core/di/injection.dart';
import 'presentation/cubits/ar_cubit.dart';

/// Pre-initializes the AR system for faster loading.
/// Call this during app startup (e.g., in main() or splash screen).
///
/// This function requests necessary permissions and calculates Qibla direction
/// in advance, so the AR view loads instantly when opened.
///
/// Example usage:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   configureDependencies();
///   await preInitializeAR();
///   runApp(MyApp());
/// }
///
/// // In your AR page setup:
/// BlocProvider.value(
///   value: getIt<ARCubit>(),
///   child: ARQiblaPage(...),
/// )
/// ```
Future<void> preInitializeAR({double? existingQiblaBearing}) async {
  final arCubit = getIt<ARCubit>();
  await arCubit.initializeAR(existingQiblaBearing: existingQiblaBearing);
}
