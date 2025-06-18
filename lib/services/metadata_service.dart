import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class MetadataService {
  static const String metadataUrl = 'http://server.dacsolution.com.br:9910';
  
  static Future<Map<String, String>> fetchCurrentSong() async {
    try {
      final response = await http.get(
        Uri.parse('$metadataUrl/stats?sid=1&json=1'),
        headers: {
          'User-Agent': 'RadioKPOPBrasil/1.0',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 8));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseMetadata(data);
      } else {
        print('Erro HTTP: ${response.statusCode}');
        return _getDefaultMetadata();
      }
    } catch (e) {
      print('Erro ao buscar metadados: $e');
      return _getDefaultMetadata();
    }
  }
  
  static Map<String, String> _parseMetadata(Map<String, dynamic> data) {
    String title = 'Radio K-POP Brasil';
    String artist = 'Ao Vivo';
    
    try {
      final songTitle = data['songtitle']?.toString() ?? '';
      final serverTitle = data['servertitle']?.toString() ?? '';
      final streamTitle = data['streamtitle']?.toString() ?? '';
      
      // Priorizar diferentes fontes de metadados
      String rawTitle = songTitle.isNotEmpty ? songTitle : 
                       streamTitle.isNotEmpty ? streamTitle : 
                       serverTitle;
      
      if (rawTitle.isNotEmpty && rawTitle != 'Radio K-POP Brasil') {
        // Tentar diferentes formatos de separação
        if (rawTitle.contains(' - ')) {
          final parts = rawTitle.split(' - ');
          if (parts.length >= 2) {
            artist = parts[0].trim();
            title = parts.sublist(1).join(' - ').trim();
          } else {
            title = rawTitle.trim();
          }
        } else if (rawTitle.contains(' by ')) {
          final parts = rawTitle.split(' by ');
          if (parts.length >= 2) {
            title = parts[0].trim();
            artist = parts[1].trim();
          } else {
            title = rawTitle.trim();
          }
        } else if (rawTitle.contains('|')) {
          final parts = rawTitle.split('|');
          if (parts.length >= 2) {
            artist = parts[0].trim();
            title = parts[1].trim();
          } else {
            title = rawTitle.trim();
          }
        } else {
          title = rawTitle.trim();
        }
      }
      
      // Limpar caracteres especiais e validar
      title = _cleanString(title);
      artist = _cleanString(artist);
      
      // Validações finais
      if (title.isEmpty || title.length < 2) {
        title = 'Radio K-POP Brasil';
      }
      if (artist.isEmpty || artist.length < 2) {
        artist = 'Ao Vivo';
      }
      
    } catch (e) {
      print('Erro ao processar metadados: $e');
      return _getDefaultMetadata();
    }
    
    return {
      'title': title,
      'artist': artist,
      'listeners': data['currentlisteners']?.toString() ?? '0',
      'maxListeners': data['maxlisteners']?.toString() ?? '0',
      'bitrate': data['bitrate']?.toString() ?? '128',
    };
  }
  
  static String _cleanString(String input) {
    return input
        .replaceAll(RegExp(r'[^\w\s\-\(\)\[\]가-힣]'), '') // Manter caracteres coreanos
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
  
  static Map<String, String> _getDefaultMetadata() {
    return {
      'title': 'Radio K-POP Brasil',
      'artist': 'Conectando...',
      'listeners': '0',
      'maxListeners': '0',
      'bitrate': '128',
    };
  }
  
  // Método para buscar metadados de forma contínua
  static Stream<Map<String, String>> getMetadataStream() {
    return Stream.periodic(
      const Duration(seconds: 15),
      (_) => fetchCurrentSong(),
    ).asyncMap((future) => future);
  }
  
  // Método para verificar se o servidor está online
  static Future<bool> isServerOnline() async {
    try {
      final response = await http.head(
        Uri.parse(metadataUrl),
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

