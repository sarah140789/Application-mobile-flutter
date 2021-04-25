import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shoppiz/screens/laser_screen.dart';
import 'package:shoppiz/screens/nouveautes_screen.dart';
import 'package:shoppiz/screens/rdvencours_screen.dart';
import './screens/planning_screen.dart';
import './screens/splash_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/user_products_screen.dart';
import './screens/orders_screen.dart';
import './screens/news_screen.dart';
import './screens/events_screen.dart';
import './screens/cart_screen.dart';
import './screens/products_details_screen.dart';
import './screens/historique_screen.dart';
import './screens/implantologie_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/auth screen.dart';
import './providers/auth.dart';
import './providers/auth.dart';
import 'package:camera/camera.dart';
import './films/live_camera.dart';

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
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (BuildContext context) => Products( [], null),
            update: (BuildContext context, auth, prevProduct) => Products(
                prevProduct == null ? [] : prevProduct.items,
                auth.userId),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders( [], null),
            update: (ctx, auth, oldOrder) => Orders(
                oldOrder == null ? [] : oldOrder.orders, auth.userId),
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
              ProductsDetailsScreen.routeName: (ctx) => ProductsDetailsScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              EventScreen.routeName: (ctx) => EventScreen(),
              HistoriqueScreen.routeName: (ctx) => HistoriqueScreen(),
              ImplantologieScreen.routeName: (ctx) => ImplantologieScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              NewScreen.routeName: (ctx) => NewScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductsScreen.routeName: (ctx) => EditProductsScreen(),
              rdvencoursScreen.routeName: (ctx) => rdvencoursScreen(),
              NouveautesScreen.routeName: (ctx) => NouveautesScreen(),
              LaserScreen.routeName: (ctx) => LaserScreen(),
              planningScreen.routeName: (ctx) => planningScreen(),
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
