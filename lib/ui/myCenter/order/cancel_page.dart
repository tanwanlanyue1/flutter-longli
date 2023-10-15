import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';

//待付款取消订单的弹窗
class CancelPage extends StatefulWidget {
  final returnCause;
  CancelPage({
    this.returnCause,
});
  @override
  _CancelPageState createState() => _CancelPageState();
}

class _CancelPageState extends State<CancelPage> {
  String cancel = "0";
  //(待付款)根据待付款订单id取消订单
  void _removeWaitingPaymentById(cancel)async {
    var result = await HttpUtil.getInstance().post(
        servicePath['removeWaitingPaymentById'],
        data: {
          "orderId":widget.returnCause[1]["orderId"],
          "orderReturnCauseId":cancel,
        }
    );
    if (result["code"] == 0 ) {
      Toast.show("取消成功", context, duration: 1, gravity:  Toast.CENTER);
      Navigator.pop(context,cancel);
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"]== 500) {
      Toast.show("${result["msg"]}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            cause(),
          ],
        ),
        bottom(),
      ],
    );
  }
  //取消订单原因
  Widget cause(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),bottom: ScreenUtil().setHeight(30)),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text("取消订单",style: TextStyle(fontSize: ScreenUtil().setSp(40)),),
              ),
//              Spacer(),
//              InkWell(
////                child: Image.asset(""),
//              onTap: (){
//                Navigator.pop(context);
//              },
//              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
            child: Text("取消后无法恢复订单，优惠券可退回，有效期内可以使用",style: TextStyle(fontSize: ScreenUtil().setSp(30),
            color: Color.fromRGBO(171, 174, 176, 1)),),
          ),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(20)),
                child: Text("请选择取消订单的原因",style: TextStyle(fontSize: ScreenUtil().setSp(30),
                color: Color.fromRGBO(171, 174, 176, 1)),),
              )
            ],
          ),
         Column(
           children: refund(),
         )
        ],
      ),
    );
  }
  //退款理由
  List<Widget> refund(){
    List<Widget> paymentBody = [];
    for(var j=0;j<widget.returnCause[0]["data"].length;j++){
      paymentBody.add(
        Row(
          children: <Widget>[
            Radio<String>(
                value: widget.returnCause[0]["data"][j]["id"].toString(),
                groupValue: cancel,
                onChanged: (value) {
                  setState(() {
                    cancel = value;
                  });
                }),
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
              child: Text("${widget.returnCause[0]["data"][j]["name"]}"),
            )
          ],
        ),
      );
    }
    return paymentBody;
  }
  //底部
  Widget bottom(){
    return Align(
        alignment: FractionalOffset.bottomCenter,
        child:Container(
          margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(20)),
          height:ScreenUtil().setHeight(100),
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: Colors.black12,width: 1.0)
              )
          ),
          child:InkWell(
            child: Container(
              height: ScreenUtil().setHeight(60.0),
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25)),
              child: Text('确认取消',style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white),),
              decoration: BoxDecoration(
                color: Color.fromRGBO(104, 098, 126, 1)
              ),),
            onTap: () {
              if(cancel=="0"){
                Toast.show("您还未选择原因", context, duration: 1, gravity:  Toast.CENTER);
              }else{
                _removeWaitingPaymentById(cancel);
              }
            },
          ),)
    );
  }
}
