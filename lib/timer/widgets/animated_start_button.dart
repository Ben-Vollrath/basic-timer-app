import 'package:flutter/material.dart';
import 'package:basic_timer_app/utils.dart';


class AnimatedStartButton extends StatefulWidget {
  bool buttonClicked = false;

  AnimatedStartButton({
    super.key,
  });

  @override
  _AnimatedStartButtonState createState() => _AnimatedStartButtonState();
}

class _AnimatedStartButtonState extends State<AnimatedStartButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() {
        setState(() {
          widget.buttonClicked = !widget.buttonClicked;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: widget.buttonClicked ? 30.0 : 180.0,
        height: widget.buttonClicked ? 30.0 : 70.0,
        decoration: BoxDecoration(
          color: HexColor('#F6A881'),
          borderRadius: widget.buttonClicked ? BorderRadius.circular(35) : BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            widget.buttonClicked ? '' : 'Start',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
