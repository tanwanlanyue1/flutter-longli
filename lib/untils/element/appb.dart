import 'package:flutter/material.dart';

class ListTitleBar extends StatefulWidget implements PreferredSizeWidget {

  final String _left;
  final String _right;

  ListTitleBar(this._left, this._right);

  @override
  State<StatefulWidget> createState() => new ListTitleBarState(_left, _right);

  @override
  Size get preferredSize { return new Size.fromHeight(20.0); }

}

class ListTitleBarState extends State<ListTitleBar> {

  String _leftTitle;
  String _rightTitle;

  ListTitleBarState(this._leftTitle, this._rightTitle);

  @override
  Widget build(BuildContext context) {

    return new Container(

      decoration: new BoxDecoration(
        color: Colors.redAccent,
        border: new Border.all(color: Colors.black),
      ),

      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[

          ///Left Column Title
          new Column(
            children: <Widget>[
              new Container(
                color: Colors.redAccent,
                padding: const EdgeInsets.all(10.0),
                child: new Text(_leftTitle,
                  style: new TextStyle(
                      color: Colors.white,
                      fontSize: 18.0
                  ),
                ),
              )
            ],
          ),

          ///Right Column Title
          new Column(
            children: <Widget>[
              new Container(
                color: Colors.redAccent,
                padding: const EdgeInsets.all(10.0),
                child: new Text(_rightTitle,
                  style: new TextStyle(
                      color: Colors.white,
                      fontSize: 18.0
                  ),
                ),
              )
            ],
          ),

        ],
      ),
    );

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

}