// ESTE ARQUIVO É UM EXEMPLO — não contém credenciais reais.
//
// Para rodar o projeto:
// 1. Crie um projeto no Firebase Console (console.firebase.google.com)
// 2. Adicione um app Android/iOS com o package name do projeto
// 3. Ative Authentication > Email/Password
// 4. Instale o FlutterFire CLI: dart pub global activate flutterfire_cli
// 5. Rode: flutterfire configure
//    Isso vai gerar o arquivo real em lib/firebase_options.dart
//
// O arquivo gerado NÃO deve ser commitado (está no .gitignore).

// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError('Plataforma não suportada.');
    }
  }

  // Substitua pelos valores reais gerados pelo flutterfire configure
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
    iosBundleId: 'YOUR_BUNDLE_ID',
  );
}
