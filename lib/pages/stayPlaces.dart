// ignore_for_file: prefer_const_constructors, file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_flutter/models/hotel.dart';
import 'package:my_flutter/my_widgets/TopPictureAndDescription.dart';
import 'package:my_flutter/my_widgets/appBar.dart';
import 'package:my_flutter/my_widgets/my_drawer.dart';
import 'package:http/http.dart' as http;


import '../main.dart';
import '../my_widgets/cardText.dart';
import '../my_widgets/leftSideAddress.dart';
//import 'package:http/http.dart';

class PlaceToStay extends StatefulWidget {
  const PlaceToStay({super.key});

  @override
  State<PlaceToStay> createState() => _PlaceToStayState();
}

class _PlaceToStayState extends State<PlaceToStay> {

   Future<List<Hotel>> getRequest() async {
    // Make a get request to the records from the API
    final response = await http.get(Uri.parse('$baseUrl/Hotel/getAll'));
    var responseData = json.decode(response.body);
    

    List<Hotel> hotels = [];
    for (var gov in responseData) {
      try{
      Hotel hotel = Hotel.fromJson(gov);
      hotels.add(hotel);
      
      }
      catch(e){
        debugPrint(e as String?);
      }
    }
    return hotels;
  } 
 /*   @override
  void initState() {
    super.initState();
    getRequest();
    
  } */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(),
      drawer: myDrawer(),
      body: 
      SingleChildScrollView(
        physics: BouncingScrollPhysics(),
          child: Column(
            children:  <Widget>[
              TopPictureAndDescription(label: "Hotels", description: ""),
              SizedBox(
                  height: 540,

                  child: FutureBuilder<List<Hotel>>(
                    future: getRequest(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return 
                         ListView.builder(
                          itemCount: snapshot.data!.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) => GestureDetector(
                            onTap: () {},
                            child: SizedBox(
                              height: 400,
                              width: 330,
                                child: Stack(
                                children: [
                                  //white card in the back
                                  Positioned(
                                    top: 25,
                                    left: 30,
                                    child: Material(
                                      child: Container(
                                        height: 330,
                                        width: 300,
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
                                  //name
                                  Positioned(
                                    top: 40,
                                    left: 60,
                                    child: Text( 
                                           snapshot.data![index].name,
                                           style: TextStyle( fontSize: 18,
                                            fontWeight: FontWeight.bold, 
                                            color: Colors.black54   
                                          ),
                                          textAlign: TextAlign.left,
                                    ),
                                  ),
                                  //number
                                  Positioned(
                                    top: 70,
                                    left: 60,
                                    width: 230,
                                    child: cardText(label: "Contact number : " , description: snapshot.data![index].contacNumber)
                                  ),
                                  //url
                                  Positioned(
                                    top: 95,
                                    left: 60,
                                    width: 230,
                                    child: cardText(label: "URL : " , description: snapshot.data![index].url)
                                  ),                     
                                  //stars
                                  Positioned(
                                    top: 120,
                                    left: 60,
                                    width: 230,
                                    child: cardText(description: "${snapshot.data![index].classStar} Stars ", label: "Class Stars : ",),
                                  ),
                                  //address
                                  Positioned(
                                    top: 145,
                                    left: 60,
                                    width: 230,
                                    child: cardText(label: "Address : " , description: snapshot.data![index].address)
                                  ),
                                  //image
                                  Positioned(
                                    top: 200,
                                    left: 15,
                                    child: Card(
                                      elevation: 10,
                                      shadowColor: Colors.grey.withOpacity(0.5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Container(
                                        height: 170,
                                        width: 240,
                                        decoration: BoxDecoration(
                                          color: Colors.pink[800],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Image(
                                                  image: NetworkImage('$photoUrl/Hotels/${snapshot.data![index].image}'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                      ),
                                    )
                                    ),
                                ],
                              ),
                            ),

                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error loading data');
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                SizedBox(height: 10,),
            ]
          )
      ),
   

 );
  }
}
