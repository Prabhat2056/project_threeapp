import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:project_etb/login/first_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyAo3_RB4F6lFCHBtaYDcWNjgPkIVgiOxOQ',
      appId: '1:795099479486:android:016d394cc1eeaa2d7dcdef',
      messagingSenderId: '795099479486',
      projectId: 'project-etc-f18ac',
      authDomain: "project-etc-f18ac.firebaseapp.com",
      storageBucket: 'project-etc-f18ac.firebasestorage.app',
    ),
  );

  runApp(const MyApp());
}

// void main(){
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        //scaffoldBackgroundColor: const Color.fromARGB(255, 76, 70, 193),
        scaffoldBackgroundColor: const Color.fromARGB(255, 215, 197, 35),
      ),
      //home: const FirstPage(),
      
    );
  }
}