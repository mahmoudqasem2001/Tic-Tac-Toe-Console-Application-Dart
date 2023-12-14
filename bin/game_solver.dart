import 'dart:io';
import 'dart:core';

bool winner = false;
bool isXturn = true;
int moveCount = 0;
String player1Marker = 'X';
String player2Marker = 'O';

List<String> values = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];
List<String> combinations = [
  '012',
  '048',
  '036',
  '147',
  '246',
  '258',
  '345',
  '678'
];

// Check if the combination is true or false for a player (X or O)
bool checkCombination(String combination, String checkFor) {
  List<int> numbers = combination.split('').map((item) {
    return int.parse(item);
  }).toList();

  bool match = false;
  for (final item in numbers) {
    if (values[item] == checkFor) {
      match = true;
    } else {
      match = false;
      break;
    }
  }
  return match;
}

void checkWinner(String player) {
  for (final item in combinations) {
    bool combinationValidity = checkCombination(item, player);
    if (combinationValidity) {
      print('$player WON!');
      winner = true;
      break;
    }
  }
}

// Get input from human player
void getPlayerInput() {
  print(
      'Player ${isXturn ? 1 : 2}, please enter the number of the square where you want to place your ${isXturn ? player1Marker : player2Marker}:');
  int number = int.parse(stdin.readLineSync()!);
  values[number - 1] = isXturn ? player1Marker : player2Marker;
  isXturn = !isXturn;
  moveCount++;

  if (moveCount == 9) {
    winner = true;
    print('DRAW!');
  } else {
    clearScreen();
    generateBoard();
  }

  checkWinner(player1Marker);
  checkWinner(player2Marker);

  if (winner == false) {
    getAIInput();
  }
}

// Get input from AI opponent
void getAIInput() {
  // Check for winning move
  int aiWinningMove = findWinningMove(player2Marker);
  if (aiWinningMove != -1) {
    values[aiWinningMove] = player2Marker;
  } else {
    // Check for blocking opponent's winning move
    int blockMove = findWinningMove(player1Marker);
    if (blockMove != -1) {
      values[blockMove] = player2Marker;
    } else {
      // Make a strategic move (prioritize center, corners, then edges)
      int strategicMove = findStrategicMove();
      values[strategicMove] = player2Marker;
    }
  }

  isXturn = !isXturn;
  moveCount++;

  if (moveCount == 9) {
    winner = true;
    print('DRAW!');
  } else {
    clearScreen();
    generateBoard();
  }

  checkWinner(player1Marker);
  checkWinner(player2Marker);

  if (winner == false) {
    getPlayerInput(); // Switch back to human player after AI move
  }
}

// Find a winning move or a blocking move
int findWinningMove(String marker) {
  for (final item in combinations) {
    List<int> numbers = item.split('').map((item) => int.parse(item)).toList();
    int count = 0;
    int emptyIndex = -1;

    for (final number in numbers) {
      if (values[number] == marker) {
        count++;
      } else if (values[number] != player1Marker &&
          values[number] != player2Marker) {
        emptyIndex = number;
      }
    }

    if (count == 2 && emptyIndex != -1) {
      return emptyIndex;
    }
  }

  return -1;
}

// Find a strategic move (center, corners, then edges)
int findStrategicMove() {
  // Prioritize center
  if (values[4] != player1Marker && values[4] != player2Marker) {
    return 4;
  }

  // Prioritize corners
  List<int> corners = [0, 2, 6, 8];
  for (final corner in corners) {
    if (values[corner] != player1Marker && values[corner] != player2Marker) {
      return corner;
    }
  }

  // Fill in any remaining empty edge
  for (int i = 1; i < values.length; i += 2) {
    if (values[i] != player1Marker && values[i] != player2Marker) {
      return i;
    }
  }

  // This should not happen with a valid board, but return 0 if no other move is found
  return 0;
}

// Allow players to choose their markers
void chooseMarkers() {
  print('Player 1, choose your marker (X or O):');
  player1Marker = stdin.readLineSync()!.toUpperCase();

  if (player1Marker != 'X' && player1Marker != 'O') {
    print('Invalid marker. Defaulting to X.');
    player1Marker = 'X';
  }

  player2Marker = (player1Marker == 'X') ? 'O' : 'X';

  print('Player 1 is $player1Marker, and Player 2 is $player2Marker.');
}

//clear console screen
void clearScreen() {
  if (Platform.isWindows) {
    Process.runSync("cls", [], runInShell: true);
  } else {
    Process.runSync("clear", [], runInShell: true);
  }
}

//Show current state of board
void generateBoard() {
  print('    |    |    ');
  print('  ${values[0]} |  ${values[1]} |  ${values[2]} ');
  print('____|____|____');
  print('    |    |    ');
  print('  ${values[3]} |  ${values[4]} |  ${values[5]} ');
  print('____|____|____');
  print('    |    |    ');
  print('  ${values[6]} |  ${values[7]} |  ${values[8]} ');
  print('    |    |    ');
}

void main(List<String> arguments) {
  print('---------------------------------------------------------------');
  print("-----------------Mahmoud Khaled Jamal Qasem--------------------");
  print('---------------------------------------------------------------');
  chooseMarkers();
  generateBoard();

  // Start the game with the first player (human)
  getPlayerInput();
}
