// ignore_for_file: prefer_const_constructors, camel_case_types, prefer_typing_uninitialized_variables, file_names

import 'package:flutter/material.dart';

class cardText extends StatelessWidget {
  final label;
  final description;
  const cardText({
    super.key,
    required this.description,
    required this.label
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
        children: <TextSpan>[
          TextSpan(
            text: description,
            style: TextStyle(
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.left,
    );
  }
}