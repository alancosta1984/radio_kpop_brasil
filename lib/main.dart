import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const RadioApp());
}

class RadioApp extends StatelessWidget {
  const RadioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radio K-POP Brasil',
      theme: ThemeData.dark(),
      home: const RadioHomePage(),
    );
  }
}

class RadioHomePage extends StatefulWidget {
  const RadioHomePage({super.key});

  @override
  State<RadioHomePage> createState() => _RadioHomePageState();
}

class _RadioHomePageState extends State<RadioHomePage> {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;

  final String streamUrl = 'https://server.dacsolution.com.br/shoutcast3/listen.mp3';

  void togglePlayPause() async {
    if (isPlaying) {
      await _player.pause();
    } else {
      await _player.play(UrlSource(streamUrl));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Radio K-POP Brasil')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 150),
            const SizedBox(height: 40),
            IconButton(
              iconSize: 80,
              icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
              onPressed: togglePlayPause,
            ),
            const SizedBox(height: 20),
            const Text('Clique para ouvir ao vivo'),
          ],
        ),
      ),
    );
  }
}
