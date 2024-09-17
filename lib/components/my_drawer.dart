import 'package:flutter/material.dart';
import 'package:fun_facts/pages/favorites_page.dart';
import 'package:fun_facts/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Image.asset(
              'assets/images/gym.png',
              scale: 5,
              color:
                  themeProvider.isDarkModeChecked ? Colors.white : Colors.black,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: ListTile(
              leading: const Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              title: const Text("F A V O R I T E S"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritesPage(),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
