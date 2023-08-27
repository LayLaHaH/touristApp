// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_flutter/pages/activities.dart';
import 'package:my_flutter/pages/home.dart';
import 'package:my_flutter/pages/foodPlaces.dart';
import 'package:my_flutter/pages/settings/addTour.dart';
import 'package:my_flutter/pages/settings/editTour.dart';
import 'package:my_flutter/pages/settings/tourSettings.dart';
import 'package:my_flutter/pages/shoppingPlaces.dart';
import 'package:my_flutter/pages/singleGov.dart';
import 'package:my_flutter/pages/stayPlaces.dart';
import 'package:my_flutter/pages/_tours.dart';


void main() => runApp(MaterialApp(
      
      debugShowCheckedModeBanner: false,
      initialRoute:'/',
      routes: {
        '/':(context) => Home(),
        '/tours':(context) => TourChoosing(),
        '/thingsToDo':(context) => ThingsToDo(),
        '/food':(context) => FoodPlaces(),
        '/stay':(context) => PlaceToStay(),
        '/shop':(context) => ShoppingPlaces(),
        '/tourSettings':(context) => TourSettings(),
        '/addTour':(context) => AddTour(),
        '/editTour':(context) => EditTour(),
        '/gov':(context) => SingleGov(),
      },
    ));
var base='http://192.168.94.178:45455';
var baseUrl='$base/api';  
var photoUrl='$base/img';

