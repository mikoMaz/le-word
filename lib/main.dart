import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:le_word_app/data/set_list_data.dart';
import 'package:le_word_app/pages/home_page.dart';
import 'package:le_word_app/pages/learn_page.dart';
import 'package:provider/provider.dart';

void main() async {
  // initialize hive
  await Hive.initFlutter();
  // open a hive box
  await Hive.openBox("word_set_database");
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   // title: 'Flutter Demo',
    //   debugShowCheckedModeBanner: false,
    //   home: HomePage(),
    // );
    return ChangeNotifierProvider(
      create: (context) => SetListData(),
      child: const MaterialApp(
        // title: 'Flutter Demo',
        // TODO: title
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        /* initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/learn-page': (context) => const LearnPage(setName: '')
        }, */
      ),
    );
  }
}
