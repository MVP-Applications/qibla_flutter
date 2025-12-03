import 'package:flutter/material.dart';

class DirectionArrow extends StatelessWidget {
  final double differenceAngle;

  const DirectionArrow({
    super.key,
    required this.differenceAngle,
  });

  @override
  Widget build(BuildContext context) {
    final shouldMoveRight = differenceAngle > 0;
    final directionText = shouldMoveRight ? 'Move Right' : 'Move Left';
    final iconData = shouldMoveRight
        ? Icons.arrow_forward_rounded
        : Icons.arrow_back_rounded;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              directionText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Icon(
            iconData,
            size: 100,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
