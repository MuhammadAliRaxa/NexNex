import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class CustomParentWidget extends StatelessWidget {

  final Widget? child;

  const CustomParentWidget({this.child, super.key});


  @override
  Widget build(BuildContext context) {
    late MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return MediaQuery(
      data: queryData.copyWith(textScaleFactor: 1.0),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Color for Android
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        sized: false,
        child: child ?? const SizedBox(),
      ),
    );
  }
}
