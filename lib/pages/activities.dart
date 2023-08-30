// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_flutter/my_widgets/TopPictureAndDescription.dart';
import 'package:my_flutter/my_widgets/appBar.dart';
import 'package:my_flutter/my_widgets/my_drawer.dart';

import '../main.dart';
import '../models/activity.dart';
import '../my_widgets/cardText.dart';
import '../my_widgets/leftSideAddress.dart';
import 'package:http/http.dart' as http;


class ThingsToDo extends StatefulWidget {
  const ThingsToDo({super.key});

  @override
  State<ThingsToDo> createState() => _ThingsToDoState();
}

class _ThingsToDoState extends State<ThingsToDo> {

   Future<List<Activity>> getRequest() async {
    // Make a get request to the records from the API
    final response = await http.get(Uri.parse('$baseUrl/Activity/getAll'));
    var responseData = json.decode(response.body);
    

    List<Activity> activities = [];
    for (var gov in responseData) {
      try{
      Activity activity = Activity.fromJson(gov);
      activities.add(activity);
      
      }
      catch(e){
        debugPrint(e as String?);
      }
    }
    return activities;
  } 


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
              TopPictureAndDescription(label: "Activities", description: ""),
               SizedBox(
                    height: 450,
                    child: FutureBuilder<List<Activity>>(
                      future: getRequest(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return 
                          ListView.builder(
                          itemCount: snapshot.data!.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) => 
                          GestureDetector(
                            onTap: () {},
                            child: SizedBox(
                              height: 400,
                              width: 330,
                                child: Stack(
                                children: [
                                  //white card in the back
                                  Positioned(
                                    top: 0,
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
                                    top: 20,
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
                                    top: 50,
                                    left: 60,
                                    width: 230,
                                    child: cardText(label: "Opening hours : " , description: "from ${snapshot.data![index].startTime.hour} to ${(snapshot.data![index].closeTime.hour)}")
                                  ),
                                  Positioned(
                                    top: 70,
                                    left: 60,
                                    width: 230,
                                    child: cardText(label: "Oppening days : " , description: "from ${snapshot.data![index].startingDay?.day} to ${snapshot.data![index].endingDay?.day}")
                                  ),                     
                                  Positioned(
                                    top: 100,
                                    left: 60,
                                    width: 230,
                                    child: cardText(description: "${snapshot.data![index].price} ", label: "Price : ",),
                                  ),
                                  Positioned(
                                    top: 120,
                                    left: 60,
                                    width: 230,
                                    child: cardText(label: "Description : " , description:  snapshot.data![index].description)
                                  ), 
                                  //image
                                  Positioned(
                                    top: 175,
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
                                            image: NetworkImage('$photoUrl/Activities/${snapshot.data![index].image}'),
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
                        ); } else if (snapshot.hasError) {
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
   

/* child: ListView.builder(
              itemCount: 25,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) => 
              GestureDetector(
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
                              "activity name",
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
                        child: cardText(label: "Opening hours : " , description: "from 12:00 to 19:00")
                      ),
                      Positioned(
                        top: 90,
                        left: 60,
                        width: 230,
                        child: cardText(label: "Oppening days : " , description: "on the weekends")
                      ),                     
                      Positioned(
                        top: 120,
                        left: 60,
                        width: 230,
                        child: cardText(description: "5 S.L ", label: "Price : ",),
                      ),
                      Positioned(
                        top: 140,
                        left: 60,
                        width: 230,
                        child: cardText(label: "Description : " , description: "sdfs sldkfsl laskd alskdalsd  sldkfsldf lsksldf lskdflsd ")
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
                          ),
                        )
                        ),
                    ],
                  ),
                ),
              ),
            ) */
          );
  }
}
