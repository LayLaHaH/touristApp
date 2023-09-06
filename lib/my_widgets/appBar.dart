// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:my_flutter/providers/token.dart';
import 'package:provider/provider.dart';

import '../providers/isVisible.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.pink[800],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
      title: TextButton(
        onPressed: () {
          if (Provider.of<IsVisible>(context, listen: false).isVisible) {
            Navigator.pushNamed(context, '/');
          } else {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
        //onHover: ,
        child: Text('SYRTRAV',
            style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
      centerTitle: true,
      actions: [
        Visibility(
            visible: Provider.of<IsVisible>(context, listen: false).isVisible,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: IconButton(
                icon: Icon(Icons.login),
                onPressed: () {
                  Provider.of<IsVisible>(context, listen: false)
                      .updateToken(false);
                  Provider.of<Token>(context, listen: false)
                      .updateToken("false");
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            )),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
