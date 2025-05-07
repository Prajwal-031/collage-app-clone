import 'package:firebase_core/firebase_core.dart';

const firebaseConfig = {
  'apiKey': 'AIzaSyAgMPMRTV0J3n2xEgdq7VNUqgV7Ar2r1LU',
  'authDomain': 'my-flutter-web-app-d31c2.firebaseapp.com',
  'projectId': 'my-flutter-web-app-d31c2',
  'storageBucket': 'my-flutter-web-app-d31c2.firebasestorage.app',
  'messagingSenderId': '394243384732',
  'appId': '1:394243384732:web:6942fff0451841b8219459',
  'measurementId': 'G-890G38KDZ1'
};

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyAgMPMRTV0J3n2xEgdq7VNUqgV7Ar2r1LU',
      authDomain: 'my-flutter-web-app-d31c2.firebaseapp.com',
      projectId: 'my-flutter-web-app-d31c2',
      storageBucket: 'my-flutter-web-app-d31c2.firebasestorage.app',
      messagingSenderId: '394243384732',
      appId: '1:394243384732:web:6942fff0451841b8219459',
      measurementId: 'G-890G38KDZ1',
    );
  }

  static Future<FirebaseOptions> fromConfig() async {
    return FirebaseOptions(
      apiKey: firebaseConfig['apiKey']!,
      authDomain: firebaseConfig['authDomain']!,
      projectId: firebaseConfig['projectId']!,
      storageBucket: firebaseConfig['storageBucket']!,
      messagingSenderId: firebaseConfig['messagingSenderId']!,
      appId: firebaseConfig['appId']!,
      measurementId: firebaseConfig['measurementId'],
    );
  }
}

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: firebaseConfig['apiKey']!,
      authDomain: firebaseConfig['authDomain']!,
      projectId: firebaseConfig['projectId']!,
      storageBucket: firebaseConfig['storageBucket']!,
      messagingSenderId: firebaseConfig['messagingSenderId']!,
      appId: firebaseConfig['appId']!,
      measurementId: firebaseConfig['measurementId'],
    ),
  );
}