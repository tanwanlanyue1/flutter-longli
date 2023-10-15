import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';

//退款原因弹窗
class CausePage extends StatefulWidget {
  @override
  _CausePageState createState() => _CausePageState();
}

class _CausePageState extends State<CausePage> {
  String cancel = '';
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            Container (
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("申请退款后无法恢复订单")
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                    child: Text(" 优惠券可退回，有效期内可以使用",style: TextStyle(fontSize: ScreenUtil().setSp(28)),),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(20)),
                        child: Text("请选择取消订单的原因",style: TextStyle(fontSize: ScreenUtil().setSp(28)),),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio<String>(
                          value: "0",
                          groupValue: cancel,
                          onChanged: (value) {
                            setState(() {
                              cancel = value;
                            });
                          }),
                      Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                        child: Text("拍错/多拍/不想要"),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio<String>(
                          value: "1",
                          groupValue: cancel,
                          onChanged: (value) {
                            setState(() {
                              cancel = value;
                            });
                          }),
                      Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                        child: Text("与商家协商一致退款"),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio<String>(
                          value: "2",
                          groupValue: cancel,
                          onChanged: (value) {
                            setState(() {
                              cancel = value;
                            });
                          }),
                      Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                        child: Text("缺货"),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio<String>(
                          value: "3",
                          groupValue: cancel,
                          onChanged: (value) {
                            setState(() {
                              cancel = value;
                            });
                          }),
                      Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                        child: Text("为按约定时间发货"),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Radio<String>(
                          value: "4",
                          groupValue: cancel,
                          onChanged: (value) {
                            setState(() {
                              cancel = value;
                            });
                          }),
                      Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                        child: Text("其他原因"),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Align(
                alignment: FractionalOffset.bottomCenter,
                child:Container(
                  margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
                  height:ScreenUtil().setHeight(100),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.black12,width: 1.0)
                      )
                  ),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child:InkWell(
                          child: Container(
                            height: ScreenUtil().setHeight(60.0),
                            width: ScreenUtil().setWidth(300.0),
                            alignment: Alignment.center,
                            child: Text('返回',style: TextStyle(fontSize: ScreenUtil().setSp(25)),),
                            decoration: BoxDecoration(
//                        color: Colors.orangeAccent,
                              border:  Border.all( width: 0.5), // 边色与边宽度
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Container(
                            height: ScreenUtil().setHeight(60.0),
                            width: ScreenUtil().setWidth(300.0),
                            alignment: Alignment.center,
                            child: Text('确认退款',style: TextStyle(fontSize: ScreenUtil().setSp(25)),),
                            decoration: BoxDecoration(
                              border:  Border.all( width: 0.5), // 边色与边宽度
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),),
                          onTap: () {
                            if(cancel==""){
                              Toast.show("您还未选择原因", context, duration: 1, gravity:  Toast.CENTER);
                            }else{
                              Navigator.pop(context,cancel);
                            }
                          },
                        ),
                      )
                    ],
                  ),)
            ),
          ],
        )
      ],
    );
  }
}
