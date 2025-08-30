import 'package:flutter/material.dart';

class ScoreBoard extends StatelessWidget {
  final int xScore;
  final int oScore;

  const ScoreBoard({
    super.key,
    required this.xScore,
    required this.oScore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildScoreCard('Player X', xScore, const Color(0xFF33D17A)),
        _buildScoreCard('Player O', oScore, const Color(0xFFF95B5B)),
      ],
    );
  }

  Widget _buildScoreCard(String player, int score, Color color) {
    return Column(
      children: [
        Text(
          player,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          score.toString(),
          style: TextStyle(
            color: color,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}