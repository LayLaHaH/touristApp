// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_flutter/models/tour.dart';
import 'package:my_flutter/my_widgets/TopPictureAndDescription.dart';
import 'package:my_flutter/my_widgets/appBar.dart';
import 'package:my_flutter/my_widgets/my_drawer.dart';

import '../main.dart';
import '../my_widgets/TourCollapsable.dart';
import '../my_widgets/cardText.dart';
import 'package:http/http.dart' as http;

class TourChoosing extends StatefulWidget {
  const TourChoosing({super.key});

  @override
  State<TourChoosing> createState() => _TourChoosingState();
}

class _TourChoosingState extends State<TourChoosing> {
  late TextEditingController _nameController;
  late TextEditingController _themeController;
  late TextEditingController _privacyController;
  late TextEditingController _costController;
  late TextEditingController _guidLanguageController;
  late TextEditingController _numDaysController;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _themeController = TextEditingController();
    _privacyController = TextEditingController();
    _costController = TextEditingController();
    _guidLanguageController = TextEditingController();
    _numDaysController = TextEditingController();
  }

  Future<List<Tour>> getRequest() async {
    // Make a get request to the records from the API
    final response = await http.get(Uri.parse('$baseUrl/Tour/getAll2'));
    var responseData = json.decode(response.body);

    List<Tour> tours = [];
    for (var gov in responseData) {
      try {
        Tour tour = Tour.fromJson(gov);
        tours.add(tour);
        var inc = tour.includes;
      } catch (e) {
        debugPrint(e as String?);
      }
    }
    return tours;
  }

  Future<List<String>> getDestinationPictures(int? id) async {
    final response =
        await http.get(Uri.parse('$baseUrl/Tour/$id/destination-pictures'));

    if (response.statusCode == 200) {
      final List<dynamic> pictureNames = json.decode(response.body);
      return pictureNames.map((name) => name.toString()).toList();
    } else {
      throw Exception('Failed to fetch destination pictures');
    }
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
        child: Column(
          children: <Widget>[
            TopPictureAndDescription(label: "Tours", description: ""),
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
                      controller: _costController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Cost',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _guidLanguageController,
                      decoration: InputDecoration(
                        labelText: 'Guid Language',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _numDaysController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Number of Days',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Privacy',
                          border: OutlineInputBorder(),
                        ),
                        value: _privacyController.text.isNotEmpty
                            ? _privacyController.text
                            : null,
                        items: [
                          DropdownMenuItem(
                            value: 'In a group',
                            child: Text('In a group'),
                          ),
                          DropdownMenuItem(
                            value: 'Private',
                            child: Text('Private'),
                          ),
                        ],
                        onChanged: (value) {
                          _privacyController.text = value!;
                          ;
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _themeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Theme',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: Text('Search'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFC2185B),
              ),
            ),
            SizedBox(
              height: 520,
              child: FutureBuilder<List<Tour>>(
                future: getRequest(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Tour> filteredTours = snapshot.data!;
                    if (_nameController.text.isNotEmpty) {
                      filteredTours = filteredTours
                          .where((tour) => tour.name
                              .toLowerCase()
                              .contains(_nameController.text.toLowerCase()))
                          .toList();
                    }
                    if (_themeController.text.isNotEmpty) {
                      filteredTours = filteredTours
                          .where((tour) => tour.theme
                              .toLowerCase()
                              .contains(_themeController.text.toLowerCase()))
                          .toList();
                    }
                    if (_numDaysController.text.isNotEmpty) {
                      filteredTours = filteredTours
                          .where((tour) => tour.daysNnights
                              .toLowerCase()
                              .contains(_numDaysController.text.toLowerCase()))
                          .toList();
                    }
                    if (_privacyController.text.isNotEmpty) {
                      filteredTours = filteredTours
                          .where((tour) =>
                              tour.isPrivate.toString() ==
                              (_privacyController.text == 'Private').toString())
                          .toList();
                    }
                    if (_costController.text.isNotEmpty) {
                      filteredTours = filteredTours
                          .where((tour) =>
                              tour.cost <= int.parse(_costController.text))
                          .toList();
                    }
                    if (_guidLanguageController.text.isNotEmpty) {
                      filteredTours = filteredTours
                          .where((tour) => tour.guidLanguage
                              .toLowerCase()
                              .contains(
                                  _guidLanguageController.text.toLowerCase()))
                          .toList();
                    }
                    return ListView.builder(
                      itemCount: filteredTours.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) => Column(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/tour',
                                    arguments: filteredTours[index]);
                              },
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
                                        filteredTours[index].name,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black54),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    //number of days
                                    Positioned(
                                        top: 70,
                                        left: 60,
                                        width: 230,
                                        child: cardText(
                                            label: "Number of days : ",
                                            description: filteredTours[index]
                                                .daysNnights)),
                                    //theme
                                    Positioned(
                                        top: 90,
                                        left: 60,
                                        width: 230,
                                        child: cardText(
                                            label: "Theme : ",
                                            description:
                                                filteredTours[index].theme)),
                                    //cost
                                    Positioned(
                                      top: 120,
                                      left: 60,
                                      width: 230,
                                      child: cardText(
                                        description:
                                            "${filteredTours[index].cost} ",
                                        label: "Cost : ",
                                      ),
                                    ),
                                    //isPrivate
                                    Positioned(
                                        top: 140,
                                        left: 60,
                                        width: 230,
                                        child: cardText(
                                            label: "Privacy : ",
                                            description:
                                                " ${filteredTours[index].isPrivate == true ? "Private" : "In a group"}")),
                                    //guid
                                    Positioned(
                                        top: 160,
                                        left: 60,
                                        width: 230,
                                        child: cardText(
                                            label: "Languages of guids : ",
                                            description: filteredTours[index]
                                                .guidLanguage)),
                                    //images
                                    Positioned(
                                        top: 200,
                                        left: 35,
                                        child: FutureBuilder(
                                            future: getDestinationPictures(
                                                filteredTours[index].id),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return SizedBox(
                                                  width: 280,
                                                  height: 200,
                                                  child: ListView.builder(
                                                    itemCount:
                                                        snapshot.data?.length,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                                int index) =>
                                                            Card(
                                                      elevation: 10,
                                                      shadowColor: Colors.grey
                                                          .withOpacity(0.5),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      child: Container(
                                                        height: 10,
                                                        width: 240,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.pink[800],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Image(
                                                            image: NetworkImage(
                                                                '$photoUrl/Destinations/${snapshot.data![index]}' ??
                                                                    '$photoUrl/Destinations/Homs.jpg'),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Error loading data');
                                              } else {
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }
                                            })),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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
