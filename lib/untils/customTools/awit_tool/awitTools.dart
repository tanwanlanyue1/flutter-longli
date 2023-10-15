import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class AwitTools extends StatefulWidget {
  @override
  _AwitToolsState createState() => _AwitToolsState();
}

class _AwitToolsState extends State<AwitTools> {
  @override
  Widget build(BuildContext context) {
    return Container(
//      color: Colors.white,
      alignment: Alignment.center,
      width: double.infinity,
      child: Container(
        width: double.infinity,
        child:Image.asset('images/setting/loading.gif'),
      ),
    );
  }
}
