import 'package:flutter/material.dart';
import 'package:audio_experiments/voice_text.dart';
void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VoiceTextHome(),
    );
  }
}
