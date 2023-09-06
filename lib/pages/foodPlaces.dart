// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_flutter/models/restaurant.dart';
import 'package:my_flutter/my_widgets/TopPictureAndDescription.dart';
import 'package:my_flutter/my_widgets/appBar.dart';
import 'package:my_flutter/my_widgets/my_drawer.dart';

import '../main.dart';
import '../my_widgets/cardText.dart';
import '../my_widgets/leftSideAddress.dart';
import 'package:http/http.dart' as http;

class FoodPlaces extends StatefulWidget {
  const FoodPlaces({super.key});

  @override
  State<FoodPlaces> createState() => _FoodPlacesState();
}

class _FoodPlacesState extends State<FoodPlaces> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _cuisineController;
  late TextEditingController _classStarController;
  late TextEditingController _timeController;

  Future<List<Restaurant>> getRequest() async {
    // Make a get request to fetch the restaurants from the API
    final response = await http.get(Uri.parse('$baseUrl/Restaurant/getAll'));
    var responseData = json.decode(response.body);

    List<Restaurant> restaus = [];
    for (var gov in responseData) {
      try {
        Restaurant restau = Restaurant.fromJson(gov);
        restaus.add(restau);
      } catch (e) {
        debugPrint(e as String?);
      }
    }
    return restaus;
  }

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _cuisineController = TextEditingController();
    _classStarController = TextEditingController();
    _timeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(),
      drawer: myDrawer(),
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(children: <Widget>[
            TopPictureAndDescription(label: "Restaurants", description: ""),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _cuisineController,
                      decoration: InputDecoration(
                        labelText: 'Cuisine',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _classStarController,
                      decoration: InputDecoration(
                        labelText: 'Class Star',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 70, 0),
                      child: TextField(
                        controller: _timeController,
                        decoration: InputDecoration(
                          labelText: 'Time',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 60, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: Text('Search'),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFC2185B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 540,
              child: FutureBuilder<List<Restaurant>>(
                future: getRequest(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Restaurant> filteredRestaurants = snapshot.data!;
                    if (_nameController.text.isNotEmpty) {
                      filteredRestaurants = filteredRestaurants
                          .where((restaurant) => restaurant.name
                              .toLowerCase()
                              .contains(_nameController.text.toLowerCase()))
                          .toList();
                    }
                    if (_addressController.text.isNotEmpty) {
                      filteredRestaurants = filteredRestaurants
                          .where((restaurant) => restaurant.address
                              .toLowerCase()
                              .contains(_addressController.text.toLowerCase()))
                          .toList();
                    }
                    if (_cuisineController.text.isNotEmpty) {
                      filteredRestaurants = filteredRestaurants
                          .where((restaurant) => restaurant.cuisine
                              .toLowerCase()
                              .contains(_cuisineController.text.toLowerCase()))
                          .toList();
                    }
                    if (_classStarController.text.isNotEmpty) {
                      filteredRestaurants = filteredRestaurants
                          .where((restaurant) => restaurant.classStar
                              .toString()
                              .toLowerCase()
                              .contains(
                                  _classStarController.text.toLowerCase()))
                          .toList();
                    }
                    if (_timeController.text.isNotEmpty) {
                      filteredRestaurants = filteredRestaurants
                          .where((restaurant) =>
                              restaurant.openingHour.hour <=
                                  int.parse(_timeController.text) &&
                              restaurant.closingHour.hour >=
                                  int.parse(_timeController.text))
                          .toList();
                    }
                    return ListView.builder(
                      itemCount: filteredRestaurants.length,
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
                                  filteredRestaurants[index].name,
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
                                      description: filteredRestaurants[index]
                                          .contacNumber)),
                              Positioned(
                                  top: 90,
                                  left: 60,
                                  width: 230,
                                  child: cardText(
                                      label: "URL : ",
                                      description:
                                          "${filteredRestaurants[index].url}")),
                              Positioned(
                                top: 110,
                                left: 60,
                                width: 230,
                                child: cardText(
                                    description:
                                        "${filteredRestaurants[index].classStar} Stars ",
                                    label: "Stars : "),
                              ),
                              Positioned(
                                  top: 130,
                                  left: 60,
                                  width: 230,
                                  child: cardText(
                                      label: "Cuisine : ",
                                      description:
                                          filteredRestaurants[index].cuisine)),
                              Positioned(
                                  top: 150,
                                  left: 60,
                                  width: 230,
                                  child: cardText(
                                      label: "Oppening hours : ",
                                      description:
                                          "from ${filteredRestaurants[index].openingHour.hour}:${filteredRestaurants[index].openingHour.minute} to ${filteredRestaurants[index].closingHour.hour}:${filteredRestaurants[index].closingHour.minute}")),
                              Positioned(
                                  top: 170,
                                  left: 60,
                                  width: 230,
                                  child: cardText(
                                      label: "Address : ",
                                      description:
                                          filteredRestaurants[index].address)),
                              //image
                              Positioned(
                                  top: 220,
                                  left: 15,
                                  child: Card(
                                    elevation: 10,
                                    shadowColor: Colors.grey.withOpacity(0.5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
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
                                              '$photoUrl/Restaurants/${filteredRestaurants[index].image}'),
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
