import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fun_facts/firebase_options.dart';
import 'package:fun_facts/pages/home_page.dart';
import 'package:fun_facts/providers/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    Provider.of<ThemeProvider>(context, listen: false).loadMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.isDarkModeChecked
          ? ThemeData.dark(
              useMaterial3: true,
            )
          : ThemeData.light(
              useMaterial3: true,
            ),
      // ignore: prefer_const_constructors
      home: HomePage(),
    );
  }
}
