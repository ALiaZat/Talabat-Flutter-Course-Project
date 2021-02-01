import 'menuDatabase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firstPage.dart';
import 'model.dart';

void main() {
      runApp(MyApp());
}

class MyApp extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => FavModel()),
            ChangeNotifierProvider(create: (context) => OrderedModel()),
            ChangeNotifierProvider(create: (context)=> MenuDatabase.mdb)
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: FirstPage(),
          ),
        );
      }
}
