import 'package:flutter/material.dart';
import '../services/audio_player_service.dart';

class RadioProvider extends ChangeNotifier {
  final AudioPlayerService _audioService = AudioPlayerService();
  
  bool _isPlaying = false;
  String _currentTitle = 'Radio K-POP Brasil';
  String _currentArtist = 'Conectando...';
  bool _isLoading = false;
  
  bool get isPlaying => _isPlaying;
  String get currentTitle => _currentTitle;
  String get currentArtist => _currentArtist;
  bool get isLoading => _isLoading;
  
  RadioProvider() {
    _initializeListeners();
  }
  
  void _initializeListeners() {
    _audioService.playingStream.listen((playing) {
      _isPlaying = playing;
      _isLoading = false;
      notifyListeners();
    });
    
    _audioService.titleStream.listen((title) {
      _currentTitle = title;
      notifyListeners();
    });
    
    _audioService.artistStream.listen((artist) {
      _currentArtist = artist;
      notifyListeners();
    });
  }
  
  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await pause();
    } else {
      await play();
    }
  }
  
  Future<void> play() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _audioService.play();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Erro ao reproduzir: $e');
    }
  }
  
  Future<void> pause() async {
    try {
      await _audioService.pause();
    } catch (e) {
      print('Erro ao pausar: $e');
    }
  }
  
  Future<void> stop() async {
    try {
      await _audioService.stop();
    } catch (e) {
      print('Erro ao parar: $e');
    }
  }
  
  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}

