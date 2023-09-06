// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:my_flutter/providers/CompanyId.dart';
import 'package:my_flutter/providers/UserId.dart';
import 'package:my_flutter/providers/isVisible.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';
import '../../my_widgets/appBar.dart';
import '../../my_widgets/my_drawer.dart';
import '../../providers/token.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> SignUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        var url = Uri.parse(
            '$baseUrl/Authentication/Register'); // Replace with the actual API endpoint

        var response = await http.post(
          url,
          body: {
            'Name': _nameController.text,
            'Email': _emailController.text, // Replace with the email
            'Password': _passwordController.text, // Replace with the password
          },
        );

        if (response.statusCode == 200) {
          // Request was successful
          var responseBody = response.body;

          // Parse the response body to get the token
          var parsedResponse = jsonDecode(responseBody);
          var token = parsedResponse['token'];

          Provider.of<Token>(context, listen: false).updateToken(token);

          var companyId = parsedResponse['companyId'];
          Provider.of<CompanyID>(context, listen: false).updateToken(companyId);

          Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

          var userId = decodedToken['Id'];
          Provider.of<UserID>(context, listen: false).updateToken(userId);

          Provider.of<IsVisible>(context, listen: false).updateToken(true);

          Navigator.pushNamed(context, '/addCompany');
        } else {
          // Request failed
          print('Request failed with status: ${response.body}');
        }
      } catch (e) {
        debugPrint("$e");
      }
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
            child: Column(children: <Widget>[
              SizedBox(
                width: 430,
                height: 700,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Stack(children: [
                    Positioned(
                        child: Image(
                      image: AssetImage('Assets/homeBG.jpg'),
                    )),
                    Positioned(
                      top: 220,
                      child: Container(
                        width: 430,
                        height: 420,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                          color: Color.fromARGB(255, 255, 255, 255),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 4,
                              offset: Offset(-10, 10),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
                          child: Form(
                            key: _formKey,
                            child: ListView(children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Register",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26),
                                  ),
                                  //name
                                  TextFormField(
                                    controller: _nameController,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      labelText: 'Name',
                                      labelStyle: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter the name';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16.0),
                                  //email
                                  TextFormField(
                                    controller: _emailController,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      labelStyle: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter the email';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16.0),
                                  //password
                                  TextFormField(
                                    controller: _passwordController,
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      labelStyle: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter the password';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16.0),
                                  //confirm
                                  TextFormField(
                                    controller: _confirmPasswordController,
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: 'Confirm Password',
                                      labelStyle: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter the confirmPassword';
                                      }
                                      if (_confirmPasswordController.text !=
                                          _passwordController.text) {
                                        return 'ConfirmPassword must be identical to password';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16.0),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      //shadowColor: Color.fromARGB(255, 76, 33, 145),
                                      backgroundColor: Colors.pink[800],
                                    ),
                                    onPressed: SignUp,
                                    child: Text(
                                      'Register',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ])));
  }
}
