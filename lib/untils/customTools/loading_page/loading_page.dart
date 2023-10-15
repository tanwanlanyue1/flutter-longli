import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
//加载页
class LoadingTools extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitCubeGrid(size: 51.0, color: Colors.grey),
    );
  }
}
