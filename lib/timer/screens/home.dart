import 'package:flutter/material.dart';

import 'package:basic_timer_app/utils.dart';
import 'package:basic_timer_app/timer/widgets/interactive_timer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#FDFDF4'),
      body: const InteractiveTimer(),
    );
  }
  }



