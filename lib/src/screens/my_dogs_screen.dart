import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prepoznaj_psa/src/models/dog_model.dart';
import 'package:prepoznaj_psa/src/resorces/dogs_db_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDogsScreen extends StatelessWidget {
  const MyDogsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DogModel>>(
      future: DogDbProvider.db.getAllDogs(),
      builder: (BuildContext context, AsyncSnapshot<List<DogModel>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              DogModel dog = snapshot.data[index];
              var bytes = base64Decode(dog.image);
              return Card(
                color: Colors.white,
                child: Dismissible(
                  key: UniqueKey(),
                  onDismissed: (dismised) {
                    DogDbProvider.db.deleteDogWithId(dog.id);
                  },
                  child: ListTile(
                    title: Text(
                      dog.name,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: Image.memory(
                      bytes,
                      height: 100.0,
                      width: 100.0,
                    ),
                    trailing: GestureDetector(
                      child: Icon(
                        Icons.info,
                        color: Colors.black,
                      ),
                      onTap: () async {
                        var dogInfo = dog.name.replaceAll(" ", "-");
                        var url = 'https://www.akc.org/dog-breeds/$dogInfo/';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
