import 'package:flutter/material.dart';
import 'package:flutter_widget_one/untils/element/CustomList/BrandCustom.dart';
import 'package:flutter_widget_one/untils/element/CustomList/structure.dart';
import 'package:flutter_widget_one/untils/element/test2.dart';
import 'package:flutter_widget_one/untils/element/tests.dart';
class ListTest extends StatefulWidget {
  @override
  _ListTestState createState() => _ListTestState();
}

class _ListTestState extends State<ListTest> {
  String seachTitle = '1216674366131462145';//搜
  String _BrandCustomID = '1211960880233840642';//搜
  final TextEditingController _newPassword = TextEditingController();//新密码
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('测试'),),
      body:  Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
             width: double.infinity,
             height: 50,
             alignment: Alignment.center,
             child:  InkWell(
               child: Text('测试'),
               onTap: (){
                 Navigator.push(context, MaterialPageRoute(builder: (_) {
                   return tests();
                 }));
               },
             ),
           ),
            Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              child:  InkWell(
                child: Text('自定义装修页运营调试'),
                onTap: (){
                  showDialog<Null>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return new AlertDialog(
                        title: new Text('自定义装修页Id'),
                        content: new SingleChildScrollView(
                          child: new ListBody(
                            children: <Widget>[
                              _search()
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text('确定'),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) {return Structure(seachTitle: seachTitle,);}));
                            },
                          ),
                          new FlatButton(
                            child: new Text('取消'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  ).then((val) {
                    print(val);
                  });
                },
              ),
            ),

            Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              child:  InkWell(
                child: Text('品牌装修页运营调试'),
                onTap: (){
                  showDialog<Null>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return new AlertDialog(
                        title: new Text('品牌装修页Id'),
                        content: new SingleChildScrollView(
                          child: new ListBody(
                            children: <Widget>[
                              _search2()
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text('确定'),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) {return BrandCustom(BrandCustomID: _BrandCustomID,);}));
                            },
                          ),
                          new FlatButton(
                            child: new Text('取消'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  ).then((val) {
                    print(val);
                  });
                },
              ),
            ),
            Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              child:  InkWell(
                child: Text('测试2'),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) {return HomePage();}));//HomePage
                    },
              ),
            )
          ],
        ),
      )
    );
  }
  Widget _search(){
    return Container(
      height: 80,
      child: Row(
        children: <Widget>[
          Container(
            height: 50,
            width:180,
            child:  TextField(
              controller: _newPassword,
             keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "自定义装修页面id",
              ),
              onChanged: (v){
                setState(() {
                  seachTitle = v;
                });
              },
            ),
          ),
          InkWell(
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _search2(){
    return Container(
      height: 80,
      child: Row(
        children: <Widget>[
          Container(
            height: 50,
            width:180,
            child:  TextField(
              controller: _newPassword,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "品牌装修页面id",
              ),
              onChanged: (v){
                setState(() {
                  _BrandCustomID = v;
                });
              },
            ),
          ),
          InkWell(
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: (){
              },
            ),
          )
        ],
      ),
    );
  }

}
