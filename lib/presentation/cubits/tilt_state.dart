import 'package:equatable/equatable.dart';

abstract class TiltState extends Equatable {
  const TiltState();

  @override
  List<Object?> get props => [];
}

class TiltInitial extends TiltState {}

class TiltVertical extends TiltState {}

class TiltNotVertical extends TiltState {
  final bool animateIcon;

  const TiltNotVertical(this.animateIcon);

  @override
  List<Object?> get props => [animateIcon];
}
