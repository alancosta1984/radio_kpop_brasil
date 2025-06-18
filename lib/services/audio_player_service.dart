import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audio_session/audio_session.dart';
import 'dart:async';
import 'metadata_service.dart';
import 'media_controls_service.dart';

class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  factory AudioPlayerService() => _instance;
  AudioPlayerService._internal();

  late AudioPlayer _player;
  late AudioSession _session;
  Timer? _metadataTimer;
  StreamSubscription? _metadataSubscription;
  
  String _currentTitle = 'Radio K-POP Brasil';
  String _currentArtist = 'Conectando...';
  String _listeners = '0';
  String _bitrate = '128';
  bool _isInitialized = false;
  
  // Stream controllers para notificar mudanças
  final StreamController<bool> _playingController = StreamController<bool>.broadcast();
  final StreamController<String> _titleController = StreamController<String>.broadcast();
  final StreamController<String> _artistController = StreamController<String>.broadcast();
  final StreamController<Map<String, String>> _metadataController = StreamController<Map<String, String>>.broadcast();
  
  Stream<bool> get playingStream => _playingController.stream;
  Stream<String> get titleStream => _titleController.stream;
  Stream<String> get artistStream => _artistController.stream;
  Stream<Map<String, String>> get metadataStream => _metadataController.stream;
  
  bool get isPlaying => _player.playing;
  String get currentTitle => _currentTitle;
  String get currentArtist => _currentArtist;
  String get listeners => _listeners;
  String get bitrate => _bitrate;
  
  static const String streamUrl = 'https://server.dacsolution.com.br/shoutcast3/listen.mp3';

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
            artUri: Uri.parse('asset:///assets/icon/app_icon.png'),
          ),
        ),
      );
      
      // Escutar mudanças no estado de reprodução
      _player.playingStream.listen((playing) {
        _playingController.add(playing);
        MediaControlsService.setPlaybackState(playing);
      });
      
      // Configurar controles de mídia
      await MediaControlsService.setupMediaControls();
      
      _isInitialized = true;
      
      // Iniciar monitoramento de metadados
      _startMetadataMonitoring();
      
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
      // Tentar reconectar em caso de erro
      await _reconnect();
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
      _stopMetadataMonitoring();
    } catch (e) {
      print('Erro ao parar: $e');
    }
  }

  Future<void> _reconnect() async {
    try {
      await _player.stop();
      await Future.delayed(const Duration(seconds: 2));
      
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.parse(streamUrl),
          tag: MediaItem(
            id: 'radio_kpop_brasil',
            album: 'Radio K-POP Brasil',
            title: _currentTitle,
            artist: _currentArtist,
            artUri: Uri.parse('asset:///assets/icon/app_icon.png'),
          ),
        ),
      );
      
      await _player.play();
    } catch (e) {
      print('Erro ao reconectar: $e');
    }
  }

  void _startMetadataMonitoring() {
    // Buscar metadados imediatamente
    _fetchAndUpdateMetadata();
    
    // Configurar stream de metadados
    _metadataSubscription = MetadataService.getMetadataStream().listen(
      (metadata) {
        _updateMetadata(metadata);
      },
      onError: (error) {
        print('Erro no stream de metadados: $error');
      },
    );
  }

  void _stopMetadataMonitoring() {
    _metadataSubscription?.cancel();
    _metadataSubscription = null;
  }

  Future<void> _fetchAndUpdateMetadata() async {
    try {
      final metadata = await MetadataService.fetchCurrentSong();
      _updateMetadata(metadata);
    } catch (e) {
      print('Erro ao buscar metadados iniciais: $e');
    }
  }

  void _updateMetadata(Map<String, String> metadata) {
    final newTitle = metadata['title'] ?? 'Radio K-POP Brasil';
    final newArtist = metadata['artist'] ?? 'Ao Vivo';
    final newListeners = metadata['listeners'] ?? '0';
    final newBitrate = metadata['bitrate'] ?? '128';
    
    bool hasChanges = false;
    
    if (_currentTitle != newTitle) {
      _currentTitle = newTitle;
      _titleController.add(_currentTitle);
      hasChanges = true;
    }
    
    if (_currentArtist != newArtist) {
      _currentArtist = newArtist;
      _artistController.add(_currentArtist);
      hasChanges = true;
    }
    
    if (_listeners != newListeners) {
      _listeners = newListeners;
      hasChanges = true;
    }
    
    if (_bitrate != newBitrate) {
      _bitrate = newBitrate;
      hasChanges = true;
    }
    
    if (hasChanges) {
      // Notificar mudanças nos metadados
      _metadataController.add({
        'title': _currentTitle,
        'artist': _currentArtist,
        'listeners': _listeners,
        'bitrate': _bitrate,
      });
      
      // Atualizar controles de mídia do sistema
      MediaControlsService.updateMetadata(
        title: _currentTitle,
        artist: _currentArtist,
        isPlaying: _player.playing,
      );
      
      // Atualizar metadados do player
      _updatePlayerMetadata();
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
            artUri: Uri.parse('asset:///assets/icon/app_icon.png'),
          ),
        ),
      );
    } catch (e) {
      print('Erro ao atualizar metadados do player: $e');
    }
  }

  void dispose() {
    _stopMetadataMonitoring();
    _player.dispose();
    _playingController.close();
    _titleController.close();
    _artistController.close();
    _metadataController.close();
  }
}

