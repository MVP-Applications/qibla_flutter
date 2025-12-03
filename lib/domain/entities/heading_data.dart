import 'package:equatable/equatable.dart';

class HeadingData extends Equatable {
  final double heading;
  final double? accuracy;

  const HeadingData({
    required this.heading,
    this.accuracy,
  });

  @override
  List<Object?> get props => [heading, accuracy];
}
