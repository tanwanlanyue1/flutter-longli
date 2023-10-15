import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/model/provider_vital.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

//图片展播
class Item extends StatefulWidget {
  final int index;
  Item({
    Key key,
    this.index
  });
  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {

  @override
  Widget build(BuildContext context) {
    final _vitalModels = Provider.of<VitalModel>(context);
    return Container(
      child: Column(
        children: <Widget>[
          Column(
            children: First(),
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            decoration: BoxDecoration(
              border: Border.all(width: 1.0,color: Colors.black12),
              color: Colors.white,
            ),
            height: ScreenUtil().setHeight(60.0),
            child: InkWell(
              child: Center(
                child: Text('添加一个商品'),
              ),
              onTap: () {
                _vitalModels.addOnePictures(widget.index);
              },
            ),
          )
        ],
      ),
    );
  }
//将数据展示
  List<Widget> First() {

    final _vitalModels = Provider.of<VitalModel>(context);
    List _index = List<Map<String, dynamic>>.from(_vitalModels.PrototypeDatas["list"][0]["items"][widget.index]['list']);
    List<Widget> Tow = [];
    for (var i = 0; i < _index.length ; i++) {
      Tow.add(
        Items(
            indexs:widget.index,//具体的某一组
            data:_vitalModels.PrototypeDatas["list"][0]["items"][widget.index]["list"][i],
            i:i //具体的某项
        ),
      );
    }
    return Tow;
  }
}
//图片展播的内容
class Items extends StatefulWidget {

  final Map data;
  final int indexs;
  final int i;

  Items({
    Key key,
    this.data,
    this.indexs,
    this.i
  });

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {

  TextEditingController con = TextEditingController();
  TextEditingController cont = TextEditingController();
  TextEditingController contr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _vitalModels = Provider.of<VitalModel>(context);
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
          margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(15)),
          decoration: BoxDecoration(border: Border(top: BorderSide(width: 1.0,color: Colors.white))),
          child: Row(
            children: <Widget>[
              //图片
              Container(
                height: ScreenUtil().setHeight(150),
                width: ScreenUtil().setWidth(150),
                margin: EdgeInsets.only(top: 10.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 5.0),
                      height: ScreenUtil().setHeight(150),
                      width: ScreenUtil().setWidth(150),
                      child: Image.network('${widget.data["imgurl"]}', fit: BoxFit.fill,
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.only(right: 5.0),
                          height: ScreenUtil().setHeight(50),
                          color: Colors.black12,
                          alignment: Alignment.center,
                          child:  InkWell(
                            child: Text(
                              '选择图片',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {},
                          ),
                        )
                    ),
                  ],
                ),
              ),
              //输入框
              Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(margin: EdgeInsets.only(top: 5.0),child: Row(
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                height: ScreenUtil().setHeight(50.0),
                                width: ScreenUtil().setWidth(110.0),
                                alignment: Alignment.bottomRight,
                                child: Text('标题:',
                                  style: TextStyle(fontSize: ScreenUtil().setSp(24)),
                                ),
                              ),
                              onTap: () {},
                            ),
                            Expanded(
                              child: Container(
                                height: ScreenUtil().setHeight(50.0),
                                margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                                child: TextField(
                                  controller: con,
                                  onChanged: (v) {
                                    print('con=${con.text}');
                                    _vitalModels.onChangePictures(widget.indexs,widget.i,"title",con.text);
                                  },
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical:4.0),
                                      hintText: "${widget.data['title']=="" ? "标题" : widget.data["title"]}",
                                      hintStyle: TextStyle(fontSize: ScreenUtil().setSp(24))
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),),
                        Container(margin: EdgeInsets.only(top: 5.0),child: Row(
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                height: ScreenUtil().setHeight(50.0),
                                width: ScreenUtil().setWidth(110.0),
                                alignment: Alignment.bottomRight,
                                child: Text('选择图片:',
                                  style: TextStyle(fontSize: ScreenUtil().setSp(24)),
                                ),
                              ),
                              onTap: () {},
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                                height: ScreenUtil().setHeight(50.0),
                                child: TextField(
                                  controller: cont,
                                  onChanged: (v) {
                                    print('cont=${cont.text}');
                                  },
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                                      hintText: "图片地址",
                                      hintStyle: TextStyle(fontSize: ScreenUtil().setSp(24))
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),),
                        Container(margin: EdgeInsets.only(top: 5.0),child: Row(
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                height: ScreenUtil().setHeight(50.0),
                                width: ScreenUtil().setWidth(110.0),
                                alignment: Alignment.bottomRight,
                                child: Text('选择链接:',
                                  style: TextStyle(fontSize: ScreenUtil().setSp(24)),
                                ),
                              ),
                              onTap: () {},
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                                height: ScreenUtil().setHeight(50.0),
                                child: TextField(
                                  controller: contr,
                                  onChanged: (v) {
                                    print('contr=${contr.text}');
                                  },
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                                      hintText: "选择链接",
                                      hintStyle: TextStyle(fontSize: ScreenUtil().setSp(24))
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),)
                      ],
                    ),
                  )),
            ],
          ),
        ),
        Positioned(
            right:0,
            top: 0,
            child: GestureDetector(
              child: Icon(Icons.delete_forever,size: ScreenUtil().setSp(35),color: Colors.deepOrange,),
              onTap: (){
                if((_vitalModels.PrototypeData["list"][0]["items"][widget.indexs]["list"].length)>=2){
                  Toast.show("删除成功", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                  _vitalModels.deleteOnePictures(widget.indexs,widget.i);
                }else{
                  Toast.show("最少保留一个", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                }
              },
            )
        ),
      ],
    );
  }
}
