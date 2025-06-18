import UIKit
import Flutter
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Configurar sessão de áudio
    do {
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.allowBluetooth, .allowBluetoothA2DP])
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print("Erro ao configurar sessão de áudio: \(error)")
    }
    
    GeneratedPluginRegistrant.register(with: self)
    
    // Configurar canal de método para controles de mídia
    setupMediaControlsChannel()
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func setupMediaControlsChannel() {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      return
    }
    
    let channel = FlutterMethodChannel(name: "radio_kpop_brasil/media_controls", binaryMessenger: controller.binaryMessenger)
    
    channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      switch call.method {
      case "setupMediaControls":
        self.setupMediaControls()
        result(nil)
      case "updateMetadata":
        if let args = call.arguments as? [String: Any] {
          self.updateMetadata(args: args)
        }
        result(nil)
      case "setPlaybackState":
        if let args = call.arguments as? [String: Any] {
          self.setPlaybackState(args: args)
        }
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
  
  private func setupMediaControls() {
    let commandCenter = MPRemoteCommandCenter.shared()
    
    commandCenter.playCommand.addTarget { _ in
      // Enviar comando de play para Flutter
      return .success
    }
    
    commandCenter.pauseCommand.addTarget { _ in
      // Enviar comando de pause para Flutter
      return .success
    }
    
    commandCenter.stopCommand.addTarget { _ in
      // Enviar comando de stop para Flutter
      return .success
    }
  }
  
  private func updateMetadata(args: [String: Any]) {
    let title = args["title"] as? String ?? "Radio K-POP Brasil"
    let artist = args["artist"] as? String ?? "Ao Vivo"
    
    var nowPlayingInfo = [String: Any]()
    nowPlayingInfo[MPMediaItemPropertyTitle] = title
    nowPlayingInfo[MPMediaItemPropertyArtist] = artist
    nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = "Radio K-POP Brasil"
    
    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
  }
  
  private func setPlaybackState(args: [String: Any]) {
    let isPlaying = args["isPlaying"] as? Bool ?? false
    
    var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [String: Any]()
    nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
    
    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
  }
}

