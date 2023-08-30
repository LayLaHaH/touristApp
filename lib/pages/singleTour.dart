// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_flutter/my_widgets/TourCollapsable.dart';
import 'package:my_flutter/my_widgets/leftSideAddress.dart';

import '../main.dart';
import '../models/tour.dart';
import '../my_widgets/appBar.dart';
import '../my_widgets/cardText.dart';
import '../my_widgets/collabsable.dart';
import '../my_widgets/my_drawer.dart';
import 'package:http/http.dart' as http;


class SingleTour extends StatefulWidget {
  const SingleTour({super.key});

  @override
  State<SingleTour> createState() => _SingleTourState();
}

class _SingleTourState extends State<SingleTour> {
late var tour;

  @override
  Widget build(BuildContext context) {
    final Tour t = ModalRoute.of(context)!.settings.arguments as Tour;
    tour=t;
    
  Future<List<String>> getDestinationPictures(int? id) async {
  final response = await http.get(Uri.parse('$baseUrl/Tour/$id/destination-pictures'));
  
  if (response.statusCode == 200) {
    final List<dynamic> pictureNames = json.decode(response.body);
    return pictureNames.map((name) => name.toString()).toList();
  } else {
    throw Exception('Failed to fetch destination pictures');
  }
}


    return Scaffold(
      appBar: MyAppBar(),
      drawer: myDrawer(),
      body: 
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children:  <Widget>[
                SizedBox(
                  height: 440,
                  width: 330,
                    child: Stack(
                    children: [
                      //white card in the back
                      Positioned(
                        top: 25,
                        left: 30,
                        child: Material(
                          child: Container(
                            height: 360,
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
                          tour.name,
                          style: TextStyle( fontSize: 18,
                            fontWeight: FontWeight.bold, 
                            color: Colors.black54   
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      //number of days
                      Positioned(
                        top: 70,
                        left: 60,
                        width: 230,
                        child: cardText(label: "Number of days : " , description: tour.daysNnights)
                      ),
                      //theme
                      Positioned(
                        top: 90,
                        left: 60,
                        width: 230,
                        child: cardText(label: "Theme : " , description: tour.theme)
                      ),                     
                      //cost
                      Positioned(
                        top: 120,
                        left: 60,
                        width: 230,
                        child: cardText(description: "${tour.cost} ", label: "Cost : ",),
                      ),
                      //isPrivate
                      Positioned(
                        top: 140,
                        left: 60,
                        width: 230,
                        child: cardText(label: "Privacy : " , 
                              description: " ${tour.isPrivate==true?"Private":"In a group"}")
                      ), 
                      //guid
                        Positioned(
                        top: 160,
                        left: 60,
                        width: 230,
                        child: cardText(label: "Languages of guids : " , description: tour.guidLanguage)
                      ), 
                      //images
                      Positioned(
                        top: 200,
                        left: 35,
                        child:FutureBuilder(
                          future: getDestinationPictures(tour.id),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return  SizedBox(
                                width: 280,
                                height: 200,
                                child: ListView.builder(
                                      itemCount: snapshot.data?.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (BuildContext context, int index) => 
                                      Card(
                                        elevation: 10,
                                        shadowColor: Colors.grey.withOpacity(0.5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                          height: 10,
                                          width: 270,
                                          decoration: BoxDecoration(
                                            color: Colors.pink[800],
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Image(
                                              image: NetworkImage('$photoUrl/Destinations/${snapshot.data![index]}'??'$photoUrl/Destinations/Homs.jpg'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )
                                      ,
                                ),
                              );
                              } else if (snapshot.hasError) {
                                return Text('Error loading data');
                              } else {
                                return Center(child: CircularProgressIndicator());
                              }
                            }
                          )
                        ),

                    ],
                  ),
                ),
                //includes
                LeftSideAddress(title: "Includes", fontSize: 20) ,  
                Column(
                children: [
                  for (var element in tour.includes) 
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30,5,0,5),
                      child: Row(
                        children: [
                          Icon(Icons.check,color: Colors.green,),
                           SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 330,
                                    child: Text(element.includes),
                                  ),
                                ],
                              ),
                            ),
                          
                        ],
                      ),
                    )
                  ],
                ) ,            
                //excludes
                LeftSideAddress(title: "Excludes", fontSize: 20) ,  
                Column(
                children: [
                  for (var element in tour.excludes) 
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30,5,0,5),
                      child: Row(
                        children: [
                          Icon(Icons.close,color: Colors.red,),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5,0,10,0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 330,
                                    child: Text(element.excludes),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ) ,            
                //itinerary
                LeftSideAddress(title: "Itinerary", fontSize: 20) ,  
                Column(
                children: [
                  for (var element in tour.itineraries) 
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30,5,0,5),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month,color: Colors.grey,),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5,0,10,0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 330,
                                    child: Text(element.eachDayDescription),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ) ,            
                
                 ]
            )
          )
    );
  }
}