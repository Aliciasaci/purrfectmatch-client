import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PurrfectMatch',
      theme: ThemeData( scaffoldBackgroundColor: Colors.amberAccent[100]),
      home: const MyHomePage(title: 'PurrfectMatch'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,  textAlign: TextAlign.center),
        centerTitle: true,
      ),
      body: Center(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Calls',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Chats',
          ),
        ],
      ),
    );
  }
}
