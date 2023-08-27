// ignore_for_file: prefer_const_constructors, file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_flutter/models/market.dart';
import 'package:my_flutter/my_widgets/appBar.dart';
import 'package:my_flutter/my_widgets/my_drawer.dart';

import '../main.dart';
import '../my_widgets/leftSideAddress.dart';
import 'package:http/http.dart' as http;

class ShoppingPlaces extends StatefulWidget {
  const ShoppingPlaces({super.key});

  @override
  State<ShoppingPlaces> createState() => _ShoppingPlacesState();
}

class _ShoppingPlacesState extends State<ShoppingPlaces> {
  late Future<List<Market>> markets;
  

  Future<List<Market>> getRequest() async {
    // Make a get request to the records from the API
    final response = await http.get(Uri.parse('$baseUrl/Market/getAll'));
    var responseData = json.decode(response.body);

    List<Market> governorates = [];
    for (var gov in responseData) {
      Market governorate = Market.fromJson(gov);
      governorates.add(governorate);
    }
    return governorates;
  }

/*    @override
  void initState() {
    super.initState();
    markets =getRequest();
    
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
              SizedBox(height: 10,),
              LeftSideAddress(title:'Markets (Souks)', fontSize: 20.0,),
                SizedBox(
                  height: 540,
                  child: FutureBuilder<List<Market>>(
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
                              height: 340,
                              width: 330,
                                child: Stack(
                                children: [
                                  //white card in the back
                                  Positioned(
                                    top: 25,
                                    left: 30,
                                    child: Material(
                                      child: Container(
                                        height: 320,
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
                                  //description
                                  Positioned(
                                    top: 70,
                                    left: 60,
                                    width: 230,
                                    child: Text( 
                                          snapshot.data![index].description,
                                          style: TextStyle( fontSize: 13,
                                            fontWeight: FontWeight.normal, 
                                            color: Colors.black54   
                                          ),
                                          textAlign: TextAlign.left,
                                    ),
                                  ),
                                  //image
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
                                        height: 170,
                                        width: 240,
                                        decoration: BoxDecoration(
                                          color: Colors.pink[800],
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Image(
                                                  image: NetworkImage('$photoUrl/Markets/${snapshot.data![index].image}'),
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