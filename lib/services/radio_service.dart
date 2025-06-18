import 'package:flutter/material.dart';

class RadioService {
  static const String streamUrl = 'https://server.dacsolution.com.br/shoutcast3/listen.mp3';
  static const String metadataUrl = 'http://server.dacsolution.com.br:9910';
  
  // Singleton pattern
  static final RadioService _instance = RadioService._internal();
  factory RadioService() => _instance;
  RadioService._internal();
  
  bool _isPlaying = false;
  String _currentSong = 'Radio K-POP Brasil';
  String _currentArtist = 'Conectando...';
  
  bool get isPlaying => _isPlaying;
  String get currentSong => _currentSong;
  String get currentArtist => _currentArtist;
  
  void play() {
    _isPlaying = true;
    // Implementação do play será adicionada
  }
  
  void pause() {
    _isPlaying = false;
    // Implementação do pause será adicionada
  }
  
  void stop() {
    _isPlaying = false;
    // Implementação do stop será adicionada
  }
  
  void updateMetadata(String song, String artist) {
    _currentSong = song;
    _currentArtist = artist;
  }
}

