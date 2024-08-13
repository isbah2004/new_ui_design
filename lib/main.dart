import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_design/provider/auth_provider.dart';
import 'package:ui_design/provider/crud_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ui_design/screens/splashscreen/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CrudProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
      ],
      child: const SafeArea(
        child: MaterialApp(
          home: SplashScreen(),
          title: 'LCPL Academy',
        ),
      ),
    ),
  );
}
