//import 'dart:convert';
// ignore_for_file: library_private_types_in_public_api, prefer_typing_uninitialized_variables, prefer_const_constructors, use_build_context_synchronously



import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter/providers/UserId.dart';
import 'package:provider/provider.dart';
import '../../main.dart';

class AddCompany extends StatefulWidget {
  const AddCompany({super.key});

  @override
  _AddCompanyState createState() => _AddCompanyState();
}

class _AddCompanyState extends State<AddCompany> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _addressController = TextEditingController();


  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Send the photo bytes to the API
     
      //sending the create request
       final response1 = await http.post(
        Uri.parse('$baseUrl/TourCompany/create'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: <String, String>{
          'name': _nameController.text,
          'contactNumber': _numberController.text,
          'address':_addressController.text,
          'userId':Provider.of<UserID>(context, listen: false).userID,
        },
      );
      if (response1.statusCode == 200) {
        debugPrint('success');
        Navigator.pushReplacementNamed(context,'/');
      } else {
        debugPrint('Error creating company: ${response1.reasonPhrase}');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Company')),
      body: ListView(
        children:[ Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SizedBox(
              width: 500,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a name.';
                        }
                        return null;
                      },
                    ),
                    //number
                    TextFormField(
                      controller: _numberController,
                      decoration: const InputDecoration(labelText: 'Contact Number'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the contact number.';
                        }
                        return null;
                      },
                    ),
                    //address
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: 'Address'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the address.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16,),  
                    ElevatedButton(
                      onPressed: _submitForm ,
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),]
      ),
    );
  }
}