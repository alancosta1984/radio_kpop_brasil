import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

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
  final player = AudioPlayer();
  bool isPlaying = false;

  final String streamUrl = 'https://server.dacsolution.com.br/shoutcast3/listen.mp3';

  @override
  void initState() {
    super.initState();
    setupPlayer();
  }

  Future<void> setupPlayer() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    await player.setUrl(streamUrl);
  }

  void togglePlayPause() {
    if (isPlaying) {
      player.pause();
    } else {
      player.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void dispose() {
    player.dispose();
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
