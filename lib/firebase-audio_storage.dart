



import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseAudioStorage{
  StorageReference storageReference;
  String name;

  saveAudioToStorage(String audioPath)async{
    print(audioPath);
    File file= File(audioPath);
    name=p.basename(file.path);
    storageReference =
        FirebaseStorage.instance.ref().child("audio/$name");
    final StorageUploadTask uploadTask =  storageReference.putFile(file);
    await uploadTask.onComplete;
    print('Uploading complete now you can check');
//    File file = await FilePicker.getFile(type: FileType.audio);
//    name=p.basename(file.path);
//    storageReference =
//        FirebaseStorage.instance.ref().child("audio/$name");
//    final StorageUploadTask uploadTask =  storageReference.putFile(file);

  }
}