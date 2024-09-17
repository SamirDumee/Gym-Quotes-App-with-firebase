import 'package:flutter/material.dart';
import 'package:fun_facts/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeSwitcher extends StatefulWidget {
  const ThemeSwitcher({super.key});

  @override
  State<ThemeSwitcher> createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> {
  bool isChanged = false;

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Theme Mode",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Switch(
                value: themeProvider.isDarkModeChecked,
                onChanged: (value) {
                  isChanged = value;
                  themeProvider.updateMode(value);
                },
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                  themeProvider.isDarkModeChecked ? "Dark Mode" : "Light Mode"),
            ],
          )
        ],
      ),
    );
  }
}
