import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tic_tac_toe/board_cell.dart';
import 'package:tic_tac_toe/score_board.dart';
import 'package:tic_tac_toe/winning_line_painter.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late List<String> _board;
  late bool _isXTurn;
  String? _winner;
  bool _isDraw = false;
  int _xScore = 0;
  int _oScore = 0;
  List<int> _winningLine = [];
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeGame();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }
  
  void _initializeGame() {
    _board = List.filled(9, '');
    _isXTurn = true;
    _winner = null;
    _isDraw = false;
    _winningLine = [];
  }

  void _resetGame() {
    setState(() {
      _initializeGame();
      _animationController.reset();
    });
  }

  void _handleTap(int index) {
    if (_board[index].isNotEmpty || _winner != null) {
      return;
    }

    HapticFeedback.lightImpact();

    setState(() {
      _board[index] = _isXTurn ? 'X' : 'O';
      _checkWinner();
      if (_winner == null && !_isDraw) {
        _isXTurn = !_isXTurn;
      }
    });
  }

  void _checkWinner() {
    const List<List<int>> winningPositions = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ];

    for (var pos in winningPositions) {
      if (_board[pos[0]].isNotEmpty &&
          _board[pos[0]] == _board[pos[1]] &&
          _board[pos[0]] == _board[pos[2]]) {
        
        _winner = _board[pos[0]];
        _winningLine = pos;
        if (_winner == 'X') {
          _xScore++;
        } else {
          _oScore++;
        }
        _animationController.forward(from: 0.0);
        _showEndDialog('Player $_winner Wins!');
        return;
      }
    }

    if (!_board.contains('')) {
      _isDraw = true;
      _showEndDialog('It\'s a Draw!');
    }
  }

  Future<void> _showEndDialog(String title) {
    return Future.delayed(const Duration(milliseconds: 300), () {
        showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1E2A3B).withOpacity(0.9),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            actions: <Widget>[
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF33D17A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: const Text(
                    'Play Again',
                    style: TextStyle(
                      color: Color(0xFF161F2C),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _resetGame();
                  },
                ),
              )
            ],
            actionsAlignment: MainAxisAlignment.center,
          );
        },
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ScoreBoard(xScore: _xScore, oScore: _oScore),
              _buildGameBoard(),
              _buildGameStatus(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameBoard() {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF1E2A3B),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(4, 4),
            )
          ],
        ),
        child: Stack(
          children: [
            GridView.builder(
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return BoardCell(
                  value: _board[index],
                  onTap: () => _handleTap(index),
                );
              },
            ),
            if (_winner != null)
              CustomPaint(
                size: Size.infinite,
                painter: WinningLinePainter(
                  winningLine: _winningLine, 
                  animation: _animation,
                  winner: _winner!,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameStatus() {
    String status;
    if (_winner != null) {
      status = 'Player $_winner Wins!';
    } else if (_isDraw) {
      status = 'It\'s a Draw!';
    } else {
      status = 'Player ${_isXTurn ? "X" : "O"}\'s Turn';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_winner == null && !_isDraw)
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: _isXTurn ? const Color(0xFF33D17A) : const Color(0xFFF95B5B),
              shape: BoxShape.circle,
            ),
          ),
        const SizedBox(width: 12),
        Text(
          status,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
