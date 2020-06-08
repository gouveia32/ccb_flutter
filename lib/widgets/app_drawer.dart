import 'package:flutter/material.dart';
import 'package:shopapp/screens/contactScreen.dart';

import '../screens/user_products_screen.dart';
import '../screens/orders_screen.dart';
import '../Screens/clienteScreen.dart';
import '../Screens/linhaScreen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppBar(
            title: Text('Opções'),
            automaticallyImplyLeading: false,
          ),

          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Loja'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          //Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Pagamento'),
            onTap: () {
              Navigator.of(context).pushNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Produtos'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.routeName);
            },
          ),
          //Divider(),
          ListTile(
            leading: Icon(Icons.dialer_sip),
            title: Text('Contatos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(ContactListPage.routeName);
            },
          ),
          //Divider(),
          ListTile(
            leading: Icon(Icons.assignment_ind),
            title: Text('Clientes'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(ClienteListPage.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.threed_rotation),
            title: Text('Linhas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(LinhaListPage.routeName);
            },
          ),
        ],
      ),
    );
  }
}
