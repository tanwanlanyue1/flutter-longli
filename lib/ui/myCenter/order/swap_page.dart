import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:toast/toast.dart';
//换货申请
class SwapPage extends StatefulWidget {
  @override
  _SwapPageState createState() => _SwapPageState();
}

class _SwapPageState extends State<SwapPage> {
  final TextEditingController _refundText = TextEditingController(); //退款协商金额
  final TextEditingController _remarkText = TextEditingController(); //退款协商金额
  String _img = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1565845607483&di=ea898b76a87bca218b649c3afff76f3b&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201601%2F24%2F20160124110308_Vy8cw.jpeg";
  File _image;
  File _image1;
  File _image2;
  File _image3;
  File _image4;
  String cancel = '';
  //打开相机
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
//    _uploadImg(image);
    setState(() {
      if (_image == null) {
        _image = image;
      } else if (_image1 == null) {
        _image1 = image;
      }
    });
  }

  //打开图库
  Future getImages() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//    _uploadImg(image);
    setState(() {
      if (_image == null) {
        _image = image;
      } else if (_image1 == null) {
        _image1 = image;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("换货申请"),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              details(),
              state(),
              refunds(),
              voucher(),
            ],
          ),
          bottom(),
        ],
      ),
    );
  }

  //订单下的商品
  Widget details() {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),
          left: ScreenUtil().setWidth(20),
          right: ScreenUtil().setWidth(20)),
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("订单号213"),
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            child: Row(
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(120),
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(30)),
                  child: Image.network("$_img"),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text("xxxx"),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                      child: Text("xxx"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(color: Colors.black12, width: 1.0)
          )
      ),
    );
  }
  //订单状态
  Widget state(){
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20)),
      child: Row(
        children: <Widget>[
          Text("更换商品，请联系客服备注"),
          Spacer(),
          InkWell(
            child: Container(
              width: ScreenUtil().setWidth(100),
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
              child: Center(
                child: Text("客服"),
              ),
              decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          )
        ],
      ),
    );
  }
  //退款原因
  Widget refunds() {
    return Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(20),
          top: ScreenUtil().setHeight(20)),
      padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("换货原因"),
              Spacer(),
              InkWell(
                child: Icon(
                  Icons.keyboard_arrow_right, size: ScreenUtil().setSp(60),),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return GestureDetector(
                          child: Container(
                            height: 2000.0,
                            color: Color(0xfff1f1f1), //_salePrice
                            child: Reason(),
                          ),
                          onTap: () => false,
                        );
                      });
                },
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: Row(
              children: <Widget>[
                Text("收货地址"),
                Spacer(),
                InkWell(
                  child: Icon(
                    Icons.keyboard_arrow_right, size: ScreenUtil().setSp(60),),
                  onTap: () {
                    Navigator.pushNamed(context, '/protocol');
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: Row(
              children: <Widget>[
//                Icon(Icons.phone, color: Colors.black,),
                Container(
//                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                  child: Text("xxx",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
                ),
                Container(
                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                  child: Text("+86 xxx",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: Text("xxxxxxxxxxxx"),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
            child: Row(
              children: <Widget>[
                Container(
                    child: Text('换货说明',
                      style: TextStyle(fontSize: ScreenUtil().setSp(30)),)),
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                  width: ScreenUtil().setWidth(450.0),
                  child: TextField(
                    controller: _remarkText,
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(
                          fontSize: ScreenUtil().setSp(25)),
                      contentPadding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(20),
                        top: ScreenUtil().setHeight(20),),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(color: Colors.black12, width: 1.0)
          )
      ),
    );
  }

  //上传凭证
  Widget voucher() {
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),
          top: ScreenUtil().setHeight(20),
          bottom: ScreenUtil().setHeight(80)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("上传凭证"),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                height: ScreenUtil().setHeight(200),
                child: _image == null ?
                Text("") :
                Image.file(_image,
                  fit: BoxFit.cover,),
              ),
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(20),
                    left: ScreenUtil().setWidth(20)),
                height: ScreenUtil().setHeight(200),
                child: _image1 == null ?
                Text("") :
                Image.file(_image,
                  fit: BoxFit.cover,),
              ),
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                height: ScreenUtil().setHeight(200),
                child: InkWell(
                  child: Image.asset(
                    "images/adds.jpg",
                    fit: BoxFit.cover,
                  ),
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return GestureDetector(
                            child: Container(
                              height: ScreenUtil().setHeight(160),
                              child: _openWidget(),
                            ),
                            onTap: () => false,
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //底部
  Widget bottom() {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: InkWell(
        child: Container(
          margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
          height: ScreenUtil().setHeight(60.0),
          width: ScreenUtil().setWidth(300.0),
          alignment: Alignment.center,
          child: Text(
            '提交', style: TextStyle(fontSize: ScreenUtil().setSp(25)),),
          decoration: BoxDecoration(
            border: Border.all(width: 0.5), // 边色与边宽度
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  //打开图库
  Widget _openWidget() {
    return Row(
      children: <Widget>[
        Expanded(
          child: IconButton(
              icon: Icon(
                Icons.image,
                size: 40.0,
              ),
              onPressed: () {
                getImages();
                Navigator.of(context).pop(); //隐藏弹出框
              }),
        ),
        Expanded(
          child: IconButton(
              icon: Icon(
                Icons.add_a_photo,
                size: 40.0,
              ),
              onPressed: () {
                getImage();
                Navigator.of(context).pop();
              }),
        ),
      ],
    );
  }
}

//退款原因
class Reason extends StatefulWidget {
  @override
  _ReasonState createState() => _ReasonState();
}

class _ReasonState extends State<Reason> {
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
                      Text("请选择换货原因")
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
                        child: Text("质量做工不好/破损/污迹"),
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
                        child: Text("尺寸/大小/颜色不合适"),
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
                        child: Text("发错货 "),
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
                            child: Text('确认',style: TextStyle(fontSize: ScreenUtil().setSp(25)),),
                            decoration: BoxDecoration(
                              border:  Border.all( width: 0.5), // 边色与边宽度
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),),
                          onTap: () {
                            if(cancel==""){
                              Toast.show("您还未选择原因", context, duration: 1, gravity:  Toast.CENTER);
                            }else{
                              print(cancel);
                              Navigator.pop(context);
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
