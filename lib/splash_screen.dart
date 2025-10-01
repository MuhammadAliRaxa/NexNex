import 'package:flutter/material.dart';
import 'package:flutter_application_2/custom_parent_widget.dart';
import 'package:flutter_application_2/web_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }
  void init()async{
    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CustomParentWidget(child: WebPage()),));
  }



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset("assets/splash.jpg"),
    );
  }
}