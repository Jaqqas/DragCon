
import 'package:dragcon/NavBar.dart';
import 'package:flutter/material.dart';
class Stat extends StatefulWidget {
  const Stat({Key? key}) : super(key: key);

  @override
  StatState createState() => StatState();
}

class StatState extends State<Stat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavBar(),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/japback.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ));
  }
}
