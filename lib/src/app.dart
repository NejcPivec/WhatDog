import 'package:flutter/material.dart';
import 'package:prepoznaj_psa/src/screens/home_screen.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "What dog",
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.deepOrange,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
