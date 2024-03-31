import 'package:flutter/material.dart';
import 'package:basic_timer_app/services/countdown_timer_service.dart';
import 'package:flutter/widgets.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

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
    int start = int.parse(_current);
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
      body: timer(),
    );
  }

  Center timer() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SleekCircularSlider(
          min: 0,
          max: 200,
          onChange: (double value) {
            _current = value.toInt().toString();
          },
          appearance: CircularSliderAppearance(
            startAngle: 270,
            angleRange: 360,
            size: 200,
            customWidths: CustomSliderWidths(progressBarWidth: 10, trackWidth: 10, handlerSize: 10),
            customColors: CustomSliderColors(
              progressBarColor: Colors.blue,
              trackColor: Colors.grey,
              dotColor: Colors.red,
            ),
          ),
          innerWidget: (double value) {
            return Center(
              child: GestureDetector(
          onTap: () {
            if(_timerService.isRunning()) {
              _timerService.cancel();
            }
            else {
              startTimer();
            }
          },
          child: Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$_current seconds',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
            );
          }
          )
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