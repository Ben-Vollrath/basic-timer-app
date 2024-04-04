import 'package:flutter/material.dart';

import '../utils.dart';

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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size),
        border: Border.all(
          color: HexColor('#1A2123').withOpacity(0.9), 
          width: 3
        ),
      ),
      child: ClipRRect(
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
      ),
    );
  }
}