// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';


class TourCollapsable extends StatelessWidget {
  final String title;
  final Widget content;
   const TourCollapsable({
    super.key,
    required this.title,
    required this.content
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        childrenPadding: 
            const EdgeInsets.symmetric(vertical:10 ,horizontal: 20),
        collapsedIconColor: Colors.black54, 
        title: Text(title,style: TextStyle(
            color: Colors.black54,fontWeight: FontWeight.bold),),
        children: [
          content
        ],
      ),
    );
  }
}