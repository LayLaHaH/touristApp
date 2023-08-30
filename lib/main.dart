// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_flutter/pages/registration/Register.dart';
import 'package:my_flutter/pages/activities.dart';
import 'package:my_flutter/pages/home.dart';
import 'package:my_flutter/pages/foodPlaces.dart';
import 'package:my_flutter/pages/registration/login.dart';
import 'package:my_flutter/pages/managingTours/addTour.dart';
import 'package:my_flutter/pages/registration/add_company.dart';
import 'package:my_flutter/pages/managingTours/editTour.dart';
import 'package:my_flutter/pages/managingTours/tourSettings.dart';
import 'package:my_flutter/pages/shoppingPlaces.dart';
import 'package:my_flutter/pages/singleGov.dart';
import 'package:my_flutter/pages/singleTour.dart';
import 'package:my_flutter/pages/stayPlaces.dart';
import 'package:my_flutter/pages/_tours.dart';
import 'package:my_flutter/providers/CompanyId.dart';
import 'package:my_flutter/providers/UserId.dart';
import 'package:my_flutter/providers/isVisible.dart';
import 'package:my_flutter/providers/token.dart';
import 'package:provider/provider.dart';


void main() => runApp(MultiProvider(
   providers: [
      ChangeNotifierProvider(create: (_) => Token()),
      ChangeNotifierProvider(create: (_) => UserID()),
      ChangeNotifierProvider(create: (_) => CompanyID()),
      ChangeNotifierProvider(create: (_) => IsVisible()),
    ],
  child:   MaterialApp(
  
        
  
        debugShowCheckedModeBanner: false,
  
        initialRoute:'/',
  
        routes: {
  
          '/':(context) => Home(),
  
          '/tours':(context) => TourChoosing(),
          '/thingsToDo':(context) => ThingsToDo(),
          '/food':(context) => FoodPlaces(),
          '/stay':(context) => PlaceToStay(),
          '/shop':(context) => ShoppingPlaces(),
  
          '/gov':(context) => SingleGov(),

          '/tour':(context) => SingleTour(),

  
          '/login':(context) => Login(),
          '/register':(context) => Register(),
          '/addCompany':(context) => AddCompany(),


          '/tourSettings':(context) => TourSettings(),
          '/addTour':(context) => AddTour(),
          '/editTour':(context) => EditTour(),
  
        },
  
      ),
));
var base='http://192.168.94.178:45455';
var baseUrl='$base/api';  
var photoUrl='$base/img';
var neww=false;

