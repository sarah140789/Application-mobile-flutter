import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/main_drawer.dart';
import '../widgets/badge.dart';


import 'package:cloud_firestore/cloud_firestore.dart';

enum FilterOptions {
  Favorite,
  All,
}

class rdvencoursScreen extends StatefulWidget {
  static const routeName = '/rdvencours';
  @override
  rdvencoursScreenState createState() => rdvencoursScreenState();
}

class rdvencoursScreenState extends State<rdvencoursScreen> {
  var _showOnlyfav = false;
  var _isInit = true;
  var _isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RDV en cours'),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Only favorites'), value: FilterOptions.Favorite),
              PopupMenuItem(child: Text('Show All'), value: FilterOptions.All),
            ],
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorite) {
                  _showOnlyfav = true;
                } else {
                  _showOnlyfav = false;
                }
              });
            },
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: HogeApp(), //ProductsGrid(_showOnlyfav),
    );
  }
}

class HogeApp extends StatelessWidget {



  void _showErrorDialog(String message,BuildContext context) {;
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Detail du RDV'),
      content: Text(message),
      backgroundColor: Color.fromRGBO(204, 255, 1, 1).withOpacity(0.9),
      shape:
      RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Ok'),textColor: Colors.redAccent),
      ],
    ),
  );
  }




  @override
  Widget build(BuildContext context) {
    // <1> Use FutureBuilder
    return FutureBuilder<QuerySnapshot>(
      // <2> Pass `Future<QuerySnapshot>` to future
        future: FirebaseFirestore.instance.collection('rdvencours').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData) {
              // <3> Retrieve `List<DocumentSnapshot>` from snapshot
              final List<DocumentSnapshot> documents = snapshot.data.docs;
              return ListView(
                  children: documents
                      .map((doc) =>
                      Card(
                        elevation: 20.0,
                        child: ListTile(
                          //leading: Icon(Icons.settings, size: 20.0),

                          leading: ConstrainedBox(
                              constraints:
                              BoxConstraints(minWidth: 100, minHeight: 100),
                              child: new Image.asset('assets/images/dent1.jpg',width: 100,
                                height: 100,
                              )),

                          //  leading: Image(image: AssetImage('images/dent1.jpg')),
                          title: Text(doc['title'] + ' du ' + doc['jour'] + ' ' +
                              doc['nbjour'] + ' ' + doc['mois'] + ' ' + doc['annee']),
                          subtitle: Text(doc['description']),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            print('Settings was tapped');
                            _showErrorDialog(doc['detail'],context);
                            /*     FirebaseFirestore.instance.collection('rdv').add(
                            {
                            "annee" :"2021",
                            "description" : "bridge a controler",
                            "detail" : "Avec le temps le bridge a tendance ase decoller.",
                            "jour" : "mardi",
                            "mois" :"mai",
                            "nbjour": "25",
                            "title" : "Bridge Controle"
                            }).then((value){
                          print(value.id);
                        });
                        */
                            //Navigator.pushNamed(context, TestConfirmation.id);
                          },
                        ),
                      ))
                      .toList());
            } else if (snapshot.hasError) {
              return Text('un probleme est survenu!');
            }
          }
        });
  }
}