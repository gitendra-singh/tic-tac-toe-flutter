import 'package:flutter/material.dart';

class BoardCell extends StatelessWidget {
  final String value;
  final VoidCallback onTap;

  const BoardCell({
    super.key,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF161F2C),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: value == 'X' ? const Color(0xFF33D17A) : const Color(0xFFF95B5B),
            ),
          ),
        ),
      ),
    );
  }
}
