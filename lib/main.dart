import 'package:ecosoftvmsgate/firebase_options.dart';
import 'package:ecosoftvmsgate/modals/example.dart';
import 'package:ecosoftvmsgate/ui/homescreen.dart';
import 'package:ecosoftvmsgate/ui/loginscreens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if(!kIsWeb) {
    await DesktopWindow.setFullScreen(true);
  }
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform
    );
    runApp(ChangeNotifierProvider(
      create: (context)=>exampledata(),
      builder: (context,child)=>const MainApp(),
    ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true
      ),
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser?.uid!=null)?HomePage(mode: "Staff",):LoginScreen(),
    );
  }
}
