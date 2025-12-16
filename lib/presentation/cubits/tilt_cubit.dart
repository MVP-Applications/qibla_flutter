import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_device_tilt.dart';
import 'tilt_state.dart';

/// Cubit for monitoring device tilt/vertical position
class TiltCubit extends Cubit<TiltState> {
  final GetDeviceTilt getDeviceTilt;
  StreamSubscription? _tiltSubscription;
  Timer? _animationTimer;
  bool _animateIcon = false;

  TiltCubit({required this.getDeviceTilt}) : super(TiltInitial());

  /// Start monitoring device tilt
  void startMonitoring() {
    _tiltSubscription = getDeviceTilt().listen((isVertical) {
      if (isVertical) {
        _stopAnimation();
        emit(TiltVertical());
      } else {
        _startAnimation();
      }
    });
  }

  void _startAnimation() {
    _animationTimer ??= Timer.periodic(
      const Duration(milliseconds: 800),
      (_) {
        _animateIcon = !_animateIcon;
        emit(TiltNotVertical(_animateIcon));
      },
    );
  }

  void _stopAnimation() {
    _animationTimer?.cancel();
    _animationTimer = null;
    _animateIcon = false;
  }

  @override
  Future<void> close() {
    _tiltSubscription?.cancel();
    _animationTimer?.cancel();
    return super.close();
  }
}
