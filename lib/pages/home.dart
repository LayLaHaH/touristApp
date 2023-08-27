// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_flutter/my_widgets/appBar.dart';
import '../main.dart';
import '../models/governorate.dart';
import '../my_widgets/govCard.dart';
import '../my_widgets/collabsable.dart';
import '../my_widgets/leftSideAddress.dart';
import '../my_widgets/my_drawer.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    
  Future<List<Governorate>> getRequest() async {
    // Make a get request to the records from the API
    final response = await http.get(Uri.parse('$baseUrl/Governorate/getAll'));
    var responseData = json.decode(response.body);

    List<Governorate> governorates = [];
    for (var gov in responseData) {
      Governorate governorate = Governorate.fromJson(gov);
      governorates.add(governorate);
    }
    return governorates;
  }
    

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
                //background photo and description
                  SizedBox(
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
                          child: Text('Welcome to Syria',
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
                          child: Text('Landscapes, monuments, traditional areas \n and experiences like no other',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        
                                        ),
                                        
                                        )
                         ),
                      ]
                    ),
                  ),
                  SizedBox(height: 15,),
                  //governorate slider
                  LeftSideAddress(title:'Governorates', fontSize: 20.0,),
                  SizedBox(
                    height: 220,
                    child: FutureBuilder<List<Governorate>>(
                      future: getRequest(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data?.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) => GestureDetector(
                              onTap: (){Navigator.pushNamed(context, '/gov',arguments: snapshot.data![index]);},
                              child: GovCard(
                                title: snapshot.data![index].name,
                                imgPath: '$photoUrl/Governorates/${snapshot.data![index].picture}',
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
                  LeftSideAddress(title:"What you need to Know", fontSize: 15.0,),
                  Collapsable( title: 'Dress Code',
                      content: "Syria is a cosmopolitan city and a diverse melting pot where almost all attires and cultural expressions are accepted ."
                      "Dressing conservatively is appreciated in Syria's historic neighbourhoods and places of worship."
                      "There are specific requirements for entering a mosque, like wearing clothing that covers shoulders, arms and legs and headscarves for women."
                      ,
                      ),
                  Collapsable(title: 'Greetings & etiquette',
                     content: "Marhaba! Syria is a warm and friendly country and you will come across many people who will greet you with a smile and wish you well."
                     " A handshake is customary, but do note it is typically accepted that this should be initiated by women."
                     "Public displays of affection are best kept to a minimum."
                     ),
                  Collapsable(title: "Tipping",
                     content: "To tip or not to tip? The short answer is, there are no rules when it comes to tipping in Syria."
                     " How much you tip varies from profession to profession, and is also largely down to personal preference."
                     " It is customary to offer a little extra in most cases, but it certainly isn’t compulsory."
                     ),
                  Collapsable(title: "Emergency numbers",
                   content: """police:112
Fire:113
Medical Emergency: 110"""
                     ),  
                  
              ],
            ),
          ),
       
    );
  }
}

