import 'package:equatable/equatable.dart';
import '../../domain/entities/ar_node_data.dart';

abstract class ARState extends Equatable {
  const ARState();

  @override
  List<Object?> get props => [];
}

class ARInitial extends ARState {}

class ARLoading extends ARState {}

class ARReady extends ARState {}

class ARPlaneDetected extends ARState {}

class ARObjectPlaced extends ARState {
  final ARNodeData nodeData;

  const ARObjectPlaced(this.nodeData);

  @override
  List<Object?> get props => [nodeData];
}

class ARObjectUpdated extends ARState {
  final ARNodeData nodeData;

  const ARObjectUpdated(this.nodeData);

  @override
  List<Object?> get props => [nodeData];
}

class ARObjectRemoved extends ARState {}

class ARError extends ARState {
  final String message;

  const ARError(this.message);

  @override
  List<Object?> get props => [message];
}
