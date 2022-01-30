import 'package:flutter/material.dart';
import '../widgets/cat.dart';
import 'dart:math';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  late Animation<double> catAnimation;
  late AnimationController catController;
  late Animation<double> boxAnimation;
  late AnimationController boxController;

  initState() {
    super.initState();

    boxController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    boxAnimation = Tween(begin: pi * 0.6, end: pi * 0.65).animate(
        CurvedAnimation(parent: boxController, curve: Curves.easeInOut));

    catController =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);

    catAnimation = Tween(begin: -35.0, end: -80.0)
        .animate(CurvedAnimation(parent: catController, curve: Curves.easeIn));

    boxController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        boxController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        boxController.forward();
      }
    });

    boxController.forward();
  }

  void onTap() {
    if (catController.status == AnimationStatus.completed) {
      boxController.forward();
      catController.reverse();
    } else if (catController.status == AnimationStatus.dismissed) {
      catController.forward();
      boxController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Animation'),
        ),
        body: GestureDetector(
          child: Center(
              child: Stack(
            children: [
              buildCatAnimation(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap()
            ],
            clipBehavior: Clip.none,
          )),
          onTap: onTap,
        ));
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
            child: child!, top: catAnimation.value, right: 0.0, left: 0.0);
      },
      child: Cat(),
    );
  }

  Widget buildBox() {
    return Container(
      width: 200.0,
      height: 200.0,
      color: Colors.brown,
    );
  }

  Widget buildLeftFlap() {
    return AnimatedBuilder(
        animation: boxAnimation,
        builder: (context, child) {
          return Positioned(
            left: 3,
            child: Transform.rotate(
                child: child,
                angle: boxAnimation.value,
                alignment: Alignment.topLeft),
          );
        },
        child: Container(
          width: 125.0,
          height: 10.0,
          color: Colors.brown,
        ));
  }

  Widget buildRightFlap() {
    return AnimatedBuilder(
        animation: boxAnimation,
        builder: (context, child) {
          return Positioned(
            right: 3,
            child: Transform.rotate(
                child: child,
                angle: -boxAnimation.value,
                alignment: Alignment.topRight),
          );
        },
        child: Container(
          width: 125.0,
          height: 10.0,
          color: Colors.brown,
        ));
  }
}
