import 'package:attandance_app/screens/auth/login_page.dart';
import 'package:attandance_app/screens/home_page.dart';
import 'package:attandance_app/screens/main_navigation.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
    orElse: () => cameras.first,
  );
  runApp(MyApp(camera: frontCamera));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.camera});

  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ATTENDX',
      debugShowCheckedModeBanner: false,
      home: LoginPage(camera: camera,),
    );
  }
}

