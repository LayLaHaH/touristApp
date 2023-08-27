// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.pink[800],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))
      ),
      title: TextButton(
        onPressed: () { Navigator.popUntil(context, (route) => route.isFirst); },
        //onHover: ,
        child: Text('SYRTRAV',style: TextStyle(color: Colors.white,fontSize:20)),
        ),
        centerTitle: true,
      /* actions:[ 
        IconButton(icon: Icon(Icons.home), onPressed: () {  },),
      ], */
      
      );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}