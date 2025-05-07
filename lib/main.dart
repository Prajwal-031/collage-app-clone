import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart';
import 'services/navigation_service.dart';
import 'services/theme_service.dart';
import 'utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations for better performance
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize Firebase with proper configuration
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final NavigationService _navigationService = NavigationService();
  
  MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amity University Bengaluru',
      theme: ThemeService.lightTheme,
      navigatorKey: _navigationService.navigatorKey,
      initialRoute: AppConstants.ROUTE_LOGIN,
      routes: {
        AppConstants.ROUTE_LOGIN: (context) => const LoginScreen(),
        AppConstants.ROUTE_SIGNUP: (context) => const SignupScreen(),
        AppConstants.ROUTE_FORGOT_PASSWORD: (context) => const ForgotPasswordScreen(),
        AppConstants.ROUTE_HOME: (context) => const HomeScreen(),
      },
      debugShowCheckedModeBanner: false,
      // Optimize performance
      builder: (context, child) {
        // Optimize rendering settings for better performance
        return MediaQuery(
          // Avoid unnecessary text scaling which can be expensive
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}