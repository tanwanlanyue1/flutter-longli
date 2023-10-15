import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/model/provider_vital.dart';
import 'package:provider/provider.dart';
import '../color_cards.dart';
import '../../tools/pubClass/colors_tools.dart';

class pageSetup extends StatefulWidget {
  @override
  _pageSetupState createState() => _pageSetupState();
}

class _pageSetupState extends State<pageSetup> {

  TextEditingController _nameController = TextEditingController();//页面名称控制器
  TextEditingController _typeController = TextEditingController();//页面类型控制器
  TextEditingController _keywordController = TextEditingController();//页面关键字控制器
  TextEditingController _sortController = TextEditingController();//页面排序控制器
  TextEditingController _referralController = TextEditingController();//页面介绍控制器
  @override
  Widget build(BuildContext context) {
    final _vitalModels = Provider.of<VitalModel>(context);
    return Container(
      margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
      child:Column(
        children: <Widget>[
          Container(
            height: ScreenUtil().setHeight(100),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text('页面名称:',style: TextStyle(fontSize: ScreenUtil().setSp(22)),),
                  width: ScreenUtil().setWidth(130),
                  alignment: Alignment.centerRight,
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(20)),
                    child: TextField(
                      controller: _nameController,
                      onChanged: (nameController){print('_nameController:$nameController');},
                      decoration: InputDecoration(
                        hintText: '请输入你的用户名',),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(100),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text('页面类型:',style: TextStyle(fontSize: ScreenUtil().setSp(22)),),
                  width: ScreenUtil().setWidth(130),
                  alignment: Alignment.centerRight,
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(20)),
                    child: TextField(
                      controller: _typeController,
                      onChanged: (typeController){print('typeController:$typeController');},
                      decoration: InputDecoration(
                        hintText: '无',),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(100),
            child: Row(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(130),
                  alignment: Alignment.centerRight,
                  child: Text('页面标题:',style: TextStyle(fontSize: ScreenUtil().setSp(22)),),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(20)),
                    child: TextField(
//                      controller: _titlecontroller,
                      decoration: InputDecoration(
                        hintText: '${_vitalModels.PrototypeDatas['title']}',),
                      onChanged: (str){
                        _vitalModels.setTitle(str);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(100),
            child: Row(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(120),
                  alignment: Alignment.centerRight,
                  child: Text('关键字',style: TextStyle(fontSize: ScreenUtil().setSp(22)),),
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(20)),
                    child: TextField(
                      controller: _keywordController,
                      onChanged: (keywordController){print('keywordController:$keywordController');},
                      decoration: InputDecoration(
                        hintText: '请输入关键字',),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(80),
            margin: EdgeInsets.only(bottom:  ScreenUtil().setWidth(20),),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text('排序:',style: TextStyle(fontSize: ScreenUtil().setSp(22)),),
                  width: ScreenUtil().setWidth(120),
                  alignment: Alignment.centerRight,
                ),
                Expanded(
                  child: Container(
                    height:  ScreenUtil().setWidth(200),
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                    child: TextField(
                      controller: _sortController,
                      onChanged: (sortController){print('sortController:$sortController');},
                      decoration: InputDecoration(
                        hintText: '请确定页面排序',),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(240),
            alignment: Alignment.topLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(100),
                  child: Text('页面介绍:',style: TextStyle(fontSize: ScreenUtil().setSp(22)),),
                  width: ScreenUtil().setWidth(130),
                  alignment: Alignment.centerRight,
                ),
                Expanded(
                  child: Container(
                    height: ScreenUtil().setHeight(300),
                    margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(20)),
                    child: TextField(
                      maxLines: 4,
                      controller: _referralController,
                      onChanged: (referralController){print('_referralController:$referralController');},
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '请输入页面介绍',),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(80),
            margin: EdgeInsets.only(bottom:  ScreenUtil().setWidth(20),top:  ScreenUtil().setWidth(20),),
            child: Row(
              children: <Widget>[
                Container(
                  child: Text('颜色:',style: TextStyle(fontSize: ScreenUtil().setSp(22)),),
                  width: ScreenUtil().setWidth(120),
                  alignment: Alignment.centerRight,
                ),
                Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final result = await Navigator.pushNamed(context, '/Colors1');
                        await _vitalModels.setBackground( result == null ? _vitalModels.PrototypeDatas["list"][0]["page"]["background"] : result);
                      },
                      child:Container(
                          margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                          child: Container(
                            width: ScreenUtil().setWidth(50),
                            color: _vitalModels
                                .PrototypeDatas["list"][0]["page"]["background"][0] ==
                                "#"
                                ?
                            HexColor(_vitalModels
                                .PrototypeDatas["list"][0]["page"]["background"])
                                :
                            Color.fromRGBO(
                                int.parse((_vitalModels
                                    .PrototypeDatas["list"][0]["page"]["background"])
                                    .toString()
                                    .split(',')[0]),
                                int.parse((_vitalModels
                                    .PrototypeDatas["list"][0]["page"]["background"])
                                    .toString()
                                    .split(',')[1]),
                                int.parse((_vitalModels
                                    .PrototypeDatas["list"][0]["page"]["background"])
                                    .toString()
                                    .split(',')[2]),
                                double.parse((_vitalModels
                                    .PrototypeDatas["list"][0]["page"]["background"])
                                    .toString()
                                    .split(',')[3])
                            ),
                          )
                      ),
                    )
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
