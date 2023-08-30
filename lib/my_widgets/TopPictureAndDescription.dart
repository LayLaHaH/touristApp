import 'package:flutter/material.dart';

class TopPictureAndDescription extends StatelessWidget {
   TopPictureAndDescription({
    super.key,
    required this.label,
    required this.description
  });
  var label;
  var description;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 430,
      height: 280,
      child: Stack(
        children:[ 
          Positioned( 
            child: Image(image: AssetImage('Assets/homeBG.jpg'),)
            ),
          Positioned(
            top: 180,
            child: Container(
              width: 340,
              height: 100, 
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50)
                ),
                color: Colors.pink[800],
              ),
            ),
          ),
          Positioned(
            left: 30,
            top: 190,
            child: Text(label,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          //fontWeight: FontWeight.bold,
                          ),
                          
                          )
            ),
          Positioned(
            top: 230,
            left: 30,
            child: Text(description,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          
                          ),
                          
                          )
           ),
        ]
      ),
    );
  }
}

