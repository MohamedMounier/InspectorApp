import 'package:flutter/material.dart';
import 'package:noteee_apps/provider/notes_provider.dart';
import 'package:provider/provider.dart';

import 'screens/data_screen.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotesProvider>(
      create: (context) => NotesProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.green,
        ),
        home:  DataScreen(),
      ),
    );
  }
}
