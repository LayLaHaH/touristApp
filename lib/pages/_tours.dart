// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_flutter/models/tour.dart';
import 'package:my_flutter/my_widgets/appBar.dart';
import 'package:my_flutter/my_widgets/collabsable.dart';
import 'package:my_flutter/my_widgets/my_drawer.dart';

import '../main.dart';
import '../my_widgets/TourCollapsable.dart';
import '../my_widgets/cardText.dart';
import '../my_widgets/leftSideAddress.dart';
import 'package:http/http.dart' as http;

class TourChoosing extends StatefulWidget {
  const TourChoosing({super.key});

  @override
  State<TourChoosing> createState() => _TourChoosingState();
}

class _TourChoosingState extends State<TourChoosing> {
  

 Future<List<Tour>> getRequest() async {
    // Make a get request to the records from the API
    final response = await http.get(Uri.parse('$baseUrl/Tour/getAll2'));
    var responseData = json.decode(response.body);
    

    List<Tour> tours = [];
    for (var gov in responseData) {
      try{
      Tour tour = Tour.fromJson(gov);
      tours.add(tour);
      
      }
      catch(e){
        debugPrint(e as String?);
      }
    }
    return tours;
  } 

  Future<List<String>> getDestinationPictures(int? id) async {
  final response = await http.get(Uri.parse('$baseUrl/Tour/$id/destination-pictures'));
  
  if (response.statusCode == 200) {
    final List<dynamic> pictureNames = json.decode(response.body);
    return pictureNames.map((name) => name.toString()).toList();
  } else {
    throw Exception('Failed to fetch destination pictures');
  }
}

/*    @override
  void initState() {
    super.initState();
    getData();
    
  } */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: myDrawer(),
      body: 
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children:  <Widget>[
                  //governorate slider
                  LeftSideAddress(title:'Tours', fontSize: 20.0,),
                  SizedBox(
                    height: 520,
                    child: FutureBuilder<List<Tour>>(
                      future: getRequest(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data?.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) => 
                             GestureDetector(
                              onTap: () {},
                              child: SizedBox(
                                height: 500,
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
                                            snapshot.data![index].name,
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
                                      child: cardText(label: "Number of days : " , description: snapshot.data![index].daysNnights)
                                    ),
                                    //theme
                                    Positioned(
                                      top: 90,
                                      left: 60,
                                      width: 230,
                                      child: cardText(label: "Theme : " , description: snapshot.data![index].theme)
                                    ),                     
                                    //cost
                                    Positioned(
                                      top: 120,
                                      left: 60,
                                      width: 230,
                                      child: cardText(description: "${snapshot.data![index].cost} ", label: "Cost : ",),
                                    ),
                                    //isPrivate
                                    Positioned(
                                      top: 140,
                                      left: 60,
                                      width: 230,
                                      child: cardText(label: "Privacy : " , 
                                            description: " ${snapshot.data![index].isPrivate==true?"Private":"In a group"}")
                                    ), 
                                    //guid
                                     Positioned(
                                      top: 160,
                                      left: 60,
                                      width: 230,
                                      child: cardText(label: "Languages of guids : " , description: snapshot.data![index].guidLanguage)
                                    ), 
                                   //images
                                    Positioned(
                                      top: 200,
                                      left: 35,
                                      child:FutureBuilder(
                                        future: getDestinationPictures(snapshot.data![index].id),
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
                                                        width: 240,
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
                                   //includes
                                   Positioned(
                                    top: 380,
                                     child: TourCollapsable(title: "Includes", content: 
                                     Column(
                                      children: [
                                        Text(snapshot.data![index].includes[0].includes),
                                        for(int i=0;i<snapshot.data![index].includes.length;)
                                        Text(snapshot.data![index].includes[0].includes)
                                   
                                      ],
                                     )),
                                   )
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
                  
                  
              ],
            ),
          ),
       
   
    );
  }
}