import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'gamebuttons.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final navigatorKey = GlobalKey<NavigatorState>();
  final title = 'Grid List';
  int _filledBoxes = 0;
  var winner = '';
  var winX = 0;
  var winO = 0;
  var tied = 0;
  var pl1 = 'You';
  var pl2 = 'BOT';
  var turn = true;
  var switchValue = false;
  var gamemode = 'VS BOT';
  var player1 = [];
  var player2 = [];
  String gamestr = 'Start the game !';

  List listButton = <GameButton>[
    GameButton(1),
    GameButton(2),
    GameButton(3),
    GameButton(4),
    GameButton(5),
    GameButton(6),
    GameButton(7),
    GameButton(8),
    GameButton(9)
  ];

  void reset() {
    for (int i = 0; i < 9; i++) {
      listButton[i].str = '';
      listButton[i].enabled = true;
      listButton[i].clr = const Color(0xFF211354);
    }
    player1 = [];
    player2 = [];
    _filledBoxes = 0;
    gamestr = 'Start the game !';
  }

// checking winner
  bool checkWinner(var player) {
    if (player.contains(0) && player.contains(1) && player.contains(2))
      return true;
    if (player.contains(3) && player.contains(4) && player.contains(5))
      return true;
    if (player.contains(6) && player.contains(7) && player.contains(8))
      return true;
    if (player.contains(0) && player.contains(3) && player.contains(6))
      return true;
    if (player.contains(1) && player.contains(4) && player.contains(7))
      return true;
    if (player.contains(2) && player.contains(5) && player.contains(8))
      return true;
    if (player.contains(0) && player.contains(4) && player.contains(8))
      return true;
    if (player.contains(2) && player.contains(4) && player.contains(6))
      return true;

    return false;
  }

// Game logic

  void playGame(int index) {
    // if statement to switch game modes

    if (switchValue) {
      // player 1
      if (listButton[index].enabled && turn) {
        listButton[index].str = 'X';
        listButton[index].enabled = false;
        player1.add(index);
        turn = false;
        _filledBoxes += 1;
        gamestr = 'O turn';
      }

      // player 2 -- Manual

      if (listButton[index].enabled && !turn) {
        listButton[index].str = 'O';
        listButton[index].enabled = false;
        player2.add(index);
        turn = true;
        _filledBoxes += 1;
        gamestr = 'X turn';
      }
      if (checkWinner(player1)) {
        for (int i = 0; i < 9; i++) {
          listButton[i].enabled = false;
          listButton[i].clr = const Color(0xFF211354);
        }
        winX += 1;
        winner = 'Player 1';
        _showWinnerDialog((player) => 1);
        gamestr = "Game Over";

        return;
      }
      if (checkWinner(player2)) {
        for (int i = 0; i < 9; i++) {
          listButton[i].enabled = false;
          listButton[i].clr = const Color(0xFF211354);
        }
        gamestr = "Game Over";
        winO += 1;
        _showWinnerDialog((player) => 2);
        winner = 'Player 2';
        return;
      }

      if (!checkWinner(player1) && !checkWinner(player2) && _filledBoxes == 9) {
        for (int i = 0; i < 9; i++) {
          listButton[i].enabled = false;
          listButton[i].clr = const Color(0xFF211354);
        }
        gamestr = "Tie";
        winner = 'No one - Tie';
        _showWinnerDialog((player) => 2);
        tied += 1;
        return;
      }
    }

    // if statement to switch game modes
    if (!switchValue) {
      turn = false;
      // player 1
      if (listButton[index].enabled && !turn && !checkWinner(player2)) {
        listButton[index].str = 'X';
        listButton[index].enabled = false;
        player1.add(index);
        _filledBoxes += 1;
        turn = true;
        gamestr = 'Bot is thinking ...';
      }

      if (checkWinner(player1)) {
        for (int i = 0; i < 9; i++) {
          listButton[i].enabled = false;
          listButton[i].clr = const Color(0xFF211354);
        }
        winX += 1;
        gamestr = "Game Over";
        winner = 'YOU !';
        _showWinnerDialog((player) => 1);
        return;
      }

      // player 2 -- Auto
      var allPlayedButtons = List.from(player1)..addAll(player2);
      // add move function for the bot

      void addMoveForBot(i) {
        listButton[i].str = 'O';
        listButton[i].enabled = false;
        _filledBoxes += 1;
        player2.add(i);
        turn = !turn;
        gamestr = 'Your turn !';
      }

      if (checkWinner(player2)) {
        for (int i = 0; i < 9; i++) {
          listButton[i].enabled = false;
          listButton[i].clr = const Color(0xFF211354);
        }
        gamestr = "Game over";
        _showWinnerDialog((player) => 2);
        winO += 1;
        winner = 'the BOT';
        return;
      }

      if (!checkWinner(player1) && !checkWinner(player2) && _filledBoxes == 9) {
        for (int i = 0; i < 9; i++) {
          listButton[i].enabled = false;
          listButton[i].clr = const Color(0xFF211354);
        }
        gamestr = "Game Over";
        _showWinnerDialog((player) => 2);
        winner = 'No one - Tie';
        tied += 1;

        return;
      }

      // Alert bot fonction to never let the opponent win in obvious moves
      int i;
      if (turn && _filledBoxes > 2 && !checkWinner(player1)) {
        if (player1.contains(0) &&
                player1.contains(1) &&
                !allPlayedButtons.contains(2) ||
            player2.contains(0) &&
                player2.contains(1) &&
                !allPlayedButtons.contains(2)) {
          i = 2;
          addMoveForBot(i);
          return;
        }

        if (player1.contains(2) &&
                player1.contains(1) &&
                !allPlayedButtons.contains(0) ||
            player2.contains(2) &&
                player2.contains(1) &&
                !allPlayedButtons.contains(0)) {
          i = 0;
          addMoveForBot(i);
          return;
        }
        if (player1.contains(0) &&
                player1.contains(2) &&
                !allPlayedButtons.contains(1) ||
            player2.contains(0) &&
                player2.contains(2) &&
                !allPlayedButtons.contains(1)) {
          i = 1;
          addMoveForBot(i);
          return;
        }

        if (player1.contains(3) &&
                player1.contains(4) &&
                !allPlayedButtons.contains(5) ||
            player2.contains(3) &&
                player2.contains(4) &&
                !allPlayedButtons.contains(5)) {
          i = 5;
          addMoveForBot(i);
          return;
        }
        if (player1.contains(5) &&
                player1.contains(4) &&
                !allPlayedButtons.contains(3) ||
            player2.contains(5) &&
                player2.contains(4) &&
                !allPlayedButtons.contains(3)) {
          i = 3;
          addMoveForBot(i);
          return;
        }
        if (player1.contains(3) &&
                player1.contains(5) &&
                !allPlayedButtons.contains(4) ||
            player2.contains(3) &&
                player2.contains(5) &&
                !allPlayedButtons.contains(4)) {
          i = 4;
          addMoveForBot(i);
          return;
        }

        if (player1.contains(6) &&
                player1.contains(7) &&
                !allPlayedButtons.contains(8) ||
            player2.contains(6) &&
                player2.contains(7) &&
                !allPlayedButtons.contains(8)) {
          i = 8;
          addMoveForBot(i);
          return;
        }
        if (player1.contains(8) &&
                player1.contains(7) &&
                !allPlayedButtons.contains(6) ||
            player2.contains(8) &&
                player2.contains(7) &&
                !allPlayedButtons.contains(6)) {
          i = 6;
          addMoveForBot(i);
          return;
        }
        if (player1.contains(6) &&
                player1.contains(8) &&
                !allPlayedButtons.contains(7) ||
            player2.contains(6) &&
                player2.contains(8) &&
                !allPlayedButtons.contains(7)) {
          i = 7;
          addMoveForBot(i);
          return;
        }

        if (player1.contains(0) &&
                player1.contains(3) &&
                !allPlayedButtons.contains(6) ||
            player2.contains(0) &&
                player2.contains(3) &&
                !allPlayedButtons.contains(6)) {
          i = 6;
          addMoveForBot(i);
          return;
        }
        if (player1.contains(0) &&
                player1.contains(6) &&
                !allPlayedButtons.contains(3) ||
            player2.contains(0) &&
                player2.contains(6) &&
                !allPlayedButtons.contains(3)) {
          i = 3;
          addMoveForBot(i);
          return;
        }
        if (player1.contains(6) &&
                player1.contains(3) &&
                !allPlayedButtons.contains(0) ||
            player2.contains(6) &&
                player2.contains(3) &&
                !allPlayedButtons.contains(0)) {
          i = 0;
          addMoveForBot(i);
          return;
        }

        if (player1.contains(1) &&
                player1.contains(4) &&
                !allPlayedButtons.contains(7) ||
            player2.contains(1) &&
                player2.contains(4) &&
                !allPlayedButtons.contains(7)) {
          i = 7;
          addMoveForBot(i);
          return;
        }
        if (player1.contains(1) &&
                player1.contains(7) &&
                !allPlayedButtons.contains(4) ||
            player2.contains(1) &&
                player2.contains(7) &&
                !allPlayedButtons.contains(4)) {
          i = 4;
          addMoveForBot(i);
          return;
        }
        if (player1.contains(7) &&
                player1.contains(4) &&
                !allPlayedButtons.contains(1) ||
            player2.contains(7) &&
                player2.contains(4) &&
                !allPlayedButtons.contains(1)) {
          i = 1;
          addMoveForBot(i);
          return;
        }

        if (player1.contains(2) &&
                player1.contains(5) &&
                !allPlayedButtons.contains(8) ||
            player2.contains(2) &&
                player2.contains(5) &&
                !allPlayedButtons.contains(8)) {
          i = 8;
          addMoveForBot(i);
          return;
        }
        if (player1.contains(2) &&
                player1.contains(8) &&
                !allPlayedButtons.contains(5) ||
            player2.contains(2) &&
                player2.contains(8) &&
                !allPlayedButtons.contains(5)) {
          i = 5;
          addMoveForBot(i);
          return;
        }
        if (player1.contains(8) &&
                player1.contains(5) &&
                !allPlayedButtons.contains(2) ||
            player2.contains(8) &&
                player2.contains(5) &&
                !allPlayedButtons.contains(2)) {
          i = 2;
          addMoveForBot(i);
          return;
        }

        if (player1.contains(0) &&
                player1.contains(4) &&
                !allPlayedButtons.contains(8) ||
            player2.contains(0) &&
                player2.contains(4) &&
                !allPlayedButtons.contains(8)) {
          i = 8;
          addMoveForBot(i);
          return;
        }
        if (player1.contains(0) &&
                player1.contains(8) &&
                !allPlayedButtons.contains(4) ||
            player2.contains(0) &&
                player2.contains(8) &&
                !allPlayedButtons.contains(4)) {
          i = 4;
          addMoveForBot(i);
          return;
        }
        if (player1.contains(8) &&
                player1.contains(4) &&
                !allPlayedButtons.contains(0) ||
            player2.contains(8) &&
                player2.contains(4) &&
                !allPlayedButtons.contains(0)) {
          i = 0;
          addMoveForBot(i);
          return;
        }

        if (player1.contains(2) &&
                player1.contains(4) &&
                !allPlayedButtons.contains(6) ||
            player2.contains(2) &&
                player2.contains(4) &&
                !allPlayedButtons.contains(6)) {
          i = 6;
          addMoveForBot(i);
          return;
        }
        if (player1.contains(2) &&
                player1.contains(6) &&
                !allPlayedButtons.contains(4) ||
            player2.contains(2) &&
                player2.contains(6) &&
                !allPlayedButtons.contains(4)) {
          i = 4;
          addMoveForBot(i);
          return;
        }
        if (player1.contains(6) &&
                player1.contains(4) &&
                !allPlayedButtons.contains(2) ||
            player2.contains(6) &&
                player2.contains(4) &&
                !allPlayedButtons.contains(2)) {
          i = 2;
          addMoveForBot(i);
          return;
        }
        // just a bug of winning
        if (player1.contains(7) &&
            player1.contains(5) &&
            !allPlayedButtons.contains(2)) {
          i = 2;
          addMoveForBot(i);
          return;
        }
        if (player1.contains(2) &&
            player1.contains(6) &&
            !allPlayedButtons.contains(3)) {
          i = 3;
          addMoveForBot(i);
          return;
        }
        if (player1.contains(5) &&
            player1.contains(6) &&
            !allPlayedButtons.contains(7)) {
          i = 7;
          addMoveForBot(i);
          return;
        }
        if (player1.contains(0) &&
            player1.contains(5) &&
            !allPlayedButtons.contains(1)) {
          i = 1;
          addMoveForBot(i);
          return;
        }
        if (player1.contains(0) &&
            player1.contains(8) &&
            !allPlayedButtons.contains(1)) {
          i = 1;
          addMoveForBot(i);
          return;
        }
        if (player1.contains(4) &&
            player1.contains(8) &&
            !allPlayedButtons.contains(2)) {
          i = 2;
          addMoveForBot(i);
          return;
        }
        if (player1.contains(0) &&
            player1.contains(7) &&
            !allPlayedButtons.contains(3)) {
          i = 3;
          addMoveForBot(i);
          return;
        }
        if (player1.contains(1) &&
            player1.contains(8) &&
            !allPlayedButtons.contains(5)) {
          i = 5;
          addMoveForBot(i);
          return;
        }
      }
      if (turn && !checkWinner(player1)) {
        if (!allPlayedButtons.contains(4)) {
          addMoveForBot(4);
        } else if (!allPlayedButtons.contains(0)) {
          addMoveForBot(0);
        }
        for (i = 1; i < 9; i++) {
          if (!allPlayedButtons.contains(i) && turn) {
            addMoveForBot(i);
          }
          break;
        }
      }
    }
  }

  void _showWinnerDialog(checkwinner(player)) {
    Future.delayed(const Duration(milliseconds: 500), () {
      final context = navigatorKey.currentState!.overlay!.context;
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text('Game Over'),
              content: Text('The winner is $winner'),
              actions: [
                FlatButton(
                    onPressed: () {
                      setState(() {
                        reset();
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('reset'))
              ],
              backgroundColor: Colors.white,
            );
          });
    });
  }

// win status

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,

      // removing the DEBUG sticker
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: ThemeData(fontFamily: 'Acme'),
      home: Container(
        // setting a gradient background
        // ignore: prefer_const_constructors
        decoration: BoxDecoration(
            gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF600CFF),
            Color(0xFF211857),
          ],
        )),
        child: Scaffold(
          // added Transparent background so the Gradient can work.
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("Tic Tac Toe"),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: IconButton(
                  icon: const Icon(Icons.autorenew),
                  /*backgroundColor: const Color(0xFF600CFF),*/
                  onPressed: () {
                    setState(() {
                      reset();
                    });
                  }),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor: Colors.white,
                  ),
                  child: Checkbox(
                    value: switchValue,
                    checkColor: Colors.white,
                    onChanged: (value) {
                      setState(() {
                        reset();
                        switchValue = !switchValue;
                        if (switchValue) {
                          gamemode = 'VS Friend';
                          pl1 = 'PL 1';
                          pl2 = 'PL 2';
                        }

                        if (!switchValue) {
                          gamemode = 'VS BOT';
                          pl1 = 'You';
                          pl2 = 'BOT';
                        }
                        winX = 0;
                        winO = 0;
                        tied = 0;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          body: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                child: Text(
                  gamemode,
                  style: const TextStyle(color: Colors.white, fontSize: 40.0),
                ),
              ),
            ),
            Expanded(
                flex: 8,
                // Wrapped with a container so i can add the specific background color.
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFF3C2D76),
                  ),
                  child: GridView.builder(
                      padding: const EdgeInsets.all(15.0),
                      // ignore: prefer_const_constructors
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0),
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        // ignore: deprecated_member_use
                        return RaisedButton(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            listButton[index].str,
                            style: const TextStyle(shadows: <Shadow>[
                              Shadow(
                                offset: Offset(0.0, 0.0),
                                blurRadius: 30.0,
                                color: Color(0xFFE6C621),
                              ),
                              Shadow(
                                offset: Offset(0.0, 0.0),
                                blurRadius: 100.0,
                                color: Color(0xFFE6C621),
                              ),
                            ], color: Color(0xFFE6C621), fontSize: 75.0),
                          ),
                          color: listButton[index].clr,
                          disabledColor: Color(0xFF600CFF),
                          onPressed: () {
                            setState(() {
                              if (listButton[index].enabled) {
                                playGame(index);
                                CustomPaint(
                                  foregroundPainter: LinePainter(),
                                );
                              }
                            });
                          },
                        );
                      }),
                )),
            Expanded(
              flex: 5,
              // added padding to the buttom text so it'll be all clear and easy to read.
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      gamestr,
                      textAlign: TextAlign.start,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 40.0),
                    ),
                  ),
                  Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 50, right: 250.0),
                        child: Text(
                          'X',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Color(0xFFE6C621), fontSize: 40.0),
                        ),
                      ),
                      const Text(
                        'O',
                        textAlign: TextAlign.start,
                        style:
                            TextStyle(color: Color(0xFFE6C621), fontSize: 40.0),
                      ),
                    ],
                  ),
                  Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 50, right: 95),
                        child: Text(
                          '$pl1',
                          textAlign: TextAlign.start,
                          style:
                              TextStyle(color: Colors.white30, fontSize: 15.0),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25, right: 110),
                        child: Text(
                          'Tie',
                          textAlign: TextAlign.start,
                          style:
                              TextStyle(color: Colors.white30, fontSize: 15.0),
                        ),
                      ),
                      Text(
                        '$pl2',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.white30, fontSize: 15.0),
                      ),
                    ],
                  ),
                  Row(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 50, right: 100),
                        child: Text(
                          '$winX',
                          textAlign: TextAlign.start,
                          style: TextStyle(color: Colors.white, fontSize: 60.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 100),
                        child: Text(
                          '$tied',
                          textAlign: TextAlign.start,
                          style: TextStyle(color: Colors.white, fontSize: 60.0),
                        ),
                      ),
                      Text(
                        '$winO',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.white, fontSize: 60.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
