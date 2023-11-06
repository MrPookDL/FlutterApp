import 'package:flutter/material.dart';
import 'package:projet_final/data/authentification.dart';
import 'package:projet_final/view/login_page.dart';
import 'package:projet_final/view/page_principale.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChange,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const PagePrincipale();
          } else {
            return const LoginPage();
          }
        });
  }
}
