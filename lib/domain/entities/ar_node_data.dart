import 'package:equatable/equatable.dart';
import 'package:vector_math/vector_math_64.dart';

class ARNodeData extends Equatable {
  final String id;
  final Vector3 position;
  final Vector3 rotation;
  final Vector3 scale;
  final String modelPath;
  final bool isPlaced;

  const ARNodeData({
    required this.id,
    required this.position,
    required this.rotation,
    required this.scale,
    required this.modelPath,
    this.isPlaced = false,
  });

  ARNodeData copyWith({
    String? id,
    Vector3? position,
    Vector3? rotation,
    Vector3? scale,
    String? modelPath,
    bool? isPlaced,
  }) {
    return ARNodeData(
      id: id ?? this.id,
      position: position ?? this.position,
      rotation: rotation ?? this.rotation,
      scale: scale ?? this.scale,
      modelPath: modelPath ?? this.modelPath,
      isPlaced: isPlaced ?? this.isPlaced,
    );
  }

  @override
  List<Object?> get props => [id, position, rotation, scale, modelPath, isPlaced];
}
