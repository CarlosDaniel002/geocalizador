//Carlos DAniel Taveras Liranzo
import 'package:flutter/material.dart';
import 'package:geocalizador/pages/form.dart';
import 'package:geocalizador/pages/map_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarea 9 y 10',
      initialRoute: '/form',
      routes: {
        '/form':(context) => const FormPage(),
        '/map':(context) => const MapPage(),
      },
    );
  }
}