// ignore_for_file: prefer_const_constructors, file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_flutter/models/market.dart';
import 'package:my_flutter/my_widgets/TopPictureAndDescription.dart';
import 'package:my_flutter/my_widgets/appBar.dart';
import 'package:my_flutter/my_widgets/my_drawer.dart';

import '../main.dart';
import '../my_widgets/cardText.dart';
import '../my_widgets/leftSideAddress.dart';
import 'package:http/http.dart' as http;

class ShoppingPlaces extends StatefulWidget {
  const ShoppingPlaces({super.key});

  @override
  State<ShoppingPlaces> createState() => _ShoppingPlacesState();
}

class _ShoppingPlacesState extends State<ShoppingPlaces> {
  late Future<List<Market>> markets;
  late TextEditingController _nameController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    markets = getRequest();
  }

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
            TopPictureAndDescription(label: "Markets (Souks)", description: ""),
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
                child: FutureBuilder<List<Market>>(
                  future: getRequest(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Market>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<Market> filteredMarkets = snapshot.data!;
                      if (_nameController.text.isNotEmpty) {
                        filteredMarkets = filteredMarkets
                            .where((market) => market.name
                                .toLowerCase()
                                .contains(_nameController.text.toLowerCase()))
                            .toList();
                      }
                      if (_addressController.text.isNotEmpty) {
                        filteredMarkets = filteredMarkets
                            .where((market) => market.address
                                .toLowerCase()
                                .contains(
                                    _addressController.text.toLowerCase()))
                            .toList();
                      }
                      return SizedBox(
                        height: 540,
                        child: ListView.builder(
                          itemCount: filteredMarkets.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) =>
                              GestureDetector(
                            onTap: () {},
                            child: SizedBox(
                              height: 380,
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
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
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
                                      filteredMarkets[index].name,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Positioned(
                                      top: 70,
                                      left: 60,
                                      width: 230,
                                      child: cardText(
                                          label: "Address : ",
                                          description:
                                              filteredMarkets[index].address)),
                                  //description
                                  Positioned(
                                    top: 130,
                                    left: 60,
                                    width: 230,
                                    height: 70,
                                    child: SingleChildScrollView(
                                      physics: ClampingScrollPhysics(),
                                      child: Text(
                                        "Description :   ${filteredMarkets[index].description}",
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
                                      bottom: 0,
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
                                                  '$photoUrl/Markets/${filteredMarkets[index].image}'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                )),
            SizedBox(
              height: 10,
            ),
          ])),
    );
  }
}
