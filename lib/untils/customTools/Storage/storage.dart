import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Storage {
  Future<String> get _localPath async {
    final _path = await getTemporaryDirectory();
    return _path.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      var contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      return 0;
    }
  }

  Future<File> writeCounter(counter) async {
    final file = await _localFile;

    return file.writeAsString('$counter');
  }
}

class OnePage extends StatefulWidget {
  final Storage storage;

  OnePage({this.storage});

  @override
  _OnePageState createState() => _OnePageState();
}

class _OnePageState extends State<OnePage> {
  int _counter;

  @override
  void initState() {
    super.initState();
    widget.storage.readCounter().then((value) {
      setState(() => _counter = value);
    });
  }

  Future<File> _incrementCounter() async {
    setState(() => _counter++);
    return widget.storage.writeCounter(_counter);
  }

  Future<File> _incrementCounterj() async {
    setState(() => _counter--);
    return widget.storage.writeCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '$_counter',
          style: Theme.of(context).textTheme.display1,
        ),
      ),
      floatingActionButton: Row(
        children: <Widget>[
          FloatingActionButton(
            onPressed: () => _incrementCounter(),
            child: new Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () => _incrementCounterj(),
            child: new Icon(Icons.title),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}