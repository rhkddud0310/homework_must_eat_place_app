import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:homework_must_eat_place_app/firebase_options.dart';
import 'view/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Flutter Framework 내부에서 발생하는 모든 오류를 감지하기 위함.
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };
  runZonedGuarded(
    () {
      runApp(const MyApp());
    },
    (error, stackTrace) {
      print('error outside Flutter');
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Widget 생성 과정에서 발생하는 오류를 감지하기 위함.
      builder: (context, widget) {
        ErrorWidget.builder = (errorDetails) {
          Widget error = Text('$errorDetails');
          if (widget is Scaffold || widget is Navigator) {
            error = Scaffold(
              body: SafeArea(child: error),
            );
          }
          return error;
        };
        return widget!;
      },
      defaultTransition: Transition.cupertino,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
} // End
