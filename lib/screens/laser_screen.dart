import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/main_drawer.dart';
import '../widgets/badge.dart';


import 'package:cloud_firestore/cloud_firestore.dart';

enum FilterOptions {
  Favorite,
  All,
}

class LaserScreen extends StatefulWidget {
  static const routeName = '/laser';
  @override
  LaserScreenState createState() => LaserScreenState();
}

class LaserScreenState extends State<LaserScreen> {
  var _showOnlyfav = false;
  var _isInit = true;
  var _isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LASER'),
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

  @override
  Widget build(BuildContext context) {
    // <1> Use FutureBuilder
    return FutureBuilder<QuerySnapshot>(
      // <2> Pass `Future<QuerySnapshot>` to future
        future: FirebaseFirestore.instance.collection('laser').get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // <3> Retrieve `List<DocumentSnapshot>` from snapshot
            final List<DocumentSnapshot> documents = snapshot.data.docs;
            return ListView(
                children: documents
                    .map((doc) => Card(
                  child: ListTile(
                    leading: ConstrainedBox(
                        constraints:
                        BoxConstraints(minWidth: 100, minHeight: 100),
                        child: new Image.asset('assets/images/laser.jpg',width: 100,
                          height: 100,
                        )),
                    title: Text(doc['title']),
                    subtitle: Text(doc['texte']),
                  ),
                ))
                    .toList());
          } else if (snapshot.hasError) {
            return Text('un probleme est survenu!');
          }
        });
  }
}