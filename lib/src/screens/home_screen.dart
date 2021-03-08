import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
/* import 'package:prepoznaj_psa/src/resorces/dogs_db_provider.dart'; */
import 'package:prepoznaj_psa/src/screens/my_dogs_screen.dart';
import 'package:prepoznaj_psa/src/screens/recognize_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.deepOrange,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: _page == 0 ? RecognizeScreen() : MyDogsScreen(),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 50.0,
        items: <Widget>[
          FaIcon(FontAwesomeIcons.search, color: Colors.black, size: 22),
          FaIcon(FontAwesomeIcons.dog, color: Colors.black, size: 22),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.deepOrange,
        animationCurve: Curves.decelerate,
        animationDuration: Duration(milliseconds: 400),
        onTap: (int index) async {
          setState(
            () {
              _page = index;
            },
          );

          /* await DogDbProvider.db.deleteAllDogs(); */
        },
      ),
    );
  }
}
