// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables, use_build_context_synchronously



import 'package:flutter/material.dart';
import 'package:my_flutter/models/tour.dart';
import 'package:my_flutter/my_widgets/appBar.dart';
import 'package:my_flutter/my_widgets/my_drawer.dart';
import 'package:my_flutter/pages/settings/deleteConfirmation.dart';

import '../../main.dart';
import '../../my_widgets/leftSideAddress.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class TourSettings extends StatefulWidget {
  const TourSettings({super.key});

  @override
  State<TourSettings> createState() => _TourSettingsState();
}

class _TourSettingsState extends State<TourSettings> {
  
  bool deleteFlag =false;
  

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


  void deleteAlert(int? id) async {
    final results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirmation();
      },
    );
    // Update UI
    if (results != null && results == true) {
      final response = await http.delete(Uri.parse('$baseUrl/Tour/delete?id=$id'));
      if (response.statusCode == 200) {
          Navigator.pushReplacementNamed(context,'/tourSettings'); 
      } else {
        debugPrint("an error accured when deleting this item");
      }
    }
  }

  /*  @override
  void initState() {
    super.initState();
    getRequest();
    
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
              Padding(
                padding: const EdgeInsets.fromLTRB(140,10,0,0),
                child: LeftSideAddress(title:'Tour Settings', fontSize: 20.0,),
              ),
              //add button
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: (){Navigator.pushNamed(context, '/addTour');},
                  child: Container(
                    height: 50.0,
                    margin: EdgeInsets.all(10),
                    child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color.fromARGB(255, 160, 6, 73), Color.fromARGB(255, 238, 139, 172)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Container(
                          constraints:
                              BoxConstraints(maxWidth: 150.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15,0,0,0),
                            child: Row(
                              children: [
                                Icon(Icons.add,color: Colors.white,),
                                Text(
                                  "Add new tour",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 15),
                                ),
                                
                              ],
                            ),
                          ),
                        ),
                      ),
                  ),
                ),
              ),
              //search
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search by name...',
                  prefixIcon: Icon(Icons.search,color: Colors.pink[800],),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              //the items
               Container(
                  height: 40,
                  color: Color.fromARGB(31, 165, 146, 146),
                  child: Row(  
                    children: [
                      Expanded(flex: 1, child: Text('   ID')),
                      Expanded(flex: 2, child: Text('Name')),
                      Expanded(flex: 2, child: Text('number of days')),
                      Expanded(flex: 2, child: Text('Actions')),
                    ],
                  ),
                ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: FutureBuilder<List<Tour>>(
                        future: getRequest(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return 
                                ListView.builder(
                                itemCount: snapshot.data!.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index) =>
                                Container(
                                  height: 80,
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Row(
                                    children: [
                                      Expanded(flex: 1,child: Text(snapshot.data![index].id.toString()),),
                                      Expanded(flex: 2,child: Text(snapshot.data![index].name) ),
                                      Expanded(flex: 2, child: Text(snapshot.data![index].daysNnights)),
                                      Expanded(flex: 2,child:Row(
                                        children: [
                                          IconButton( icon: Icon(Icons.edit,color: Color.fromARGB(255, 206, 134, 34),),
                                            onPressed: (){Navigator.pushNamed(context, '/editTour',arguments: snapshot.data![index]);},),
                                          IconButton( icon: Icon(Icons.delete,color: const Color.fromARGB(255, 233, 31, 16),),
                                            onPressed:  () => deleteAlert(snapshot.data![index].id)),
                                        ],
                                       )
                                      ),
                                    ],
                                  ),
                                )
                              );
                          }
                           else if (snapshot.hasError) {
                            return Text('Error loading data : ${snapshot.error}');
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }
                        )
              )
          ]
          )
          )
          );
  }
}