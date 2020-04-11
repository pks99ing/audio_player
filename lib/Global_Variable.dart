import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

int Number=0;
List listDynamic=[];
var url;


addList(BuildContext context) async{
  final number = await Firestore.instance.collection('MyAudioPlayer')
      .document('numberOfSongs')
      .get();
  Number=number['noOfSongs'];
  listDynamic.clear();
  for(int i=1;i<=Number;i++){
    final value = await Firestore.instance.collection('MyAudioPlayer')
        .document('Song$i')
        .get();
    listDynamic.add(GestureDetector(
      onTap: (){
        print('Yo click me');
        url=value['songs'];
        Navigator.of(context).pop();
      },
        child:MyCard(
          name: value['name'],
        )
    )
    );
  }
}
class MyCard extends StatelessWidget {
  MyCard({this.name});
  String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Text(name),
    );
  }
}
