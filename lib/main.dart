import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:prepoznaj_psa/src/app.dart';

void main() async {
  runApp(App());

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.deepOrange,
  ));
}
