import 'package:flutter/material.dart';
import 'package:basic_timer_app/services/countdown_timer_service.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CountdownTimerService _timerService = CountdownTimerService();
  String _current = '';
  final TextEditingController _controller = TextEditingController();

  void startTimer() {
    int start = int.parse(_controller.text);
    _timerService.start(start, (int current) {
      setState(() {
        _current = current.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter time in seconds',
          ),
        ),
        GestureDetector(
          onTap: () {
            if(_timerService.isRunning()) {
              _timerService.cancel();
            }
            else {
              startTimer();
            }
          },
          child: Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 38, 151, 226),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'Timer: $_current',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text('Basic Timer App'),
      centerTitle: true,
    );
  }

  @override
  void dispose() {
    _timerService.cancel();
    super.dispose();
  }
}