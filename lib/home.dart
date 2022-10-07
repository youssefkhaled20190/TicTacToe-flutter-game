import 'package:flutter/material.dart';
import 'package:xogame/GameLogic.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String ActivePlayer = "x";
  bool GameOver = false;
  int Turn = 0;
  String Result = '';
  Game game = Game();
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
          child: MediaQuery.of(context).orientation == Orientation.portrait
              ? Column(
                  children: [
                    // ... => refare to return all the elemnts in the lst
                    ...firstblock(),
                    const SizedBox(
                      height: 30,
                    ),
                    //game logic///
                    _Exapanded(context),
                    ...LastBlock(),

                    /////end////
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...firstblock(),
                          SizedBox(
                            height: 40,
                          ),
                          ...LastBlock(),
                        ],
                      ),
                    ),
                    _Exapanded(context)
                  ],
                )),
    );
  }

  Expanded _Exapanded(BuildContext context) {
    return Expanded(
        child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            childAspectRatio: 1.0,
            children: List.generate(
                9,
                (index) => InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: GameOver ? null : () => _ontap(index),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Theme.of(context).shadowColor),
                        child: Center(
                            child: Text(
                          Player.playerX.contains(index)
                              ? 'x'
                              : Player.playerO.contains(index)
                                  ? 'o'
                                  : '',
                          style: TextStyle(
                              color: Player.playerX.contains(index)
                                  ? Colors.blue
                                  : Colors.pink,
                              fontSize: 50),
                        )),
                      ),
                    ))));
  }

  List<Widget> firstblock() {
    return [
      SwitchListTile.adaptive(
          title: const Text(
            "Switch player",
            style: TextStyle(color: Colors.white, fontSize: 28),
            textAlign: TextAlign.center,
          ),
          value: isSwitched,
          onChanged: (bool NewValue) {
            setState(() {
              isSwitched = NewValue;
            });
          }),
      Text(
        "it \'s  $ActivePlayer  turn".toUpperCase(),
        style: TextStyle(color: Colors.white, fontSize: 50),
        textAlign: TextAlign.center,
      ),
    ];
  }

  List<Widget> LastBlock() {
    return [
      Text(
        Result.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 28),
        textAlign: TextAlign.center,
      ),
      ElevatedButton.icon(
        onPressed: () {
          setState(() {
            Player.playerX = [];
            Player.playerO = [];
            ActivePlayer = "x";
            GameOver = false;
            Turn = 0;
            Result = '';
          });
        },
        icon: const Icon(Icons.repeat),
        label: const Text("PLAY AGAIN"),
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).splashColor)),
      )
    ];
  }

  _ontap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.PlayGame(index, ActivePlayer);
      upDate();
    }
    if (isSwitched == true && !GameOver && Turn != 9) {
      await game.AutoPlay(ActivePlayer);
      upDate();
    }
  }

  void upDate() {
    setState(() {
      ActivePlayer = (ActivePlayer == 'x') ? 'o' : 'x';
      Turn++;
      String winnerplayer = game.CheckTheWinner();
      if (winnerplayer != '') {
        Result = "$winnerplayer is the winner";
      } else if (!GameOver && Turn == 9) {
        Result = "no one win";
      }
    });
  }
}
