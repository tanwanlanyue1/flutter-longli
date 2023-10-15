import 'package:flutter/material.dart';

class pageSetupPage extends StatefulWidget {
  @override
  _pageSetupPageState createState() => _pageSetupPageState();
}

class _pageSetupPageState extends State<pageSetupPage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: <Widget>[

        ],
      ),
    );
  }
}
