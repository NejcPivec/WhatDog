import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultsPage extends StatefulWidget {
  final File imageURI;
  final List recognitions;

  const ResultsPage({Key key, this.imageURI, this.recognitions})
      : super(key: key);

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'What dog - Results',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 350.0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.file(
                  widget.imageURI,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: Text(
              "Your Dog looks like",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 30.0),
              height: 300.0,
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: widget.recognitions.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: Colors.deepOrange,
                    child: ListTile(
                      title: Text(
                        "${widget.recognitions[index]['label']}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: GestureDetector(
                        child: Icon(
                          Icons.info,
                          color: Colors.white,
                        ),
                        onTap: () async {
                          var dog = widget.recognitions[index]['label']
                              .replaceAll(" ", "-");
                          var url = 'https://www.akc.org/dog-breeds/$dog/';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
