import 'package:flutter/material.dart';

class DiceImage extends StatelessWidget {
  const DiceImage({
    Key key,
    @required this.f,
  }) : super(key: key);

  final int f;

  @override
  Widget build(BuildContext context) {
    if (f == 7)
      return Container(
        height: 80.0,
        width: 80.0,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/dice_roll2.gif'),
            fit: BoxFit.fill,
          ),
        ),
      );
    else
      return Container(
        height: 80.0,
        width: 80.0,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/dice$f.png'),
            fit: BoxFit.fill,
          ),
        ),
      );
  }
}
