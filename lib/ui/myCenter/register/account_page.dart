import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _background(),
          Column(
            children: <Widget>[
              _top(),
              _belt(),
            ],
          ),
        ],
      ),
    );
  }
  //背景
  Widget _background(){
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var heights = size.height;
    var widths = size.width;
    return Container(
      width: widths,
      height: heights,
      child: Image.asset("images/setting/background.jpg",fit: BoxFit.cover,),
    );
  }
  //头部
  Widget _top(){
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(50)),
      child: Row(
        children: <Widget>[
          Container(
            child: InkWell(
              child: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: ScreenUtil().setSp(80),),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ),
          Expanded(
              child: Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(60)),
                child: Center(
                  child: Text("账户与安全",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(40)),),
                ),
              )),
        ],
      ),
    );
  }
  //具体内容
  Widget _belt(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(40),left: ScreenUtil().setWidth(25),
          right: ScreenUtil().setWidth(25)),
      child: Column(
        children: <Widget>[
          Container(
            height: ScreenUtil().setHeight(100),
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right:ScreenUtil().setWidth(25),),
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                    child: Text('账号绑定',style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                    child: Text('更换账号',style: TextStyle(fontSize: ScreenUtil().setSp(30),
                        color: Color.fromRGBO(230, 230, 230, 1)),),
                  ),
                ],
              ),
              onTap: (){
                Navigator.pushNamed(context, '/changeTheBinding');
              },
            ),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1, color: Color.fromRGBO(230, 230, 230, 1))),
              ),
          ),
          Container(
            height: ScreenUtil().setHeight(100),
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right:ScreenUtil().setWidth(25),),
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                    child: Text('账号安全',style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                    child: Text('修改密码',style: TextStyle(fontSize: ScreenUtil().setSp(30),
                        color: Color.fromRGBO(230, 230, 230, 1)),),
                  ),
                ],
              ),
              onTap: (){
                Navigator.pushNamed(context, '/changePassword');
              },
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          border: Border.all(width: 1.0, color: Colors.grey),
          borderRadius: BorderRadius.circular(
              ScreenUtil().setWidth(25))
      ),
    );
  }
}
