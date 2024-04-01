import 'package:flutter/material.dart';

class FillingContainer extends StatelessWidget {
  final double progress;
  final double size;
  final Color backgroundColor;
  final Color progressColor;
  final Widget child;

  const FillingContainer(
      {Key? key,
      required this.progress,
      required this.size,
      required this.backgroundColor,
      required this.progressColor,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size),
      child: SizedBox(
        height: size,
        width: size,
        child: Stack(          
          children: [
          Container(
            color: backgroundColor,
            child: child,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: size * progress > 0 ? size * progress : 0,
              color: progressColor,
            ),
          )
        ]),
      ),
    );
  }
}