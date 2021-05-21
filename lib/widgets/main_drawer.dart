import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppiz/screens/detection_screen.dart';
import 'package:shoppiz/screens/historique_screen.dart';
import 'package:shoppiz/screens/rdvencours_screen.dart';
import 'package:shoppiz/screens/news_screen.dart';
import 'package:shoppiz/screens/rdv_screen.dart';
import 'package:shoppiz/screens/events_screen.dart';
import '../screens/implantologie_screen.dart';
import '../screens/planning_screen.dart';
import '../screens/laser_screen.dart';
import '../providers/auth.dart';
import '../providers/events.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shoppiz/screens/planning_screen.dart';

class MainDrawer extends StatefulWidget {

  @override
  MainDrawerState createState() => MainDrawerState();
}
class MainDrawerState extends State {

  var isAdmin;
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  var namo;
  String auteur;
  @override

  void initState() {
    super.initState();
    namo = prefs.then((SharedPreferences prefs) {
      auteur=prefs.getString('auteur');
     setState(() {auteur=prefs.getString('auteur');});

    });
  }


  Widget _itemEdition(BuildContext context) {

      if (auteur=="redacteur1407@gmail.com")  {
          return ListTile(
            leading: Icon(Icons.library_books),
            title: Text('Edition Articles'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(EventScreen.routeName);

            },
          );
      }
      else  {
        return Divider();
      }

      }


  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
        children: <Widget>[
          AppBar(
            title: Text('Bienvenue'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('RDV en cours'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(rdvencoursScreen.routeName);
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.calendar_today_outlined),
            title: Text('Planning'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(planningScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Historique'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(HistoriqueScreen.routeName);
            },
          ),


          _itemEdition(context),


          ListTile(
            leading: Icon(Icons.home_repair_service_outlined),
            title: Text('Demande de RDV'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(rdvScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.fiber_new),
            title: Text('News'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(NewScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.import_export),
            title: Text('Implantologie'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ImplantologieScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.label_outline_sharp),
            title: Text('Lasers 1800'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(LaserScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Visio Detection'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(DetectionScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Deconnexion'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context,listen: false).logout();
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
