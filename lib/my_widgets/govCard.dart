// ignore_for_file: prefer_const_constructors, file_names, camel_case_types

import 'package:flutter/material.dart';

class GovCard extends StatelessWidget {
  final String title;
  final String imgPath;
  const GovCard({
    super.key,
    required this.title,
    required this.imgPath
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: 270,
        child: Stack(
        children: [
          Positioned(
            top: 25,
            left: 30,
            child: Material(
              child: Container(
                height: 180,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 4,
                      offset: Offset(-10, 10),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 60,
            child: Text( title,
                  style: TextStyle( fontSize: 15,
                    fontWeight: FontWeight.bold, 
                    color: Colors.black54   
                  ),
                  textAlign: TextAlign.left,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 15,
            child: Card(
              elevation: 10,
              shadowColor: Colors.grey.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                height: 140,
                width: 210,
                decoration: BoxDecoration(
                  color: Colors.pink[800],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          image: NetworkImage(imgPath),
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            )
            ),
            Positioned(
              top:60,
              left:200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('')
                ],
              ),
              ),
        ],
      ),
    );
  }
}

