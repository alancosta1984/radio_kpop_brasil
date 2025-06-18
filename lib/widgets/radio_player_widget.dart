import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/radio_provider.dart';

class RadioPlayerWidget extends StatelessWidget {
  const RadioPlayerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RadioProvider>(
      builder: (context, radioProvider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple.shade900.withOpacity(0.8),
                Colors.pink.shade600.withOpacity(0.8),
                Colors.blue.shade800.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo/Ícone da rádio
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.pink.shade400,
                      Colors.purple.shade600,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.radio,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Nome da rádio
              const Text(
                'RADIO K-POP BRASIL',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 10),
              
              // Informações da música atual
              Column(
                children: [
                  Text(
                    radioProvider.currentTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    radioProvider.currentArtist,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              
              const SizedBox(height: 30),
              
              // Controles de reprodução
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botão de parar
                  _buildControlButton(
                    icon: Icons.stop,
                    onPressed: radioProvider.isPlaying ? () => radioProvider.stop() : null,
                    isEnabled: radioProvider.isPlaying,
                  ),
                  
                  const SizedBox(width: 20),
                  
                  // Botão principal (play/pause)
                  _buildMainPlayButton(radioProvider),
                  
                  const SizedBox(width: 20),
                  
                  // Botão de volume (placeholder)
                  _buildControlButton(
                    icon: Icons.volume_up,
                    onPressed: () {
                      // TODO: Implementar controle de volume
                    },
                    isEnabled: true,
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Indicador de status
              if (radioProvider.isLoading)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Conectando...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              else if (radioProvider.isPlaying)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.radio_button_checked,
                      color: Colors.green.shade400,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'AO VIVO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainPlayButton(RadioProvider radioProvider) {
    return GestureDetector(
      onTap: radioProvider.isLoading ? null : () => radioProvider.togglePlayPause(),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Colors.pink.shade400,
              Colors.purple.shade600,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withOpacity(0.5),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          radioProvider.isLoading
              ? Icons.hourglass_empty
              : radioProvider.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isEnabled,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isEnabled 
              ? Colors.white.withOpacity(0.2)
              : Colors.white.withOpacity(0.1),
          border: Border.all(
            color: isEnabled 
                ? Colors.white.withOpacity(0.3)
                : Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 24,
          color: isEnabled 
              ? Colors.white
              : Colors.white.withOpacity(0.5),
        ),
      ),
    );
  }
}

