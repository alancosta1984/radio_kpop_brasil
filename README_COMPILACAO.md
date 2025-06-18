# Radio K-POP Brasil - Instruções de Compilação e Publicação

## Pré-requisitos

### Para compilação iOS:
- macOS com Xcode 15.0 ou superior
- Apple Developer Account (US$ 99/ano)
- Flutter SDK instalado
- CocoaPods instalado

## Passos para Compilação no Xcode

### 1. Preparação do Ambiente
```bash
# Instalar Flutter (se não estiver instalado)
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Verificar instalação
flutter doctor

# Instalar CocoaPods (no macOS)
sudo gem install cocoapods
```

### 2. Configuração do Projeto
```bash
# Navegar para o diretório do projeto
cd radio_kpop_brasil

# Instalar dependências
flutter pub get

# Gerar arquivos iOS
flutter build ios --no-codesign
```

### 3. Configuração no Xcode

1. **Abrir o projeto no Xcode:**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Configurar Bundle Identifier:**
   - Selecione o projeto "Runner" no navegador
   - Na aba "General", altere o "Bundle Identifier" para algo único como:
     `com.seudominio.radiokpopbrasil`

3. **Configurar Team e Signing:**
   - Na seção "Signing & Capabilities"
   - Selecione seu Apple Developer Team
   - Ative "Automatically manage signing"

4. **Configurar Capabilities:**
   - Adicione "Background Modes" com:
     - Audio, AirPlay, and Picture in Picture
     - Background processing
   - Adicione "App Transport Security Settings" se necessário

### 4. Configuração de Ícones

1. **Gerar ícones em diferentes tamanhos:**
   - Use o arquivo `assets/icon/app_icon.png` como base
   - Gere os tamanhos necessários para iOS:
     - 20x20, 29x29, 40x40, 58x58, 60x60, 76x76, 80x80, 87x87, 120x120, 152x152, 167x167, 180x180, 1024x1024

2. **Adicionar ícones ao projeto:**
   - No Xcode, vá para `Runner > Assets.xcassets > AppIcon.appiconset`
   - Arraste os ícones para os slots correspondentes

### 5. Teste no Simulador/Dispositivo

```bash
# Testar no simulador
flutter run -d ios

# Testar em dispositivo físico
flutter run -d [DEVICE_ID]
```

### 6. Build para Produção

```bash
# Build para App Store
flutter build ios --release

# Ou build com Xcode
# No Xcode: Product > Archive
```

## Configurações Específicas do Projeto

### URLs do Shoutcast:
- **Stream URL (HTTPS):** `https://server.dacsolution.com.br/shoutcast3/listen.mp3`
- **Metadata URL (HTTP):** `http://server.dacsolution.com.br:9910`

### Permissões Configuradas:
- Reprodução de áudio em background
- Acesso à rede (HTTP e HTTPS)
- Controles de mídia do sistema
- Notificações de mídia

### Funcionalidades Implementadas:
- ✅ Streaming de áudio Shoutcast
- ✅ Controles play/pause/stop
- ✅ Exibição de metadados em tempo real
- ✅ Reprodução em background
- ✅ Controles de mídia do sistema (lock screen)
- ✅ Interface K-POP personalizada
- ✅ Reconexão automática em caso de erro

## Publicação na App Store

### 1. Preparação
- Certifique-se de que o app está funcionando corretamente
- Teste em diferentes dispositivos iOS
- Prepare screenshots para a App Store
- Escreva a descrição do app

### 2. App Store Connect
1. Acesse [App Store Connect](https://appstoreconnect.apple.com)
2. Crie um novo app
3. Configure as informações básicas
4. Faça upload do build via Xcode (Product > Archive > Upload to App Store)

### 3. Informações para a Store
- **Nome:** Radio K-POP Brasil
- **Categoria:** Music
- **Descrição:** A melhor rádio de K-POP do Brasil, transmitindo 24 horas por dia os maiores sucessos do pop coreano.
- **Keywords:** kpop, radio, korea, music, brasil, streaming

### 4. Review Guidelines
- O app segue as diretrizes da Apple
- Não é apenas um web view
- Oferece funcionalidade nativa de áudio
- Tem interface própria e controles nativos

## Solução de Problemas

### Erro de Certificado:
- Verifique se o Apple Developer Account está ativo
- Confirme se o Bundle ID está registrado
- Regenere os certificados se necessário

### Erro de Rede:
- Verifique as configurações de App Transport Security no Info.plist
- Confirme se as URLs do Shoutcast estão acessíveis

### Erro de Áudio:
- Verifique as permissões de áudio no Info.plist
- Confirme se o Background Modes está configurado corretamente

## Contato e Suporte

Para dúvidas sobre o desenvolvimento ou problemas de compilação, consulte:
- [Documentação oficial do Flutter](https://docs.flutter.dev)
- [Guia de publicação iOS](https://docs.flutter.dev/deployment/ios)
- [Apple Developer Documentation](https://developer.apple.com/documentation/)

---

**Nota:** Este projeto foi desenvolvido com Flutter 3.24.5 e testado para compatibilidade com iOS 12.0+. Certifique-se de que seu ambiente de desenvolvimento atende aos requisitos mínimos.

