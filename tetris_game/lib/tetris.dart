import 'dart:math';

enum TetrominoType {
  I,
  O,
  T,
  L,
  J,
  S,
  Z,
}

class Tetromino {
  Tetromino(this.type) : cells = _tetrominoCells(type);

  final TetrominoType type;
  List<List<int>> cells;

  static List<List<int>> _tetrominoCells(TetrominoType type) {
    switch (type) {
      case TetrominoType.I:
        return [
          [0, 0, 0, 0],
          [1, 1, 1, 1],
          [0, 0, 0, 0],
          [0, 0, 0, 0],
        ];
      case TetrominoType.O:
        return [
          [2, 2],
          [2, 2],
        ];
      case TetrominoType.T:
        return [
          [0, 3, 0],
          [3, 3, 3],
          [0, 0, 0],
        ];
      case TetrominoType.L:
        return [
          [0, 0, 4],
          [4, 4, 4],
          [0, 0, 0],
        ];
      case TetrominoType.J:
        return [
          [5, 0, 0],
          [5, 5, 5],
          [0, 0, 0],
        ];
      case TetrominoType.S:
        return [
          [0, 6, 6],
          [6, 6, 0],
          [0, 0, 0],
        ];
      case TetrominoType.Z:
        return [
          [7, 7, 0],
          [0, 7, 7],
          [0, 0, 0],
        ];
    }
  }
}

class TetrisBoard {
  TetrisBoard({this.rows = 20, this.cols = 10})
      : board = List.generate(rows, (_) => List.filled(cols, 0));

  final int rows;
  final int cols;
  List<List<int>> board;
  Tetromino? currentPiece;
  int currentX = 0;
  int currentY = 0;
  int score = 0;
  int level = 1;
  bool gameOver = false;
  final Random random = Random();

  void reset() {
    board = List.generate(rows, (_) => List.filled(cols, 0));
    currentPiece = null;
    currentX = 0;
    currentY = 0;
    score = 0;
    level = 1;
    gameOver = false;
    spawnPiece();
  }

  void spawnPiece() {
    final type = TetrominoType.values[random.nextInt(TetrominoType.values.length)];
    currentPiece = Tetromino(type);
    currentX = (cols - currentPiece!.cells[0].length) ~/ 2;
    currentY = -2;
    if (!isValidMove(currentX, currentY, currentPiece!.cells)) {
      gameOver = true;
    }
  }

  bool isValidMove(int x, int y, List<List<int>> cells) {
    for (var i = 0; i < cells.length; i++) {
      for (var j = 0; j < cells[i].length; j++) {
        if (cells[i][j] != 0) {
          final boardX = x + j;
          final boardY = y + i;
          if (boardX < 0 || boardX >= cols || boardY >= rows || (boardY >= 0 && board[boardY][boardX] != 0)) {
            return false;
          }
        }
      }
    }
    return true;
  }

  void movePiece(int dx, int dy) {
    if (currentPiece == null) return;
    final newX = currentX + dx;
    final newY = currentY + dy;
    if (isValidMove(newX, newY, currentPiece!.cells)) {
      currentX = newX;
      currentY = newY;
    } else if (dy == 1) {
      placePiece();
    }
  }

  void rotatePiece() {
    if (currentPiece == null) return;
    final rotatedCells = rotateMatrix(currentPiece!.cells);
    if (isValidMove(currentX, currentY, rotatedCells)) {
      currentPiece!.cells = rotatedCells;
    }
  }

  List<List<int>> rotateMatrix(List<List<int>> matrix) {
    final rows = matrix.length;
    final cols = matrix[0].length;
    final rotated = List.generate(cols, (j) => List.generate(rows, (i) => matrix[rows - 1 - i][j]));
    return rotated;
  }

  void placePiece() {
    if (currentPiece == null) return;
    for (var i = 0; i < currentPiece!.cells.length; i++) {
      for (var j = 0; j < currentPiece!.cells[i].length; j++) {
        if (currentPiece!.cells[i][j] != 0) {
          final boardX = currentX + j;
          final boardY = currentY + i;
          if (boardY >= 0) {
            board[boardY][boardX] = currentPiece!.cells[i][j];
          }
        }
      }
    }
    currentPiece = null;
    clearLines();
  }

  void clearLines() {
    int linesCleared = 0;
    for (var i = rows - 1; i >= 0; i--) {
      if (board[i].every((cell) => cell != 0)) {
        board.removeAt(i);
        board.insert(0, List.filled(cols, 0));
        linesCleared++;
        i++;
      }
    }
    if (linesCleared > 0) {
      updateScore(linesCleared);
    }
    if (!gameOver) {
      spawnPiece();
    }
  }

  void updateScore(int linesCleared) {
    switch (linesCleared) {
      case 1:
        score += 100 * level;
        break;
      case 2:
        score += 300 * level;
        break;
      case 3:
        score += 500 * level;
        break;
      case 4:
        score += 800 * level;
        break;
    }
    // Increase level every 1000 points
    if (score >= level * 1000) {
      level++;
    }
  }
}
