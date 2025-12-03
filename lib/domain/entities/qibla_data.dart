import 'package:equatable/equatable.dart';

class QiblaData extends Equatable {
  final double qiblaDirection;
  final double deviceHeading;
  final double differenceAngle;
  final bool isAligned;

  const QiblaData({
    required this.qiblaDirection,
    required this.deviceHeading,
    required this.differenceAngle,
    required this.isAligned,
  });

  bool get shouldMoveRight => differenceAngle > 0;
  bool get shouldMoveLeft => differenceAngle < 0;

  @override
  List<Object?> get props => [qiblaDirection, deviceHeading, differenceAngle, isAligned];
}
