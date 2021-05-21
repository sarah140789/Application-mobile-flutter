import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

import '../widgets/main_drawer.dart';
import '../screens/planning_screen.dart';
import '../providers/events.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:firebase_picture_uploader/firebase_picture_uploader.dart';




class EventScreen extends StatefulWidget {
  static const routeName = '/events';
  @override
  EventScreenState createState() => EventScreenState();
}
class EventScreenState extends State {
  var data;
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final picker = ImagePicker();
  File _image;
  String imageUrl;
  final _fbKey = GlobalKey<FormBuilderState>();
  Map<String, String> _RdvData = {
    'typarticle': '',
    'titre': '',
    'resume': '',
    'corps': '',
    'publication': '',
    'priorite': '',
    'imurl': '',
    'impath': '',
  };

  List<UploadJob> _profilePictures = [];



  // gets image from gallery and runs detectObject
  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No image Selected");
      }
    });
  }




  List<firebase_storage.UploadTask> _uploadTasks = [];

  /// The user selects a file, and the task is added to the list.
  Future<firebase_storage.UploadTask> uploadfile() async {


    if (_image == null) {
      print('No file was selected');
      return null;
    }

    firebase_storage.UploadTask uploadTask;

    // Create a Reference to the file
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('articles')
        .child('/image${Random().nextInt(99999)}.jpg');
    _RdvData['impath'] = 'image${Random().nextInt(99999)}.jpg';
    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': _image.path});

    if (kIsWeb) {
      uploadTask = ref.putData(await _image.readAsBytes(), metadata);
    } else {
      uploadTask = ref.putFile(File(_image.path), metadata);
      var dowurl = await (await uploadTask).ref.getDownloadURL();
      _RdvData['imurl'] = dowurl.toString();
      print(dowurl.toString());
    }

  }






  @override
    Widget build(BuildContext context) {

      List<Widget> stackChildren = [];

      stackChildren.add(
          Positioned(
            // using ternary operator
            child: _image == null ?
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Selectioonez une image SVP"),
                ],
              ),
            )
                : // if not null then
            Container(
                child: Image.file(_image,
                    width: 100,
                    height: 100,
                    fit:BoxFit.fill )
            ),
          )
      );



      return Scaffold(
        appBar: AppBar(
          title: Text("Nouvel Article"),
        ),

        drawer: MainDrawer(),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [

                FormBuilder(
                  key: _fbKey,
                  initialValue: {
                    'date': DateTime.now(),
                    'accept_terms': false,
                  },
                  autovalidateMode: AutovalidateMode.always,
                  child: Column(
                    children: [
                      FormBuilderDropdown(
                        name: "Typarticle",
                        style: Theme
                            .of(context)
                            .textTheme
                            .body1,
                        decoration: InputDecoration(
                            labelText: "Type d Article"),
                        // initialValue: 'Male',
                        hint: Text('Selectionnez un type d Article SVP'),
                        validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required(context)]),
                        items: ['News', 'Laser', 'Implantologie']
                            .map((gender) =>
                            DropdownMenuItem(
                                value: gender, child: Text("$gender")))
                            .toList(),
                        onSaved: (value) {
                          _RdvData['typarticle'] = value;
                        },
                      ),

                      FormBuilderTextField(
                        name: 'Titre',
                        style: Theme
                            .of(context)
                            .textTheme
                            .body1,
                        decoration: InputDecoration(labelText: "Titre "),
                        onSaved: (value) {
                          _RdvData['titre'] = value;
                        },
                      ),


                      FormBuilderTextField(
                        name: 'Resume ',
                        style: Theme
                            .of(context)
                            .textTheme
                            .body1,
                        decoration: InputDecoration(labelText:  "resume"),
                        onSaved: (value) {
                          _RdvData['resume'] = value;
                        },
                      ),


                      FormBuilderTextField(
                        name: 'corps ',
                        style: Theme
                            .of(context)
                            .textTheme
                            .body1,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 10,
                        // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.
                        decoration: InputDecoration(
                            labelText: "Corps  (20 lignes Max)"),
                        onSaved: (value) {
                          _RdvData['corps'] = value;
                        },
                      ),

                      new Divider(
                        color: Colors.transparent,
                      ),

                      RaisedButton(
                        color: Colors.deepPurple,
                        // background
                        textColor: Colors.white,
                        // foreground
                        padding: EdgeInsets.all(5),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                        ),
                        onPressed: getImageFromGallery,
                        child: Text('Inserrer une image'),
                      ),

                      Stack(
                        children: stackChildren,
                      ),

                      FormBuilderSlider(
                        name: "slider2",
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.min(context, 8),
                          FormBuilderValidators.max(context, 19),
                        ]),
                        min: 8.0,
                        max: 20.0,
                        initialValue: 9.0,
                        divisions: 12,
                        decoration: InputDecoration(
                            labelStyle: Theme
                                .of(context)
                                .textTheme
                                .body1,
                            labelText: "Priorité"),

                        onSaved: (value) {
                          _RdvData['priorite'] = (value).toString();
                        },

                      ),


                      FormBuilderCheckboxGroup(
                        decoration:
                        InputDecoration(labelText: "Timing", labelStyle: Theme
                            .of(context)
                            .textTheme
                            .body1,),
                        name: "Publication",
                        options: [
                          FormBuilderFieldOption(
                              value: "Publication immediate"),
                          FormBuilderFieldOption(
                              value: "En attente de publication"),
                        ],
                        onSaved: (value) {
                          _RdvData['publication'] = (value).toString();
                        },
                      ),

                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      child: Text(
                        "Submit", style: TextStyle(color: Colors.white),),
                      color: Colors.green,
                      onPressed: () async {
                        _fbKey.currentState.save();
                        if (_fbKey.currentState.validate()) {
                          await uploadfile();
                          await Provider.of<Events>(context, listen: false)
                              .rdvdemande(_RdvData['identite'], "bitan",
                              _RdvData['soin']);
                          await Provider.of<Events>(context, listen: false)
                              .edition(_RdvData['typarticle'], _RdvData['titre'],
                              _RdvData['resume'], _RdvData['corps'],
                              _RdvData['imurl'],_RdvData['impath'],_RdvData['prioorite'],_RdvData['publication']);

                          Navigator.of(context).pushReplacementNamed(
                              planningScreen.routeName);
                        }
                      },
                    ),
                    MaterialButton(
                      child: Text(
                        "Reset", style: TextStyle(color: Colors.white),),
                      color: Colors.deepOrange,
                      onPressed: () {
                        _fbKey.currentState.reset();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );

    }
  }