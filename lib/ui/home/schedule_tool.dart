import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'package:provider/provider.dart';
//连续签到天数组件
class ScheduleTools extends StatefulWidget {
//  final int day;
//  ScheduleTools({
//    this.day
//});
  @override
  _ScheduleToolsState createState() => _ScheduleToolsState();
}

class _ScheduleToolsState extends State<ScheduleTools> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    setState(() {
//      if(widget.day ==0){
//        index = widget.day;
//        alignment = [index1,index2,index3,index4];
//      } else if(widget.day<4){
//        index = widget.day;
//        alignment = [index1,index2,index3,index4];
//      }else if((widget.day % 4) ==0){
//        index = 4;
//        alignment = [index1,index2,index3,index4];
//        alignment[3] = widget.day;
//        alignment[2] = widget.day-1;
//        alignment[1] = widget.day-2;
//        alignment[0] = widget.day-3;
//      }else{
//        index = widget.day%4;
//        alignment = [index1,index2,index3,index4];
//        alignment[index-1] = widget.day;
//        int idx = index-1;
//        switch (idx) {
//          case 0:
//            alignment[3] = widget.day+3;
//            alignment[2] = widget.day+2;
//            alignment[1] = widget.day+1;
//            break;
//          case 1:
//            alignment[3] = widget.day+2;
//            alignment[2] = widget.day+1;
//            alignment[0] = widget.day-1;
//            break;
//          case 2:
//            alignment[3] = widget.day+1;
//            alignment[1] = widget.day-1;
//            alignment[0] = widget.day-1;
//            break;
//          default:
//            print("green");
//        }
//      }
//    });
//    print(index);
  }
  int index=0;
  int index1 = 1;
  int index2 = 2;
  int index3 = 3;
  int index4 = 4;
  List alignment = [];
  @override
  Widget build(BuildContext context) {
    var _personalModel = Provider.of<PersonalModel>(context);
    setState(() {
      //      print('进来了$index');
      if(_personalModel.IsSignDays ==0){
        index = _personalModel.IsSignDays;
        alignment = [index1,index2,index3,index4];
      } else if(_personalModel.IsSignDays<4){
        index = _personalModel.IsSignDays;
        alignment = [index1,index2,index3,index4];
      }else if((_personalModel.IsSignDays % 4) ==0){
        index = 4;
        alignment = [index1,index2,index3,index4];
        alignment[3] = _personalModel.IsSignDays;
        alignment[2] = _personalModel.IsSignDays-1;
        alignment[1] = _personalModel.IsSignDays-2;
        alignment[0] = _personalModel.IsSignDays-3;
      }else{
        index = _personalModel.IsSignDays%4;
        alignment = [index1,index2,index3,index4];
        alignment[index-1] = _personalModel.IsSignDays;
        int idx = index-1;
        switch (idx) {
          case 0:
            alignment[3] = _personalModel.IsSignDays+3;
            alignment[2] = _personalModel.IsSignDays+2;
            alignment[1] = _personalModel.IsSignDays+1;
            break;
          case 1:
            alignment[3] = _personalModel.IsSignDays+2;
            alignment[2] = _personalModel.IsSignDays+1;
            alignment[0] = _personalModel.IsSignDays-1;
            break;
          case 2:
            alignment[3] = _personalModel.IsSignDays+1;
            alignment[1] = _personalModel.IsSignDays-1;
            alignment[0] = _personalModel.IsSignDays-1;
            break;
          default:
            print("联系管理员");
        }
      }
    });

    return  Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text("${alignment[0]}天",style: TextStyle(color:index >=1 ?Colors.black :Colors.grey,fontFamily: "思源",fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.bold),),
              Row(
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(60),
                    height: index >=1 ?2 :1,
                    color: index >=1 ?Colors.black :Colors.grey,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(8),right: ScreenUtil().setWidth(8)),
                    width: ScreenUtil().setWidth(12),
                    height: ScreenUtil().setWidth(12),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: index >=1 ?Colors.black :Colors.grey,
                        border: Border.all(width: 1, color: Colors.grey)
                    ),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(60),
                    height: index >=1 ?2 :1,
                    color: index >=1 ?Colors.black :Colors.grey,
                  )
                ],
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Text("${alignment[1]}天",style: TextStyle( color: index >=2 ?Colors.black :Colors.grey,fontFamily: "思源",fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.bold),),
              Row(
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(60),
                    height: index >=2 ?2 :1,
                    color: index >=2 ?Colors.black :Colors.grey,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(8),right: ScreenUtil().setWidth(8)),
                    width: ScreenUtil().setWidth(12),
                    height: ScreenUtil().setWidth(12),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: index >=2 ?Colors.black :Colors.grey,
                        border: Border.all(width: 1, color: Colors.grey)
                    ),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(60),
                    height: index >=2 ?2 :1,
                    color: index >=2 ?Colors.black :Colors.grey,
                  )
                ],
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Text("${alignment[2]}天",style: TextStyle( color: index >=3 ?Colors.black :Colors.grey,fontFamily: "思源",fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.bold),),
              Row(
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(60),
                    height: index >=3 ?2 :1,
                    color: index >=3 ?Colors.black :Colors.grey,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(8),right: ScreenUtil().setWidth(8)),
                    width: ScreenUtil().setWidth(12),
                    height: ScreenUtil().setWidth(12),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: index >=3 ?Colors.black :Colors.grey,
                        border: Border.all(width: 1, color: Colors.grey)
                    ),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(60),
                    height: index >=3 ?2 :1,
                    color: index >=3 ?Colors.black :Colors.grey,
                  )
                ],
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Text("${alignment[3]}天",style: TextStyle( color: index >=4 ?Colors.black :Colors.grey,fontFamily: "思源",fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.bold)),
              Row(
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(60),
                    height: index ==4 ?2 :1,
                    color: index ==4 ?Colors.black :Colors.grey,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(8),right: ScreenUtil().setWidth(8)),
                    width: ScreenUtil().setWidth(12),
                    height: ScreenUtil().setWidth(12),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: index ==4 ?Colors.black :Colors.grey,
                        border: Border.all(width: 1, color: Colors.grey)
                    ),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(60),
                    height: index ==4 ?2 :1,
                    color: index ==4 ?Colors.black :Colors.grey,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
