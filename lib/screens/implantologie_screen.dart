import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppiz/main.dart';

import '../widgets/main_drawer.dart';
import '../screens/cart_screen.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import 'package:camera/camera.dart';
import '../films/live_camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum FilterOptions {
  Favorite,
  
  All,
}



class ImplantologieScreen extends StatefulWidget {
  static const routeName = '/implantologie';
  @override
  ImplantologieScreenState createState() => ImplantologieScreenState();
}
class ImplantologieScreenState extends State<ImplantologieScreen> {
  var _showOnlyfav = false;
  var _isInit = true;
  var _isLoading = false;



  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();


    return Scaffold(
      appBar: AppBar(
        title: const Text('VISIO DETECTION'),
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
  List<CameraDescription> cameras;
  CameraDescription camera;


  @override
  void initState() {
    print('init oooooooooooooooooooooooooooooo');
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      print('____________CAMERA__________________');
      print(cameras.length);
      camera = cameras.first;
    });
  }

  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: Text("Détecteur"),
  actions: <Widget>[
  IconButton(
  icon: Icon(Icons.info),
  onPressed: aboutDialog,
  ),
  ],
  ),
  body: Container(
  child:Center(
  child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[

  ButtonTheme(
  minWidth: 160,
  child: RaisedButton(
  child: Text("analyse video  "),
  onPressed:() {
  Navigator.push(context, MaterialPageRoute(
  builder: (context) => LiveFeed(cameras),
  ),
  );
  },
  ),
  ),

  ],
  ),
  ),
  ),
  );
  }

  aboutDialog(){
  }

  }