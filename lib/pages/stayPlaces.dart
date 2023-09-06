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

class PlaceToStay extends StatefulWidget {
  const PlaceToStay({super.key});

  @override
  State<PlaceToStay> createState() => _PlaceToStayState();
}

class _PlaceToStayState extends State<PlaceToStay> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _classStarController;

  Future<List<Hotel>> getRequest() async {
    // Make a get request to fetch the hotels from the API
    final response = await http.get(Uri.parse('$baseUrl/Hotel/getAll'));
    var responseData = json.decode(response.body);

    List<Hotel> hotels = [];
    for (var gov in responseData) {
      try {
        Hotel hotel = Hotel.fromJson(gov);
        hotels.add(hotel);
      } catch (e) {
        debugPrint(e as String?);
      }
    }
    return hotels;
  }

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _classStarController = TextEditingController();
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
            TopPictureAndDescription(label: "Hotels", description: ""),
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
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _classStarController,
                      decoration: InputDecoration(
                        labelText: 'Class/Star',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: Text('Search'),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFC2185B),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 540,
              child: FutureBuilder<List<Hotel>>(
                  future: getRequest(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Hotel>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<Hotel> filteredHotels = snapshot.data!;
                      if (_nameController.text.isNotEmpty) {
                        filteredHotels = filteredHotels
                            .where((hotel) => hotel.name
                                .toLowerCase()
                                .contains(_nameController.text.toLowerCase()))
                            .toList();
                      }
                      if (_addressController.text.isNotEmpty) {
                        filteredHotels = filteredHotels
                            .where((hotel) => hotel.address
                                .toLowerCase()
                                .contains(
                                    _addressController.text.toLowerCase()))
                            .toList();
                      }
                      if (_classStarController.text.isNotEmpty) {
                        filteredHotels = filteredHotels
                            .where((hotel) => hotel.classStar
                                .toString()
                                .toLowerCase()
                                .contains(
                                    _classStarController.text.toLowerCase()))
                            .toList();
                      }
                      return ListView.builder(
                          itemCount: filteredHotels.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            final hotel = filteredHotels[index];
                            return GestureDetector(
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
                                            borderRadius:
                                                BorderRadius.circular(0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
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
                                        hotel.name,
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
                                            description: hotel.contacNumber)),
                                    //url
                                    Positioned(
                                        top: 95,
                                        left: 60,
                                        width: 230,
                                        child: cardText(
                                            label: "URL : ",
                                            description: hotel.url)),
                                    //stars
                                    Positioned(
                                      top: 120,
                                      left: 60,
                                      width: 230,
                                      child: cardText(
                                          description:
                                              "${hotel.classStar} Stars ",
                                          label: "Class Stars : "),
                                    ),
                                    //address
                                    Positioned(
                                        top: 145,
                                        left: 60,
                                        width: 230,
                                        child: cardText(
                                            label: "Address : ",
                                            description: hotel.address)),
                                    //image
                                    Positioned(
                                      top: 200,
                                      left: 15,
                                      child: Card(
                                        elevation: 10,
                                        shadowColor:
                                            Colors.grey.withOpacity(0.5),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                          height: 170,
                                          width: 240,
                                          decoration: BoxDecoration(
                                            color: Colors.pink[800],
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image(
                                              image: NetworkImage(
                                                  '$photoUrl/Hotels/${snapshot.data![index].image}'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                  }),
            ),
          ])),
    );
  }
}
