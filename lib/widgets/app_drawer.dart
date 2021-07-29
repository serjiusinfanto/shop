import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../screens/user_products_screen.dart';
import '../helpers/custom_route.dart';
import '../screens/orders_screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  final String userName;
  AppDrawer(this.userName);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Hello User"),
            automaticallyImplyLeading: false,
          ),
          Divider(
            color: Colors.white54,
          ),
          ListTile(
            leading: Icon(
              Icons.shop,
              color: Theme.of(context).accentColor,
            ),
            title: Text("Shop"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(
            color: Colors.white54,
          ),
          ListTile(
            leading: Icon(
              Icons.payment,
              color: Theme.of(context).accentColor,
            ),
            title: Text("Orders"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(
            color: Colors.white54,
          ),
          ListTile(
            leading: Icon(
              Icons.edit,
              color: Theme.of(context).accentColor,
            ),
            title: Text("Manage Products"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
              // Navigator.of(context).pushReplacement(
              //   CustomRoute(
              //     builder: (ctx) => OrdersScreen(),
              //   ),
              // );
            },
          ),
          Divider(
            color: Colors.white54,
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).accentColor,
            ),
            title: Text("Logout"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
