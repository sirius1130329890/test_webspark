import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test_webspark/presentation/providers/app.dart';
import 'package:test_webspark/presentation/view/home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.lightBlueAccent,
      systemNavigationBarColor: Colors.transparent
  ));


  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppProvider(),),
    ],
    child: const MyApp(),
  ));
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}