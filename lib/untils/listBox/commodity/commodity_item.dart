import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/model/provider_vital.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    print('index时${widget.index}');
  }
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
                _vitalModels.addOneCommodity(widget.index);
              },
            ),
          )
        ],
      ),
    );
  }
//将小商品组的数据循环
  List<Widget> First() {
    final _vitalModels = Provider.of<VitalModel>(context);
    List _index = List<Map<String, dynamic>>.from(_vitalModels.PrototypeDatas["list"][0]["items"][widget.index]['data']["data"]);
    List<Widget> Tow = [];
    for (var i = 0; i <_index.length; i++) {
      Tow.add(
        Items(
          indexs:widget.index,//具体的某一组
          data:_vitalModels.PrototypeDatas["list"][0]["items"][widget.index]['data']["data"][i],
          i:i //具体的某项
        ),
      );
    }
    return Tow;
  }
}
//小商品组内的数据
//每一项
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

  String images =
      'https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-1.jpg';
  TextEditingController con = TextEditingController();
  TextEditingController cont = TextEditingController();

//  data 结构
//  {
//  "thumb": "https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-1.jpg",
//  "price": null,
//  "productprice": "99.00",
//  "title": "这里是商品标题",
//  "sales": "0",
//  "gid": "",
//  "bargain": 0,
//  "credit": 0,
//  "ctype": 1
//  },

  @override
  Widget build(BuildContext context) {
    final _vitalModels = Provider.of<VitalModel>(context);
    return Stack(
      children: <Widget>[
        Container(
          height: ScreenUtil().setHeight(140),
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(10), ),
          margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(15)),
          decoration: BoxDecoration(border: Border(top: BorderSide(width: 1.0,color: Colors.white))),
          child: Row(
            children: <Widget>[
              Container(
                color: Colors.grey,
                height: ScreenUtil().setHeight(120),
                width: ScreenUtil().setWidth(130),

                child: Stack(
                  children: <Widget>[
                    Container(
                      height: ScreenUtil().setHeight(120),
                      width: ScreenUtil().setWidth(130),
                      color: Colors.black,
                      child: Image.network('${widget.data['thumb']}', fit: BoxFit.fill,),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: ScreenUtil().setHeight(50),
                          color: Colors.black12,
                          alignment: Alignment.center,
                          child: InkWell(
                            child: Text('选择商品', style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(22)),),
                            onTap: () {},
                          ),
                        )
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(10.0)),
                    padding: EdgeInsets.only(top: ScreenUtil().setHeight(10), ),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                  height: ScreenUtil().setHeight(50.0),
                                  width: ScreenUtil().setHeight(80.0),
                                  child: Center(
                                    child: Text(
                                      '名称:',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(25)),
                                    ),
                                  ),
                                ),
                                onTap: () {},
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                                  height: ScreenUtil().setHeight(50.0),
                                  child: TextField(
                                    controller: con,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        hintText: "${widget.data['title']}",
                                        hintStyle: TextStyle(
                                            color: Colors.black)
                                    ),
                                    onChanged: (v) {
                                      _vitalModels.onChangeCommodity(
                                          widget.indexs, widget.i, "title",
                                          "${v}");
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                  height: ScreenUtil().setHeight(50.0),
                                  width: ScreenUtil().setHeight(80.0),
                                  child: Center(
                                    child: Text('价格: '),
                                  ),
                                ),
                                onTap: () {},
                              ),
                              Expanded(
                                child: Container(
                                  height: ScreenUtil().setHeight(55.0),
                                  padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(10)),
                                  child: TextField(
                                    controller: cont,
                                    onChanged: (v) {
                                      _vitalModels.onChangeCommodity(widget.indexs, widget.i, "price", "${v}");
                                    },
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                                      hintText: "${widget.data['price'] == null ? "20.00" : widget.data['price']}",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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

              if((_vitalModels.PrototypeData["list"][0]["items"][widget.indexs]["data"]["data"].length)>=2){
                Toast.show("删除成功", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
                _vitalModels.deleteIndexData(widget.indexs,widget.i);
              }else{
                Toast.show("最少保留一个", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
              }
            },
          )
        )
      ],
    );
  }
}
