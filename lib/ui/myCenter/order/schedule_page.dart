import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}
//仅退款商品退换进度
class _SchedulePageState extends State<SchedulePage> {
  String _img = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1565845607483&di=ea898b76a87bca218b649c3afff76f3b&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201601%2F24%2F20160124110308_Vy8cw.jpeg";
  int cancel = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/setting/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: <Widget>[
              _top(),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(25)),
                  child: ListView(
                    children: <Widget>[
                      _state(),
                      _site(),//地址
                      _logistics(),
                      _process(),
                      _commodity(),
                      _bottom(),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(ScreenUtil().setHeight(15)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  //头部
  Widget _top(){
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),top: ScreenUtil().setHeight(50)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          InkWell(
            child: Container(
              height: ScreenUtil().setHeight(34),
              width: ScreenUtil().setWidth(19),
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(25)),
              child: Image.asset('images/setting/leftArrow.png',fit: BoxFit.cover,),
            ),
            onTap: (){
              Navigator.pop(context);
            },
          ),
          InkWell(
            child: Container(
              child: Text("商品退换",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(40)),),
            ),
            onTap: (){
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
  //状态
  Widget _state(){
    return  Container(
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(30),top: ScreenUtil().setHeight(30),
          bottom: ScreenUtil().setHeight(20)),
      child: Text("状态: 退款处理中",style: TextStyle(color: Color(0xff68627E),fontSize: ScreenUtil().setSp(30)),),
    );
  }
  //地址
  Widget _site(){
    return  Container(
      padding: EdgeInsets.all(ScreenUtil().setWidth(25)),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("退回地址",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
              Container(
                padding: EdgeInsets.only(left: ScreenUtil().setWidth(15),right: ScreenUtil().setWidth(15)),
                child: Text("填写单号",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color(0xff68627E))),
                decoration: BoxDecoration(
                  border:  Border.all( width: 1,color: Color(0xff68627E)), // 边色与边宽度
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: Text("name",
                            style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                          child: Text("+187021...",
                            style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color(0xff878787)),),),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Text(" xxxxxxxxx",
                          style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                          overflow: TextOverflow.ellipsis, maxLines: 2,)),
                      ],
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.all(Radius.circular(10))
              )
          )
        ],
      ),
    );
  }
  //退款金额
  Widget _logistics(){
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(25)),
      child: Row(
        children: <Widget>[
          Text("退款金额",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
          Spacer(),
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
            child: Text("￥xxx",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color(0xff68627E))),
          )
        ],
      ),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Color(0xffE5E5E5))),
        )
    );
  }
  //退款流程
  Widget _process() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(30), top: ScreenUtil().setHeight(20)),
          child: Text("退款退货流程",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
        ),
        Container(
          height: ScreenUtil().setWidth(200),
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(30), top: ScreenUtil().setHeight(20),right: ScreenUtil().setWidth(30)),
                child: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(50)),
                        child:  Row(
                          children: <Widget>[
                            cancel == 0 ?
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.blue),
                              width: ScreenUtil().setWidth(40),
                              height: ScreenUtil().setWidth(40),
                              child: Center(
                                  child: Icon(
                                    Icons.check,
                                    size: 20,
                                    color: Colors.white,
                                  )
                              ),
                            ) :
                            Container(
                              width: ScreenUtil().setWidth(40),
                              height: ScreenUtil().setWidth(40),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white,
                                  border: Border.all(width: 1, color: Colors.grey)
                              ),
                            ),
                            Container(
                              width: ScreenUtil().setWidth(200),
                              height: 1,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                        Container(
                          child: Text("买家提交退款申请"),
                        ),
                        Container(
                          child: Text("xxxx-xx-xxxx"),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child:  Row(
                            children: <Widget>[
                              cancel == 1 ?
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.blue),
                                width: ScreenUtil().setWidth(40),
                                height: ScreenUtil().setWidth(40),
                                child: Center(
                                    child: Icon(
                                      Icons.check,
                                      size: 20,
                                      color: Colors.white,
                                    )
                                ),
                              ) :
                              Container(
                                width: ScreenUtil().setWidth(40),
                                height: ScreenUtil().setWidth(40),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.white,
                                    border: Border.all(width: 1, color: Colors.grey)
                                ),
                              ),
                              Container(
                                width: ScreenUtil().setWidth(200),
                                height: 1,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Text("商家同意退款"),
                        ),
                        Container(
                          child: Text("xxxx-xx-xxxx"),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child:  Row(
                            children: <Widget>[
                              cancel == 2 ?
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.blue),
                                width: ScreenUtil().setWidth(40),
                                height: ScreenUtil().setWidth(40),
                                child: Center(
                                    child: Icon(
                                      Icons.check,
                                      size: 20,
                                      color: Colors.white,
                                    )
                                ),
                              ) :
                              Container(
                                width: ScreenUtil().setWidth(40),
                                height: ScreenUtil().setWidth(40),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.white,
                                    border: Border.all(width: 1, color: Colors.grey)
                                ),
                              ),
                              Container(
                                width: ScreenUtil().setWidth(200),
                                height: 1,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Text("商家退款"),
                        ),
                        Container(
                          child: Text("xxxx-xx-xxxx"),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child:  Row(
                            children: <Widget>[
                              cancel == 3 ?
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.blue),
                                width: ScreenUtil().setWidth(40),
                                height: ScreenUtil().setWidth(40),
                                child: Center(
                                    child: Icon(
                                      Icons.check,
                                      size: 20,
                                      color: Colors.white,
                                    )
                                ),
                              ) :
                              Container(
                                width: ScreenUtil().setWidth(40),
                                height: ScreenUtil().setWidth(40),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.white,
                                    border: Border.all(width: 1, color: Colors.grey)
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Text("退款成功"),
                        ),
                        Container(
                          child: Text("xxxx-xx-xxxx"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
  //退款商品
  Widget _commodity(){
      return Container(
        height: ScreenUtil().setHeight(150),
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(30)),
              child: Image.network("$_img"),),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text("xxxxxxxx"),
                ),
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                  child: Text("xxx"),
                ),
              ],
            ),
            Spacer(),
            Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text("￥xxx"),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                    child: Text("x1"),
                  ),
                ],
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 1, color: Color(0xffE5E5E5))),
        ),
      );
  }
  //底部
  Widget _bottom() {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        height: ScreenUtil().setHeight(120),
        child: Row(
          children: <Widget>[
            Spacer(),
            Container(
                width: ScreenUtil().setWidth(120),
                height: ScreenUtil().setHeight(50),
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),
                    left: ScreenUtil().setWidth(20)),
                child: InkWell(
                  child: Center(
                    child: Text("客服",style: TextStyle(fontSize: ScreenUtil().setSp(25))),
                  ),
                  onTap: () async {},
                ),
                decoration: BoxDecoration(
                  border: Border.all(width: 1,color: Color(0xffe5e5e5)), // 边色与边宽度
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                )
            ),
            Container(
                width: ScreenUtil().setWidth(120),
                height: ScreenUtil().setHeight(50),
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),
                    left: ScreenUtil().setWidth(20),
                    right: ScreenUtil().setWidth(20)),
                child: InkWell(
                  child: Center(
                    child: Text("取消",style: TextStyle(fontSize: ScreenUtil().setSp(25)),),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                decoration: BoxDecoration(
                  border: Border.all(width: 1,color: Color(0xffe5e5e5)), // 边色与边宽度
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                )
            ),
          ],
        ),
      ),
    );
  }
}
