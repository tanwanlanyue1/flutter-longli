import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../untils/listBox/listbox_page.dart';
import '../../untils/listBox/color_cards.dart';
import '../../untils/tools/pubClass/colors_tools.dart';
import '../../common/model/provider_vital.dart';
import 'listViewPage.dart';
import 'package:provider/provider.dart';

class CustomPage extends StatefulWidget {
  @override
  _CustomPageState createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _vitalModels = Provider.of<VitalModel>(context);
    return
//      Scaffold(
//      appBar: AppBar(
//        title: Text('${_vitalModels.PrototypeDatas['title']}'),
//        actions: <Widget>[
//          Builder(builder: (context) => GestureDetector(
//            child:Text('开启drawer'),
//            onTap: () => Scaffold.of(context).openEndDrawer(),
//          ),),
//
//        ],
//      ),body:
      Scaffold(
          body: SafeArea(
            child: Scaffold(
                appBar: AppBar(title: Text('${_vitalModels.PrototypeDatas['title']}'),),
                endDrawer: Container(
                  width: ScreenUtil().setWidth(600),
                  color: Colors.white,
                  child: ListboxPage(),
                ),
                body: Stack(
                  children: <Widget>[
                    Container(

                      child: ListViewPage(), //循环生成页面

                      color: _vitalModels
                          .PrototypeDatas["list"][0]["page"]["background"][0] == "#" ?
                      HexColor(_vitalModels
                          .PrototypeDatas["list"][0]["page"]["background"]) :
                      Color.fromRGBO(int.parse(
                          (_vitalModels
                              .PrototypeDatas["list"][0]["page"]["background"]).toString().split(',')[0]),
                          int.parse((_vitalModels
                              .PrototypeDatas["list"][0]["page"]["background"]).toString().split(',')[1]),
                          int.parse((_vitalModels
                              .PrototypeDatas["list"][0]["page"]["background"]).toString().split(',')[2]),
                          double.parse((_vitalModels
                              .PrototypeDatas["list"][0]["page"]["background"]).toString().split(',')[3])
                      ),
                    ),
                    _vitalModels.PrototypeDatas['list'][0]['items'].length > 0 ? Container()
                        : Positioned(
                      right: 0,
                      top: 200,
                      child:Builder(builder: (context) => GestureDetector(
                        child: Container(
                          color: Colors.grey,
                          width: ScreenUtil().setWidth(200),
                          height: ScreenUtil().setHeight(60),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.chevron_left),
                              Text("划动边缘试试",
                                style: TextStyle(fontSize: ScreenUtil().setSp(22)),),
                            ],
                          ),
                        ),
                        onTap: () => Scaffold.of(context).openEndDrawer(),
                      ),),

                    )
//              Container(
//                child: Builder(builder: (context) => GestureDetector(
//                  child:Container(
//                    color: Color.fromRGBO(0, 0, 0, 0),
//                  ),
//                  onLongPress: () => Scaffold.of(context).openEndDrawer(),
//                ),),
//              ),
//              Colors1(),
                  ],
                )
            ),
          ),
      );

//    ,);
  }
}
