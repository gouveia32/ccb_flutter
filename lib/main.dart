import 'package:ccb_flutter/Screens/home_page.dart';
import 'package:flutter/material.dart';
import './Screens/contact_list_page.dart';
import './Screens/contact_detail_page.dart';
import './Screens/client_list_page.dart';
import './Screens/client_detail_page.dart';


import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'fab.dart';
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Tutorial',
      theme: ThemeData(primaryColor: Colors.white, accentColor: Colors.grey),
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePage createState() => _MyHomePage();
}
class _MyHomePage extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Widget myBody = ClientListPage();
  int currentItemIndex = 0;
  Animation<double> _animation;
  AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );
    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _controller);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      //appBar: AppBar(
      //  title: Text('CCB'),
      //  backgroundColor: Colors.white38
      //),
      body: myBody,
      floatingActionButton: ExpandedAnimationFab(
        items: [
          FabItem(
            "Clientes",
            Icons.people_outline,
            onPress: () {
              //Navigator.pushNamed(context, ClientListPage.routeName);
              //_controller.reverse();
              
              setState(() {
                _controller.reverse();
                myBody = ClientListPage();
              });
            },
          ),
          FabItem(
            "Fornecedores",
            Icons.settings_input_svideo,
            onPress: () {
              _controller.reverse();
            },
          ),
          FabItem(
            "Contatos",
            Icons.contacts,
            onPress: () {
              //Navigator.pushNamed(context, ContactScreen.routeName);
              //_controller.reverse();
              setState(() {
                _controller.reverse();
                myBody = ContactListPage();
              });
            },
          ),
          FabItem(
            "Home",
            Icons.home,
            onPress: () {
              setState(() {
                myBody = HomePage();
              });
            },
          ),
        ],
        animation: _animation,
        onPress: () {
          if (_controller.isCompleted) {
            _controller.reverse();
          } else {
            _controller.forward();
          }
        },
      ),
    );
  }
}
