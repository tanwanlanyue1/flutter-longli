import 'package:flutter/material.dart';

import '../../common/model/provider_vital.dart';
import 'package:provider/provider.dart';

class HomeData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _vitalModels = Provider.of<VitalModel>(context);
    return Scaffold(
        appBar: AppBar(title: Text('2'),),
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: Text("${_vitalModels.PrototypeDatas}",textAlign: TextAlign.left,),
            )
          ],
        )
    );
  }
}

