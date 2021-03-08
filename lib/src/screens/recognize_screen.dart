import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitPumpingHeart;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prepoznaj_psa/src/screens/results_page.dart';
import 'package:tflite/tflite.dart';

import '../models/dog_model.dart';
import '../resorces/dogs_db_provider.dart';

class RecognizeScreen extends StatefulWidget {
  const RecognizeScreen({Key key}) : super(key: key);

  @override
  _RecognizeScreenState createState() => _RecognizeScreenState();
}

class _RecognizeScreenState extends State<RecognizeScreen> {
  File imageURI;
  bool inProcess = false;
  final picker = ImagePicker();
  List<dynamic> _recognitions;

  Random random = new Random();

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future loadModel() async {
    Tflite.close();
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    );
  }

  Future classifyImage(String path) async {
    var recognitions = await Tflite.runModelOnImage(
      path: path,
      numResults: 3,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );

   setState(() {
      _recognitions = recognitions;
    });

    print(_recognitions);

    /*   Tflite.close(); */
  }

  Future getImage(ImageSource source) async {
    setState(() {
      inProcess = true;
    });

    final pickedImage = await picker.getImage(source: source);

    if (pickedImage != null) {
      File croppedImage = await ImageCropper.cropImage(
        sourcePath: pickedImage.path,
        compressQuality: 100,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.deepOrange,
          toolbarTitle: 'Crop Image',
          toolbarWidgetColor: Colors.white,
          backgroundColor: Colors.white,
        ),
      );

      setState(() {
        imageURI = croppedImage;
        inProcess = false;
      });

      if (croppedImage != null) {
        await classifyImage(croppedImage.path);

        List<int> imageBytes = croppedImage.readAsBytesSync();

        try {
          await DogDbProvider.db.addDogToDatabase(new DogModel(
            id: random.nextInt(10000),
            name: _recognitions[0]["label"],
            image: base64Encode(imageBytes),
          ));
        } catch (e) {
          print('Nekaj je šlo narobe');
          print(e);
        }
      }
    } else {
      setState(() {
        inProcess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return inProcess == true
        ? Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.deepOrange,
              ),
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: SpinKitPumpingHeart(
                  color: Colors.white,
                  size: 200.0,
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return buildAlert();
                    },
                  );
                },
              ),
              SizedBox(
                height: 50.0,
              ),
              Text(
                'Tap to recognize',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                ),
              ),
            ],
          );
  }

  Widget buildAlert() {
    return AlertDialog(
      title: Center(
        child: Text(
          'Choose',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.0,
          ),
        ),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RaisedButton(
            color: Colors.deepOrange,
            child: Text(
              "Gallery",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              await getImage(ImageSource.gallery);
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultsPage(
                    imageURI: imageURI,
                    recognitions: _recognitions,
                  ),
                ),
              ).then(
                (_) => Navigator.of(context).pop(),
              );
            },
          ),
          RaisedButton(
            color: Colors.deepOrange,
            child: Text(
              "Camera",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              await getImage(ImageSource.camera);
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultsPage(
                    imageURI: imageURI,
                    recognitions: _recognitions,
                  ),
                ),
              ).then(
                (_) => Navigator.of(context).pop(),
              );
            },
          ),
        ],
      ),
    );
  }
}
