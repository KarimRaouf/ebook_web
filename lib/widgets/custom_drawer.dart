import 'package:flutter/material.dart';

import '../core/utils/app_ui.dart';
import '../core/utils/app_util.dart';
import '../features/admin_panel/views/books_view.dart';
import '../features/admin_panel/views/users_view.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: AppUI.navyBlue,

            ),
            child: Text(
              'E-Book',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Books'),
            onTap: () {
              Navigator.pop(context);
              AppUtil.replacementNavigator(context, BooksView());
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Users'),
            onTap: () {
              // Update the state of the app
              // Then close the drawer
              Navigator.pop(context);
              AppUtil.replacementNavigator(context, UsersView());

            },
          ),
        ],
      ),
    );
  }
}
