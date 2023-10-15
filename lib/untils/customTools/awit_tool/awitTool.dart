import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AwitTool extends StatefulWidget {
  @override
  _AwitToolState createState() => _AwitToolState();
}

class _AwitToolState extends State<AwitTool> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 0.5),
      alignment: Alignment.center,
      child: Container(
        height: ScreenUtil().setHeight(50),
        width: ScreenUtil().setHeight(50),
        child: new CircularProgressIndicator(
          strokeWidth: 4.0,
          backgroundColor: Colors.grey,
          // value: 0.2,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }
}
