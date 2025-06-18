import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audio_session/audio_session.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  factory AudioPlayerService() => _instance;
  AudioPlayerService._internal();

  late AudioPlayer _player;
  late AudioSession _session;
  Timer? _metadataTimer;
  
  String _currentTitle = 'Radio K-POP Brasil';
  String _currentArtist = 'Conectando...';
  bool _isInitialized = false;
  
  // Stream controllers para notificar mudanças
  final StreamController<bool> _playingController = StreamController<bool>.broadcast();
  final StreamController<String> _titleController = StreamController<String>.broadcast();
  final StreamController<String> _artistController = StreamController<String>.broadcast();
  
  Stream<bool> get playingStream => _playingController.stream;
  Stream<String> get titleStream => _titleController.stream;
  Stream<String> get artistStream => _artistController.stream;
  
  bool get isPlaying => _player.playing;
  String get currentTitle => _currentTitle;
  String get currentArtist => _currentArtist;
  
  static const String streamUrl = 'https://server.dacsolution.com.br/shoutcast3/listen.mp3';
  static const String metadataUrl = 'http://server.dacsolution.com.br:9910';

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Configurar sessão de áudio
      _session = await AudioSession.instance;
      await _session.configure(const AudioSessionConfiguration.music());
      
      // Inicializar player
      _player = AudioPlayer();
      
      // Configurar fonte de áudio
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(streamUrl),
          tag: MediaItem(
            id: 'radio_kpop_brasil',
            album: 'Radio K-POP Brasil',
            title: _currentTitle,
            artist: _currentArtist,
            artUri: Uri.parse('https://example.com/radio_icon.png'), // Será substituído por ícone real
          ),
        ),
      );
      
      // Escutar mudanças no estado de reprodução
      _player.playingStream.listen((playing) {
        _playingController.add(playing);
      });
      
      _isInitialized = true;
      
      // Iniciar timer para buscar metadados
      _startMetadataTimer();
      
    } catch (e) {
      print('Erro ao inicializar player: $e');
    }
  }

  Future<void> play() async {
    if (!_isInitialized) await initialize();
    
    try {
      await _player.play();
    } catch (e) {
      print('Erro ao reproduzir: $e');
    }
  }

  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (e) {
      print('Erro ao pausar: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
      _stopMetadataTimer();
    } catch (e) {
      print('Erro ao parar: $e');
    }
  }

  void _startMetadataTimer() {
    _metadataTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _fetchMetadata();
    });
    // Buscar metadados imediatamente
    _fetchMetadata();
  }

  void _stopMetadataTimer() {
    _metadataTimer?.cancel();
    _metadataTimer = null;
  }

  Future<void> _fetchMetadata() async {
    try {
      final response = await http.get(
        Uri.parse('$metadataUrl/stats?sid=1&json=1'),
        headers: {'User-Agent': 'RadioKPOPBrasil/1.0'},
      ).timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final songTitle = data['songtitle'] ?? 'Radio K-POP Brasil';
        
        // Tentar separar artista e música
        String title = 'Radio K-POP Brasil';
        String artist = 'Ao Vivo';
        
        if (songTitle.isNotEmpty && songTitle != 'Radio K-POP Brasil') {
          if (songTitle.contains(' - ')) {
            final parts = songTitle.split(' - ');
            if (parts.length >= 2) {
              artist = parts[0].trim();
              title = parts[1].trim();
            } else {
              title = songTitle;
            }
          } else {
            title = songTitle;
          }
        }
        
        if (_currentTitle != title || _currentArtist != artist) {
          _currentTitle = title;
          _currentArtist = artist;
          
          _titleController.add(_currentTitle);
          _artistController.add(_currentArtist);
          
          // Atualizar metadados do player
          await _updatePlayerMetadata();
        }
      }
    } catch (e) {
      print('Erro ao buscar metadados: $e');
    }
  }

  Future<void> _updatePlayerMetadata() async {
    try {
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(streamUrl),
          tag: MediaItem(
            id: 'radio_kpop_brasil',
            album: 'Radio K-POP Brasil',
            title: _currentTitle,
            artist: _currentArtist,
            artUri: Uri.parse('https://example.com/radio_icon.png'),
          ),
        ),
      );
    } catch (e) {
      print('Erro ao atualizar metadados: $e');
    }
  }

  void dispose() {
    _stopMetadataTimer();
    _player.dispose();
    _playingController.close();
    _titleController.close();
    _artistController.close();
  }
}

