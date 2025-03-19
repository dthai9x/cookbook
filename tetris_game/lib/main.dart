import 'dart:async';
import 'package:flutter/material.dart';
import 'tetris.dart';

void main() {
  runApp(const TetrisApp());
}

class TetrisApp extends StatelessWidget {
  const TetrisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tetris',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TetrisHomePage(),
    );
  }
}

class TetrisHomePage extends StatefulWidget {
  const TetrisHomePage({super.key});

  @override
  State<TetrisHomePage> createState() => _TetrisHomePageState();
}

class _TetrisHomePageState extends State<TetrisHomePage> {
  late TetrisBoard board;
  Timer? gameTimer;

  @override
  void initState() {
    super.initState();
    board = TetrisBoard();
    board.reset();
    startGame();
  }

  void startGame() {
    gameTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        if (!board.gameOver) {
          board.movePiece(0, 1);
        } else {
          gameTimer?.cancel();
          _showGameOverDialog();
        }
      });
    });
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Game Over"),
          content: Text("Your score: ${board.score}"),
          actions: [
            TextButton(
              child: const Text("Play Again"),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  board.reset();
                  startGame();
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tetris'),
      ),
      body: Column(
        children: [
          Text("Score: ${board.score}"),
          Text("Level: ${board.level}"),
          const SizedBox(height: 20),
          _buildGameBoard(),
          _buildControls(),
        ],
      ),
    );
  }

  Widget _buildGameBoard() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: board.cols,
      ),
      itemCount: board.rows * board.cols,
      itemBuilder: (context, index) {
        final row = index ~/ board.cols;
        final col = index % board.cols;
        final cellValue = board.board[row][col];

        if (board.currentPiece != null &&
            row >= board.currentY &&
            row < board.currentY + board.currentPiece!.cells.length &&
            col >= board.currentX &&
            col < board.currentX + board.currentPiece!.cells[0].length) {
          final pieceRow = row - board.currentY;
          final pieceCol = col - board.currentX;
          if (pieceRow >= 0 && pieceCol >= 0 && pieceRow < board.currentPiece!.cells.length && pieceCol < board.currentPiece!.cells[0].length) {
            final pieceCellValue = board.currentPiece!.cells[pieceRow][pieceCol];
            if (pieceCellValue != 0) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: _getColorForCellValue(pieceCellValue),
                ),
              );
            }
          }
        }

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: cellValue != 0 ? _getColorForCellValue(cellValue) : Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              board.movePiece(-1, 0);
            });
          },
          child: const Text('Left'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              board.rotatePiece();
            });
          },
          child: const Text('Rotate'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              board.movePiece(1, 0);
            });
          },
          child: const Text('Right'),
        ),
      ],
    );
  }

  Color _getColorForCellValue(int value) {
    switch (value) {
      case 1:
        return Colors.cyan;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.blue;
      case 6:
        return Colors.green;
      case 7:
        return Colors.red;
      default:
        return Colors.white;
    }
  }
}
