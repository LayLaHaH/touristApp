// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:flutter/material.dart';

class myDrawer extends StatefulWidget {
  const myDrawer({super.key});

  @override
  State<myDrawer> createState() => _myDrawerState();
}

class _myDrawerState extends State<myDrawer> {
  @override
  Widget build(BuildContext context) {
    return  Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.all(0),
            child: Container(
              height: 100,
              color: Colors.pink[800],
            ),
          ),
          ListTile(leading: Icon(Icons.travel_explore),title: Text('Pick a tour'),
            onTap: (){Navigator.pushNamed(context, '/tours');},),
          ListTile(leading: Icon(Icons.local_activity_outlined),title: Text('Things to do'),
            onTap: (){Navigator.pushNamed(context, '/thingsToDo');},),
          ListTile(leading: Icon(Icons.food_bank),title: Text('Where to eat'),
            onTap: (){Navigator.pushNamed(context, '/food');},),
          ListTile(leading: Icon(Icons.hotel),title: Text('where to stay'),
            onTap: (){Navigator.pushNamed(context, '/stay');},),
          ListTile(leading: Icon(Icons.shopping_bag),title: Text('where to shop'),
            onTap: (){Navigator.pushNamed(context, '/shop');},), 
            Divider(), 
          ListTile(leading: Icon(Icons.settings),title: Text('Tour Settings'),
            onTap: (){Navigator.pushNamed(context, '/tourSettings');},),
        ],
      ),
    );
  }
}