

import 'dart:io';
import 'package:audioplayer/Global_Variable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as p;
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState(){
    super.initState();
    initialize();
  }

  initialize()async{
   var status=await Firestore.instance.collection('MyAudioPlayer').document('numberOfSongs').get();
   if(status.exists){
     Number=status['noOfSongs'];
   }
  }

  checkInternet() async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
      else{
        print('internet speed');
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'MySongList':(context)=>MySongList()
      },
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String name;
  File file;
  bool value=false;
  StorageReference storageReference;
  AudioPlayer audioPlayer;

  void initState(){
    super.initState();
    audioPlayer=AudioPlayer();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Music Player'),
          centerTitle: true,
        ),
        body:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              name==null?Text('Not Selected'):Text(name.toString()),
              RaisedButton(
                child: Text('Choose Song'),
                onPressed: ()async{
                  file = await FilePicker.getFile(type: FileType.audio);
                  name=p.basename(file.path);
                  storageReference =
                  FirebaseStorage.instance.ref().child("audio/$name");
                  final StorageUploadTask uploadTask =  storageReference.putFile(file);
                  if(uploadTask.isInProgress){
                    setState(() {
                      value=true;
                    });
                  }
                  await uploadTask.onComplete;
                  value=false;
                  setState(() {

                  });
                },
              ),
              value==true?CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ):SizedBox(),
              RaisedButton(
                child: Text('Up load'),
                onPressed: () async{
                  Number++;
                  print(Number);
                  var list=await Firestore.instance.collection('MyAudioPlayer').document('numberOfSongs').get();
                  print(list.exists);
                  if(!list.exists){

                    await Firestore.instance.collection('MyAudioPlayer')
                        .document('numberOfSongs')
                        .setData({
                      'noOfSongs':Number
                    });
                    print('Stored------------------------->');
                  }else{
                    await Firestore.instance.collection('MyAudioPlayer')
                        .document('numberOfSongs')
                        .updateData({
                      'noOfSongs':Number
                    });
                  }
                  var url = await storageReference.getDownloadURL();
                  await Firestore.instance.collection('MyAudioPlayer')
                      .document('Song$Number')
                      .setData({
                    'songs':url,
                    'name':name
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.play_arrow),
                    onPressed: () async{
                   //   final ref = FirebaseStorage.instance.ref().child('audio/$name');
                   //   url= await ref.getDownloadURL();
                      int result = await audioPlayer.play(url);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.pause),
                    onPressed: () async{
                      int result = await audioPlayer.pause();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.stop),
                    onPressed: () async{
                      int result = await audioPlayer.stop();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.list),
                    onPressed: ()async{
                      await addList(context);
                      Navigator.pushNamed(context, 'MySongList');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class MySongList extends StatelessWidget {
  MySongList({this.context});
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                itemCount: listDynamic.length,
                itemBuilder: (_,index)=>listDynamic[index],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



