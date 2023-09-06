// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, non_constant_identifier_names, file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_flutter/main.dart';
import 'package:my_flutter/models/governorate.dart';
import 'package:my_flutter/my_widgets/TopPictureAndDescription.dart';

import '../models/hotel.dart';
import '../models/market.dart';
import 'package:http/http.dart' as http;

import '../models/restaurant.dart';
import '../my_widgets/appBar.dart';
import '../my_widgets/cardText.dart';
import '../my_widgets/leftSideAddress.dart';
import '../my_widgets/my_drawer.dart';

class SingleGov extends StatefulWidget {
  const SingleGov({super.key});

  @override
  State<SingleGov> createState() => _SingleGovState();
}

class _SingleGovState extends State<SingleGov> {
  late var ID;

  Future<List<Market>> getMarketsByGovernorate(int id) async {
    final response = await http
        .get(Uri.parse('$baseUrl/Governorate/governorates/$id/markets'));
    print(neww);
    if (response.statusCode == 200) {
      final List<dynamic> marketsJson = json.decode(response.body);
      return marketsJson.map((json) => Market.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load markets');
    }
  }

  Future<List<Restaurant>> getRestaurantsByGovernorate(int id) async {
    final response = await http
        .get(Uri.parse('$baseUrl/Governorate/governorates/$id/restaurants'));

    if (response.statusCode == 200) {
      final List<dynamic> restaurantsJson = json.decode(response.body);
      return restaurantsJson.map((json) => Restaurant.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load restaurants');
    }
  }

  Future<List<Hotel>> getHotelsByGovernorate(int id) async {
    final response = await http
        .get(Uri.parse('$baseUrl/Governorate/governorates/$id/hotels'));

    if (response.statusCode == 200) {
      final List<dynamic> hotelsJson = json.decode(response.body);
      return hotelsJson.map((json) => Hotel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load hotels');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Governorate gov =
        ModalRoute.of(context)!.settings.arguments as Governorate;
    ID = gov.id;
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(),
      drawer: myDrawer(),
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(children: <Widget>[
            TopPictureAndDescription(label: gov.name, description: ""),
            SizedBox(
              height: 10,
            ),
            LeftSideAddress(
              title: 'Markets (Souks)',
              fontSize: 20.0,
            ),
            SizedBox(
              height: 410,
              child: FutureBuilder<List<Market>>(
                future: getMarketsByGovernorate(ID),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      scrollDirection: Axis.horizontal,
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
                              //name
                              Positioned(
                                top: 40,
                                left: 60,
                                child: Text(
                                  snapshot.data![index].name,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              //address
                              Positioned(
                                  top: 70,
                                  left: 60,
                                  width: 230,
                                  child: cardText(
                                      label: "Address : ",
                                      description:
                                          snapshot.data![index].address)),
                              //description
                              Positioned(
                                top: 130,
                                left: 60,
                                width: 230,
                                height: 70,
                                child: SingleChildScrollView(
                                  physics: ClampingScrollPhysics(),
                                  child: Text(
                                    'Description :   ${snapshot.data![index].description}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black54,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
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
                                          image: NetworkImage(
                                              '$photoUrl/Markets/${snapshot.data![index].image}'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )),
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
            LeftSideAddress(
              title: 'Restaurants',
              fontSize: 20.0,
            ),
            SizedBox(
              height: 420,
              child: FutureBuilder<List<Restaurant>>(
                future: getRestaurantsByGovernorate(ID),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      scrollDirection: Axis.horizontal,
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
                                    height: 350,
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
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              //number
                              Positioned(
                                  top: 70,
                                  left: 60,
                                  width: 230,
                                  child: cardText(
                                      label: "Contact number : ",
                                      description:
                                          snapshot.data![index].contacNumber)),
                              Positioned(
                                  top: 90,
                                  left: 60,
                                  width: 230,
                                  child: cardText(
                                      label: "URL : ",
                                      description:
                                          "${snapshot.data![index].url}")),
                              Positioned(
                                top: 110,
                                left: 60,
                                width: 230,
                                child: cardText(
                                  description:
                                      "${snapshot.data![index].classStar} Stars ",
                                  label: "Stars : ",
                                ),
                              ),
                              Positioned(
                                  top: 130,
                                  left: 60,
                                  width: 230,
                                  child: cardText(
                                      label: "Cuisine : ",
                                      description:
                                          snapshot.data![index].cuisine)),
                              Positioned(
                                  top: 150,
                                  left: 60,
                                  width: 230,
                                  child: cardText(
                                      label: "Oppening hours : ",
                                      description:
                                          "from ${snapshot.data![index].openingHour.hour} to ${snapshot.data![index].closingHour.hour}")),
                              Positioned(
                                  top: 170,
                                  left: 60,
                                  width: 230,
                                  child: cardText(
                                      label: "Address : ",
                                      description:
                                          snapshot.data![index].address)),
                              //image
                              Positioned(
                                  top: 220,
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
                                          image: NetworkImage(
                                              '$photoUrl/Restaurants/${snapshot.data![index].image}'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )),
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
            LeftSideAddress(
              title: 'Hotles ',
              fontSize: 20.0,
            ),
            SizedBox(
              height: 390,
              child: FutureBuilder<List<Hotel>>(
                future: getHotelsByGovernorate(ID),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      scrollDirection: Axis.horizontal,
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
                                  snapshot.data![index].name,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              //number
                              Positioned(
                                  top: 70,
                                  left: 60,
                                  width: 230,
                                  child: cardText(
                                      label: "Contact number : ",
                                      description:
                                          snapshot.data![index].contacNumber)),
                              //url
                              Positioned(
                                  top: 95,
                                  left: 60,
                                  width: 230,
                                  child: cardText(
                                      label: "URL : ",
                                      description: snapshot.data![index].url)),
                              //stars
                              Positioned(
                                top: 120,
                                left: 60,
                                width: 230,
                                child: cardText(
                                  description:
                                      "${snapshot.data![index].classStar} Stars ",
                                  label: "Class Stars : ",
                                ),
                              ),
                              //address
                              Positioned(
                                  top: 145,
                                  left: 60,
                                  width: 230,
                                  child: cardText(
                                      label: "Address : ",
                                      description:
                                          snapshot.data![index].address)),
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
                                          image: NetworkImage(
                                              '$photoUrl/Hotels/${snapshot.data![index].image}'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )),
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
          ])),
    );
  }
}
