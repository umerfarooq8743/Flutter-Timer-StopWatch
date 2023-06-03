import 'dart:async';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with TickerProviderStateMixin {
  late TabController tb;
  int hour = 0;
  int min = 0;
  int sec = 0;
  String timeToDisplay = "";
  bool started = true;
  bool stopped = true;
  bool CancelTimer = true;
  int? timeForTimer;
  final dur = const Duration(seconds: 1);
  @override
  void initState() {
    tb = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  void start() {
    setState(() {
      started = false;
      stopped = false;
    });
    timeForTimer = ((hour * 3600) + (min * 60) + sec);
    debugPrint(timeForTimer.toString());
    Timer.periodic(dur, (Timer t) {
      setState(() {
        if (timeForTimer! < 1 || CancelTimer == false) {
          t.cancel();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TimerPage(),
              ));
        } else if (timeForTimer! < 60) {
          timeToDisplay = timeForTimer.toString();
          timeForTimer = timeForTimer! - 1;
        } else if (timeForTimer! < 3600) {
          int m = timeForTimer! ~/ 60;
          int s = timeForTimer! - (60 * m);
          timeToDisplay = m.toString() + ":" + s.toString();
          timeForTimer = timeForTimer! - 1;
        } else {
          int h = timeForTimer! ~/ 3600;
          int t = timeForTimer! - (3600 * h);
          int m = t ~/ 60;
          int s = t - (60 * m);
          timeToDisplay =
              h.toString() + ":" + m.toString() + ":" + s.toString();
          timeForTimer = timeForTimer! - 1;
        }
      });
    });
  }

  void stop() {
    setState(() {
      started = true;
      stopped = true;
      CancelTimer = false;
    });
    // timeToDisplay = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          "Watch !",
          style: TextStyle(
              fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: TabBar(
            tabs: [
              Text(
                "Timer",
              ),
              Text("StopWatch"),
            ],
            labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            labelPadding: EdgeInsets.only(bottom: 10),
            unselectedLabelColor: Colors.white70,
            controller: tb),
      ),
      body: TabBarView(children: [
        timer(),
        stopwatch(),
      ], controller: tb),
    );
  }

  bool startIsPressed = true;
  bool stopIsPressed = true;
  bool resetIsPressed = true;
  String stopTimeToDisplay = "00:00:00";
  var Swatch = Stopwatch();
  void startTimer() {
    Timer(dur, keeprunning);
  }

  void keeprunning() {
    if (Swatch.isRunning) {
      startTimer();
    }
    setState(() {
      stopTimeToDisplay = Swatch.elapsed.inHours.toString().padLeft(2, "0") +
          ":" +
          (Swatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
          ":" +
          (Swatch.elapsed.inSeconds % 60).toString().padLeft(2, "0");
    });
  }

  void startStopwatch() {
    setState(() {
      stopIsPressed = false;
      startIsPressed = false;
    });
    Swatch.start();
    startTimer();
  }

  void stopStopwatch() {
    setState(() {
      stopIsPressed = true;
      resetIsPressed = false;
    });
    Swatch.stop();
  }

  void resetStopwatch() {
    setState(() {
      stopIsPressed = true;
      resetIsPressed = true;
      startIsPressed = true;
    });
    Swatch.reset();
    stopTimeToDisplay = "00:00:00";
  }

  Widget stopwatch() {
    return Container(
      child: Column(
        children: [
          Expanded(
              flex: 6,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "$stopTimeToDisplay",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.w700),
                ),
              )),
          Expanded(
              flex: 4,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          onPressed: stopIsPressed ? null : stopStopwatch,
                          color: Colors.red,
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          child: Text(
                            "Stop",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                        MaterialButton(
                          onPressed: resetIsPressed ? null : resetStopwatch,
                          color: Colors.teal,
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          child: Text(
                            "Reset",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    MaterialButton(
                      onPressed: startIsPressed ? startStopwatch : null,
                      color: Colors.green,
                      padding: EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 15,
                      ),
                      child: Text(
                        "Start",
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget timer() {
    return Container(
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        "HH",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    NumberPicker(
                        value: hour,
                        //initialValue: hour,
                        minValue: 0,
                        maxValue: 23,
                        itemWidth: 70,
                        onChanged: (val) {
                          setState(() {
                            hour = val;
                          });
                        }),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "MM",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        )),
                    NumberPicker(
                        value: min,
                        //initialValue: hour,
                        minValue: 0,
                        maxValue: 23,
                        itemWidth: 70,
                        onChanged: (val) {
                          setState(() {
                            min = val;
                          });
                        }),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text("SS",
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                    NumberPicker(
                        value: sec,
                        //initialValue: hour,
                        minValue: 0,
                        itemWidth: 70,
                        maxValue: 23,
                        onChanged: (val) {
                          setState(() {
                            sec = val;
                          });
                        }),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "$timeToDisplay",
              style: TextStyle(
                  fontSize: 40,
                  color: Color.fromARGB(255, 238, 150, 17),
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: started ? start : null,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 35),
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    "Start",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ),
                MaterialButton(
                  onPressed: stopped ? null : stop,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 35),
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    "Stop",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
