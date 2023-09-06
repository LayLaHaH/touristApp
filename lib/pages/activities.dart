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
  const ThingsToDo({Key? key}) : super(key: key);

  @override
  State<ThingsToDo> createState() => _ThingsToDoState();
}

class _ThingsToDoState extends State<ThingsToDo> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _priceController = TextEditingController();
  }

  Future<List<Activity>> getRequest() async {
    // Make a get request to fetch the activities from the API
    final response = await http.get(Uri.parse('$baseUrl/Activity/getAll'));
    var responseData = json.decode(response.body);

    List<Activity> activities = [];
    for (var gov in responseData) {
      try {
        Activity activity = Activity.fromJson(gov);
        activities.add(activity);
      } catch (e) {
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
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(children: <Widget>[
            TopPictureAndDescription(label: "Activities", description: ""),
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
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price',
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
              height: 450,
              child: FutureBuilder<List<Activity>>(
                future: getRequest(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final tours = snapshot.data!;
                    final nameQuery = _nameController.text.toLowerCase() ?? '';
                    final priceQuery =
                        double.tryParse(_priceController.text)?.toDouble() ??
                            double.infinity;
                    final filteredTours = tours.where((tour) {
                      return tour.name.toLowerCase().contains(nameQuery) &&
                          tour.price <= priceQuery;
                    }).toList();
                    return ListView.builder(
                      itemCount: filteredTours.length,
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
                                  filteredTours[index].name,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              //number
                              Positioned(
                                  top: 50,
                                  left: 60,
                                  width: 230,
                                  child: cardText(
                                      label: "Opening hours : ",
                                      description:
                                          "from ${filteredTours[index].startTime.hour} to ${(filteredTours[index].closeTime.hour)}")),
                              Positioned(
                                  top: 70,
                                  left: 60,
                                  width: 230,
                                  child: cardText(
                                      label: "Oppening days : ",
                                      description:
                                          "from ${filteredTours[index].startingDay?.day} to ${filteredTours[index].endingDay?.day}")),
                              Positioned(
                                top: 100,
                                left: 60,
                                width: 230,
                                child: cardText(
                                  description: "${filteredTours[index].price} ",
                                  label: "Price : ",
                                ),
                              ),
                              Positioned(
                                  top: 120,
                                  left: 60,
                                  width: 230,
                                  child: cardText(
                                      label: "Description : ",
                                      description:
                                          filteredTours[index].description)),
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
                                          image: NetworkImage(
                                              '$photoUrl/Activities/${filteredTours[index].image}'),
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
            SizedBox(
              height: 10,
            ),
          ])),
    );
  }
}
