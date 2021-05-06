import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shoppiz/screens/laser_screen.dart';
import 'package:shoppiz/screens/implantologie_screen.dart';
import 'package:shoppiz/screens/rdvencours_screen.dart';
import 'package:shoppiz/screens/detection_screen.dart';
import './screens/planning_screen.dart';
import './screens/splash_screen.dart';
import './screens/news_screen.dart';
import './screens/events_screen.dart';
import './screens/historique_screen.dart';
import './screens/implantologie_screen.dart';
import './screens/auth screen.dart';
import './providers/auth.dart';
import './providers/events.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Events(),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Bienvenue',
            theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato'),
            home: auth.isAuth
                ? rdvencoursScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, snapShot) =>
                        snapShot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen()),
            routes: {
              EventScreen.routeName: (ctx) => EventScreen(),
              HistoriqueScreen.routeName: (ctx) => HistoriqueScreen(),
              ImplantologieScreen.routeName: (ctx) => ImplantologieScreen(),
              NewScreen.routeName: (ctx) => NewScreen(),
              rdvencoursScreen.routeName: (ctx) => rdvencoursScreen(),
              LaserScreen.routeName: (ctx) => LaserScreen(),
              planningScreen.routeName: (ctx) => planningScreen(),
              DetectionScreen.routeName: (ctx) => DetectionScreen(),
            },
          ),

        ));
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dr BITAN'),
      ),
      body: Center(
        child: Text("Dental App"),
      ),
    );
  }
}
