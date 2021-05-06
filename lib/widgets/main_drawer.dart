import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppiz/screens/detection_screen.dart';
import 'package:shoppiz/screens/historique_screen.dart';
import 'package:shoppiz/screens/rdvencours_screen.dart';
import 'package:shoppiz/screens/news_screen.dart';
import 'package:shoppiz/screens/events_screen.dart';
import '../screens/implantologie_screen.dart';
import '../screens/implantologie_screen.dart';
import '../screens/planning_screen.dart';
import '../screens/laser_screen.dart';
import '../providers/auth.dart';
import 'package:shoppiz/screens/planning_screen.dart';

class MainDrawer extends StatelessWidget {
  @override
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
          Divider(),
          ListTile(
            leading: Icon(Icons.home_repair_service_outlined),
            title: Text('Demande de RDV'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(EventScreen.routeName);
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
