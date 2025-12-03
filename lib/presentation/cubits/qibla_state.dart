import 'package:equatable/equatable.dart';
import '../../domain/entities/qibla_data.dart';

abstract class QiblaState extends Equatable {
  const QiblaState();

  @override
  List<Object?> get props => [];
}

class QiblaInitial extends QiblaState {}

class QiblaLoading extends QiblaState {}

class QiblaPermissionDenied extends QiblaState {}

class QiblaUpdated extends QiblaState {
  final QiblaData qiblaData;

  const QiblaUpdated(this.qiblaData);

  @override
  List<Object?> get props => [qiblaData];
}

class QiblaError extends QiblaState {
  final String message;

  const QiblaError(this.message);

  @override
  List<Object?> get props => [message];
}
