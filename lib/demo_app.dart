import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_wake/flutter_screen_wake.dart';

class DemoApp extends StatefulWidget {
  DemoApp({Key? key}) : super(key: key);

  @override
  _DemoAppState createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  double brightness = 0.0;
  bool toggle = false;

  @override
  void initState() {
    super.initState();
    initPlatformBrightness();
  }

  Future<void> initPlatformBrightness() async {
    double bright;
    try {
      bright = await FlutterScreenWake.brightness;
    } on PlatformException {
      bright = 1.0;
    }
    if (!mounted) return;

    setState(() {
      brightness = bright;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo App'),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black26),
              boxShadow: const [
                BoxShadow(color: Colors.black26, spreadRadius: 2, blurRadius: 2)
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  AnimatedCrossFade(
                      firstChild: const Icon(
                        Icons.brightness_7,
                        size: 50,
                      ),
                      secondChild: const Icon(
                        Icons.brightness_3,
                        size: 50,
                      ),
                      crossFadeState: toggle
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(seconds: 1)),
                  Expanded(
                      child: Slider(
                          value: brightness,
                          onChanged: (value) {
                            setState(() {
                              brightness = value;
                            });
                            FlutterScreenWake.setBrightness(brightness);
                            if (brightness == 0) {
                              toggle = true;
                            } else {
                              toggle = false;
                            }
                          }))
                ],
              ),
              const Text('Slide to Adjust the brightness')
            ],
          ),
        ),
      ),
    );
  }
}
