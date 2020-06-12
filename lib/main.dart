import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/screens/contactScreen.dart';

import './Screens/clienteScreen.dart';
import './Screens/linhaScreen.dart';
import './screens/user_products_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './screens/cart_screen.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/edit_product_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ccb',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.lightGreen,
          backgroundColor: Colors.amber,
          fontFamily: 'Lato',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: ,
        routes: {
          '/': (ctx) => ProductOverviewScreen(),
          ProductDetailScreen.productDetailScreenRoute: (ctx) =>
              ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
          ContactListPage.routeName: (ctx) => ContactListPage(),
          ClienteListPage.routeName: (ctx) => ClienteListPage(),
          LinhaListPage.routeName: (ctx) => LinhaListPage(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(
          'ShopApp',
        ),
      ),
    );
  }
}
