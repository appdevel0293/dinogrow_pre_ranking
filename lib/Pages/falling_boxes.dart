import 'package:dinogrow/Flame/buttons.dart';
import 'package:dinogrow/Flame/objects/box.dart';
import 'package:dinogrow/Flame/objects/dino.dart';
import 'package:dinogrow/Flame/objects/floor.dart';
import 'package:flame/palette.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flame/timer.dart' as timer_flame;

class FallingBoxes extends Forge2DGame with TapDetector {
  final void Function(String) endGameCallback;

  // setup the game camera to match the device size
  FallingBoxes(this.endGameCallback)
      : super(zoom: 100, gravity: Vector2(0, 15));

  //get the dino object and sprite animation
  final dino = Dino();

  //set initial state of the game buttons
  bool isJumpPressed = false;
  bool isLeftPressed = false;
  bool isRightPressed = false;
  bool isAttackPressed = false;

  //Timer callbacks
  timer_flame.Timer timer = timer_flame.Timer(0);

  //set initial score
  int score = 0;
  late TextComponent scoreText;

  // get the buttons
  final btnLeft = VirtualPadButtons().vpadbuttons()[0];
  final btnRight = VirtualPadButtons().vpadbuttons()[1];
  final btnJump = VirtualPadButtons().vpadbuttons()[2];
  final btnAttack = VirtualPadButtons().vpadbuttons()[3];
  final btnJumpText = VirtualPadButtons().vpadbuttons()[4];
  final btnAttackText = VirtualPadButtons().vpadbuttons()[5];

  // check and verify if the button is pressed
  bool isInsideButton(Vector2 tapPosition, RectangleComponent button) {
    final buttonRect = button.toRect();
    return buttonRect.contains(tapPosition.toOffset());
  }

  @override
  bool onTapDown(TapDownInfo info) {
    final tapPosition = info.eventPosition.game;

    if (isInsideButton(tapPosition, btnLeft)) {
      isLeftPressed = true;
    }
    if (isInsideButton(tapPosition, btnRight)) {
      isRightPressed = true;
    }
    if (isInsideButton(tapPosition, btnJump)) {
      isJumpPressed = true;
    }
    if (isInsideButton(tapPosition, btnAttack)) {
      isAttackPressed = true;
    }

    if (isLeftPressed) {
      btnLeft.paint.color = const Color.fromARGB(255, 91, 92, 91);
      isRightPressed = false;
      btnRight.paint.color = BasicPalette.transparent.color;

      dino.walkLeft();

      timer =
          timer_flame.Timer(0.25, onTick: () => dino.walkLeft(), repeat: true);
    }
    if (isRightPressed) {
      btnRight.paint.color = const Color.fromARGB(255, 91, 92, 91);
      isLeftPressed = false;
      btnLeft.paint.color = BasicPalette.transparent.color;

      dino.walkRight();

      timer =
          timer_flame.Timer(0.25, onTick: () => dino.walkRight(), repeat: true);
    }

    return true;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    if (isLeftPressed) {
      isLeftPressed = false;
      btnLeft.paint.color = BasicPalette.transparent.color;
    }
    if (isRightPressed) {
      isRightPressed = false;
      btnRight.paint.color = BasicPalette.transparent.color;
    }

    timer.stop();

    return true;
  }

  @override
  Future<void> onLoad() async {
    final screenSize = Vector2(size.x, size.y);
    // Scaled viewport size
    final worldSize = screenSize;

    await super.onLoad();

    final camera =
        CameraComponent.withFixedResolution(width: size.x, height: size.y);
    final background = _Background(size: screenSize);
    camera.viewport.add(background);
    if (dino.isLoaded) {
      camera.follow(dino.currentComponent, verticalOnly: true);
    }

    add(Floor(worldSize));
    add(LeftWall(worldSize));
    add(RightWall(worldSize));

    finishGame() {
      endGameCallback('$score');
    }

    newBoxAndScore() async {
      score += 1;
      scoreText.text = 'Score: ${score.toString().padLeft(3, '0')}';

      await Future.delayed(const Duration(milliseconds: 1000), () {
        add(Box(newBoxAndScore, finishGame, worldSize));
      });
    }

    await Future.delayed(const Duration(milliseconds: 1000), () {
      add(Box(newBoxAndScore, finishGame, worldSize));
    });

    // Render floor
    final boxFloor1 = BoxFloor()
      ..x = 1
      ..y = worldSize.y - 1;
    await boxFloor1.loadImage();
    add(boxFloor1);

    final boxFloor2 = BoxFloor()
      ..x = 2
      ..y = worldSize.y - 1;
    await boxFloor2.loadImage();
    add(boxFloor2);

    final leftFloor = LeftFloor()
      ..x = 0
      ..y = worldSize.y - 1;
    await leftFloor.loadImage();
    add(leftFloor);

    final rightFloor = RightFloor()
      ..x = 3
      ..y = worldSize.y - 1;
    await rightFloor.loadImage();
    add(rightFloor);

    // add the player to the game
    add(dino);

    // add the buttons to the game
    btnLeft.position = Vector2(0, worldSize.y - 1);
    btnRight.position = Vector2(3, worldSize.y - 1);
    add(btnLeft);
    add(btnRight);

    // Score text
    final btnStyleLetters = TextPaint(
        style: const TextStyle(
      fontSize: 0.2,
      color: Colors.white,
      fontFamily: 'ComicNeue Bold',
    ));

    scoreText = TextComponent(
      text: 'Score: 000',
      anchor: Anchor.center,
      position: Vector2(worldSize.x / 2, 1),
      textRenderer: btnStyleLetters,
    );

    add(scoreText);
  }

  @override
  Color backgroundColor() => const Color(0x00077777);

  @override
  void update(double dt) {
    super.update(dt);
    timer.update(dt);
  }
}

class _Background extends PositionComponent {
  _Background({super.size});
  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y),
        Paint()..color = const Color.fromARGB(255, 56, 53, 53));
  }
}

class GameWidgetFallingBoxes extends StatefulWidget {
  const GameWidgetFallingBoxes({super.key});

  @override
  State<GameWidgetFallingBoxes> createState() => _GameWidgetDownState();
}

class _GameWidgetDownState extends State<GameWidgetFallingBoxes> {
  FallingBoxes game = FallingBoxes((String data) {});
  bool loading = true;
  bool paused = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      game = FallingBoxes(showEndMessage);
    });

    Future.delayed(const Duration(milliseconds: 500), showWelcome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/home');
          },
        ),
        actions: [
          IconButton(
            iconSize: 42,
            icon: Icon(paused ? Icons.play_circle : Icons.pause_circle),
            onPressed: () {
              setState(() {
                game.paused = !game.paused;
                paused = !paused;
              });
            },
          )
        ],
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/map_1.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
          child: loading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                )
              : GameWidget(game: game)),
    );
  }

  showWelcome() {
    setState(() {
      loading = true;
    });
    showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Welcome to Down'),
        content: const Text(
            "The goal for this minigame is to avoid the boxes coming from above. The more boxes you avoid, the greater your score!\n\nWatch out for the boxes! \n\nREMEMBER: You can save your score on the blockchain but you'll need at least 0.5 SOL in your wallet balance"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              GoRouter.of(context).go('/home');
            },
            child: const Text('Go back'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                loading = false;
                game = FallingBoxes(showEndMessage);
                game.paused = true;

                Future.delayed(const Duration(seconds: 1), () {
                  game.paused = false;
                  paused = false;
                });
              });
            },
            child: const Text("Let's go!"),
          ),
        ],
      ),
    );
  }

  showEndMessage(String score) {
    game.paused = true;

    showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Oops ... game over :('),
        content: Text(
            "Thanks for playing! Congrats you score was: $score \n\nDo you want to save and share it in Ranking?."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showWelcome();
            },
            child: const Text('Try again'),
          ),
          TextButton(
            onPressed: () {
              //Implement SaveScore here
              GoRouter.of(context).go('/home');
            },
            child: const Text("Send my score"),
          ),
        ],
      ),
    );
  }
}
