
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dialog.dart';



class Recording extends StatefulWidget {
  @override
  _RecordingState createState() => _RecordingState();
}

class _RecordingState extends State<Recording> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GameDetails'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: IconButton(
                icon: Icon(Icons.keyboard_voice),
                onPressed: () {
                  DialogCard().showDialogCard(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
