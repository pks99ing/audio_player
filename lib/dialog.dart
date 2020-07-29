import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';

import 'audio_model.dart';

class DialogCard{

  FlutterAudioRecorder recorder;
  String externalStorage;
  String appStorage;
  bool storage;
  bool mic;
  bool isPermission;
  String customPath = '/flutter_audio_recorder_';

  Future<String> getAppStorage() async {
    if (await FlutterAudioRecorder.hasPermissions) {
      Directory x = await getExternalStorageDirectory();
      externalStorage = x.path +
          customPath +
          DateTime.now().millisecondsSinceEpoch.toString();
      print(externalStorage);
      return externalStorage;
    } else {
      return null;
    }
  }
  showDialogCard(BuildContext context){
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              width: double.infinity,
              height: 350.0,
              color: Colors.transparent,
              child: AlertDialog(
                title: Center(child: Text('Recording...')),
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(20.0)
                ),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.keyboard_voice),
                          iconSize: 40.0,
                          onPressed: () async {
                            appStorage = await getAppStorage();
                            if (appStorage != null) {
                              recorder = FlutterAudioRecorder(
                                externalStorage,
                              );
                            }
                            await recorder.initialized;
                            await recorder.start();
                            print('Started');
                          },
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        IconButton(
                          icon: Icon(Icons.stop),
                          iconSize: 40.0,
                          onPressed: () async {
                            await recorder.stop();
                            print('stopped');
                            //After recording stopped it should be store into firebase storage
                            await AudioModel().saveAudioToStorage(externalStorage+'.m4a');
                            print('audio file is save to the storage till now');
                          },
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        IconButton(
                          icon: Icon(Icons.play_arrow),
                          iconSize: 40.0,
                          onPressed: () async {
                            AudioPlayer audioPlayer =
                            AudioPlayer();
                            int result = await audioPlayer.play(
                                externalStorage + '.m4a',
                                isLocal: true);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

}