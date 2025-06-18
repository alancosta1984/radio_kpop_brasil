import 'package:flutter/services.dart';

class MediaControlsService {
  static const MethodChannel _channel = MethodChannel('radio_kpop_brasil/media_controls');
  
  static Future<void> setupMediaControls() async {
    try {
      await _channel.invokeMethod('setupMediaControls');
    } catch (e) {
      print('Erro ao configurar controles de mídia: $e');
    }
  }
  
  static Future<void> updateMetadata({
    required String title,
    required String artist,
    required bool isPlaying,
  }) async {
    try {
      await _channel.invokeMethod('updateMetadata', {
        'title': title,
        'artist': artist,
        'isPlaying': isPlaying,
      });
    } catch (e) {
      print('Erro ao atualizar metadados: $e');
    }
  }
  
  static Future<void> setPlaybackState(bool isPlaying) async {
    try {
      await _channel.invokeMethod('setPlaybackState', {
        'isPlaying': isPlaying,
      });
    } catch (e) {
      print('Erro ao definir estado de reprodução: $e');
    }
  }
}

