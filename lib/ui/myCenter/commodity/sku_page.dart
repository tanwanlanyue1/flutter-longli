import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
class SkuPage extends StatefulWidget {
  String img;
  List sku;
  int commodityId;
  String salePriceSection;
  bool purchase;//判断是加入购物车还是购买
  bool enableMatrix;//判断是否有规格
  bool minVipPrice;//vip价格
  bool brand;//品牌
  bool title;//标题
  SkuPage(
    this.img,
    this.sku,
    this.commodityId,
    this.salePriceSection,
    this.purchase,
    this.enableMatrix
    );
  @override
  _SkuPageState createState() => _SkuPageState();
}

class _SkuPageState extends State<SkuPage> {
  List stand = [];
  List version = [];//版本
  List combo = [];//套餐
  int colo = -1;
  int quantity = 1;//数量
  int inventory = 0;//库存

  List _styles = [];//规格
  List spec = [];//规格
  List qu = [];//规格去重
  List matchId = [];//SkuID
  Map push  = {};//传递的规格
  List SkuIds = [];//传递的SkuId
  List SkuId = [];//无规格传递的SkuId
  var map = new Map();//处理后的数据
  var mapLabel  = new Map();//处理后的标签
  var _versions = new Map();//已选的标签
  var preview = new Map();//立即购买的预览数据

  String sale_price = "";//售价
  //添加商品到购物车
  _adds(List skuId,String commodityId,String shopId, commoditySpecs,int commodityNum)async {
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var result = await dio.post(
        servicePath['addCartItem'],
        data: {
            "skuId": json.encode(skuId),
            "commodityId": commodityId,
            "num": commodityNum,
            "shopId": shopId,
            "spec":json.encode(commoditySpecs),
          }
    );
    if(result.data["code"]==0){
      Toast.show("添加成功", context, duration: 2, gravity: Toast.CENTER);
    }else if (result.data["code"] == 401) {
      Toast.show("您还未登录，请先登录", context, duration: 2, gravity: Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result.data["code"]== 500) {
      Toast.show("${result.data}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //无规格添加商品到购物车
  _addsNone(var skuId,String commodityId,String shopId,int commodityNum)async {
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var result = await dio.post(
        servicePath['addCartItem'],
        data: {
          "skuId": json.encode(skuId),
          "commodityId": commodityId,
          "num": commodityNum,
          "shopId": shopId,
          "spec": null,
        }
    );
    if(result.data["code"]==0){
      Toast.show("添加成功", context, duration: 2, gravity: Toast.CENTER);
    }else if (result.data["code"] == 401) {
      Toast.show("您还未登录，请先登录", context, duration: 2, gravity: Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result.data["code"]== 500) {
      Toast.show("${result.data}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  //立即购买查看预览
  _addOrderView(List skuId,String commodityId,String shopId, commoditySpecs,int commodityNum)async {
    print(skuId);//[487]
    print(commodityId );
    print(shopId);
    print(json.encode(commoditySpecs));
    print("数量$commodityNum");
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var result = await dio.post(
        servicePath['addOrderView'],
        data: {
          "skuId":skuId,
          "commodityId": commodityId,
          "num": commodityNum,
          "shopId": shopId,
          "spec":json.encode(commoditySpecs),
        }
    );
//    Navigator.pushNamed(context, '/closeAccount',arguments: preview);
    if(result.data["code"]==0){

//      print(result.data["data"]);
      preview = result.data["data"];
      print(preview);
      Navigator.pushNamed(context, '/closeAccount',arguments: preview);
    }else if (result.data["code"] == 401) {
      Toast.show("您还未登录，请先登录", context, duration: 2, gravity: Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result.data["code"]== 500) {
      Toast.show("${result.data}", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  /// 根据SKU数组返回库存
  _getStockBySkus(List mapList)async{
//    print("mapList${json.encode(mapList)}");
    Dio dio = Dio();
    dio.interceptors.add(CookieManager(CookieJar()));
    var post = {"mapList": json.encode(mapList)};
    var addPost = await dio.post(
      servicePath['getStockBySkus'],
      data: post,
    );
//    print("${addPost.data}");
    if (addPost.data["code"]==0) {
      setState(() {
        inventory = addPost.data["result"];
        push = {};
        for(var i = 0; i< _styles.length; i++){
         push.addAll({spec[i]:_styles[i]});
        }
//        print('push${push}');
      });
    }else if (addPost.data["code"]== 401) {
      Toast.show("请先登录", context, duration: 2, gravity: Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      var text = await Navigator.pushNamed(context, '/LoginPage');
      if(text!=null){
        _getStockBySkus(widget.sku);
      }
    }else if (addPost.data["code"]== 500) {
      Toast.show("${addPost.data}", context, duration: 2, gravity: Toast.CENTER);
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    if(widget.enableMatrix==true){
      deWeight();
    }else{
      SkuId.add(widget.sku[0]["skuId"]);
      _getStockBySkus(widget.sku);
    }
    super.initState();
  }
  //处理数据
  void deWeight() async{
    List format;
    for (var obj in widget.sku) {//规格处理
//      stock.add(obj["stock"]);
//      stock.remove(0);
//    print(widget.sku);
      if(int.parse(obj["stock"])<=0){
        continue;
      }
      obj.forEach((ley, val){
        var arr = map[ley]!=null&&map[ley].toString().length>0?map[ley]:[];
        if (val!=null && val.toString().length>0 && arr.indexOf(val)==-1&&int.parse(obj["stock"])>0) {
          arr.add(val);
        }
        if ("SKU" != ley&&"markting_price"!= ley&&"original_price" != ley&&"vip_price" != ley&& "stock" != ley
            && "sale_price" != ley ) {
          var data = {ley: arr};
          var array = [];
          for (var a in arr) {
            array.add(0); // 0显示
          }
          qu.add(ley);
          _styles = qu.toSet().toList();
          spec = qu.toSet().toList();
          for (var j = 0; j < _styles.length; j++) {
            _styles[j] = "";
          }
          _versions.addAll({ley: -1});
          map.addAll(data);
          mapLabel.addAll({ley: array});
        }
      });
    }
    widget.sku = format;
  }
  //展示
  void show(int index,int j,) {
    var matrix = widget.sku;
    List k = map.keys.toList();
    List v = map.values.toList();
    var arr = [];
    var list = v[index];
    for (var m in matrix) {
      var val= m[k[index]];
      if (val == list[j] && k[index] != "SKU" && k[index] != "markting_price"&& k[index] != "stock"
          && k[index] != "original_price" && k[index] != "vip_price"&& k[index] != "sale_price") {
        arr.add(m);
      }
    }
    var bo;
    map.forEach((ley, item) =>{
      if (k[index] != ley) {
        for(var i in item){
          bo = false,
          for (var a in arr) {
            // 处理后数据的具体规格 == key筛选出来的具体规格
            if (i == a[ley]) {
              bo = true,
            }
          },
          if (!bo) {
            mapLabel[ley][map[ley].indexOf(i)] = 1,
          }
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return sku();
  }

  Widget sku() {
    return Container(
      child: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Container(
                height: ScreenUtil().setHeight(200),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    widget.img==null||widget.img.length==0?
                    Container():
                    Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                      height: ScreenUtil().setWidth(150),
                      width: ScreenUtil().setWidth(150),
                      child: Image.network("$ApiImg"+"${widget.img}",fit: BoxFit.fill,),//_result"+"${widget.img.join(',')
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                            height: ScreenUtil().setHeight(50),
                            child:  Text("品牌"),//_result"+"${widget.img.join(',')
                          ),
                          Container(
                            margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                            height: ScreenUtil().setHeight(50),
                            child:  Text("标题"),//_result"+"${widget.img.join(',')
                          ),
                          Container(
                            margin: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                            height: ScreenUtil().setHeight(50),
                            child:Row(
                              children: <Widget>[
                                sale_price==""?Text("售价:￥${widget.salePriceSection}"):
                                Text("售价:￥${sale_price}"),
                                widget.minVipPrice==null?
                                Container():
                                Container(
                                  margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(5)),
                                  child: Text(
                                    ' ￥${widget.minVipPrice}',
                                    style: TextStyle(fontSize: ScreenUtil().setSp(30), color: Color.fromRGBO(102, 096, 123, 1)),
                                  ),
                                ),
                              ],
                            ),//_result"+"${widget.img.join(',')
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Wrap(
                children: <Widget>[
                  Column(
                    children: standard(),
                  )
                ],
              ),
              Container(
                height: ScreenUtil().setHeight(300),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),bottom: ScreenUtil().setHeight(20)),
                      child: Text("购买数量",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)),),
                    ),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: <Widget>[
                       Container(
                         height: ScreenUtil().setHeight(50),
                         width: ScreenUtil().setWidth(50),
                         margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                         child: InkWell(
                           child: Center(child: Text("一",style: TextStyle(fontSize: ScreenUtil().setSp(20),color: Color.fromRGBO(171, 174, 176, 1)),),),
                           onTap: (){
                             setState(() {
                               if(quantity==1){
                                 quantity = 1;
                               }else{
                                 quantity--;
                               }
                             });
                           },
                         ),
                         decoration: BoxDecoration(
                             border: Border.all(width: 1,color: Color.fromRGBO(171, 174, 176, 1)),
                           borderRadius: BorderRadius.circular(5),
                         ),
                       ),
                       Container(
                         height: ScreenUtil().setHeight(50),
                         width: ScreenUtil().setWidth(50),
                         margin: EdgeInsets.only(
                           left: ScreenUtil().setWidth(10),
                           right: ScreenUtil().setWidth(10),
                         ),
                         child: Center(
                           child: Text("$quantity",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)),),
                         ),
                         decoration: BoxDecoration(
                           border: Border.all(width: 1,color: Color.fromRGBO(171, 174, 176, 1)),
                           borderRadius: BorderRadius.circular(5),
                         ),
                       ),
                       Container(
                         height: ScreenUtil().setHeight(50),
                         width: ScreenUtil().setWidth(50),
                         margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                         child: InkWell(
                           child: Icon(Icons.add,size: ScreenUtil().setSp(35),color: Color.fromRGBO(171, 174, 176, 1)),
                           onTap: (){
                             setState(() {
                               if( quantity>=inventory){
                                 quantity = quantity;
                                 if(inventory==0){
                                   Toast.show("当前库存为零", context, duration: 2, gravity: Toast.CENTER);
                                 }else{
                                   Toast.show("已添加到最多", context, duration: 2, gravity: Toast.CENTER);
                                 }
                               }else{
                                 quantity++;
                               }
                             });
                           },
                         ),
                         decoration: BoxDecoration(
                           border: Border.all(width: 1,color: Color.fromRGBO(171, 174, 176, 1)),
                           borderRadius: BorderRadius.circular(5),
                         ),
                       ),
                     ],
                   )
                  ],
                ),
              ),
            ],
          ),
          //底部
          bottom(),
        ],
      ),
    );
  }
//版本
  List<Widget> standard() {
    List<Widget> standar = [];
    List k = map.keys.toList();
    for(var i =0;i<map.length;i++){
      standar.add(
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      top: ScreenUtil().setHeight(10),
                    bottom: ScreenUtil().setHeight(20)
                  ),
                  child: Text("${k[i]}",style: TextStyle(fontSize: ScreenUtil().setSp(28),color: Color.fromRGBO(171, 174, 176, 1)),),
                ),
                Row(
                  children: sta(i),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      height: ScreenUtil().setHeight(40),
                    )
                  ],
                ),
              ],
            ),
          )
      );
    }
    return standar;
  }

  List<Widget> sta(int index) {
    List v = map.values.toList();
    var list = v[index];
    List k = map.keys.toList();
//    var matrix = widget.sku;
//    var arr = [];
    List<Widget> standar = [];
    for(var j =0;j<list.length;j++){
      standar.add(
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(60),
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(5),bottom: ScreenUtil().setHeight(5),
                      left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(10)),
                  child: Center(
                    child: InkWell(
                      child: Text("${list[j]}",style: TextStyle(fontSize: ScreenUtil().setSp(28),
                          color: _versions[k[index]]==j?Color.fromRGBO(255, 255, 255, 1):mapLabel[k[index]][j]==1?Colors.white:Color.fromRGBO(171, 174, 176, 1)
                      ),),
                      onTap: (){
                        if(mapLabel[k[index]][j]==1){
                          return null;
                        }else{
                          setState(() {
                            _versions[k[index]] = _versions[k[index]]==j?-1:j;
                            var format = widget.sku;
                            for (var obj in format) {//规格处理
                              if(int.parse(obj["stock"])==0){
                                continue;
                              }
                              obj.forEach((ley, val){
                                var arr = map[ley]!=null&&map[ley].toString().length>0?map[ley]:[];
                                if (val!=null  && val.toString().length>0 && arr.indexOf(val)==-1&&int.parse(obj["stock"])>0) {
                                  arr.add(val);
                                }
                                if ("SKU" != ley&&"markting_price"!= ley&&"original_price" != ley&&"vip_price" != ley
                                    &&"sale_price" != ley&&"stock" != ley) {
                                  var data = {ley: arr};
                                  var array = [];
                                  for(var a in arr){
                                    array.add(0);// 0显示
                                  }
                                  map.addAll(data);
                                  mapLabel.addAll({ley:array});
                                }
                              });
                            }
                            _versions.forEach((ley, item)=>{
                              if(item != -1){
                                show(_versions.keys.toList().indexOf(ley), item),
                              }
                            });

                            if(_styles.indexOf(list[j])==-1){
                              _styles[index]=list[j];
                            }else{
                              _styles[index] = "";
                              inventory = 0;
                            }
                           if(_styles.indexOf("")==-1){
                             for(var item in widget.sku){
                               String sku = item.toString();
                               bool bo = true;
                               for(var itam in _styles){

                                 if(!sku.contains(itam) || int.parse(item['stock'])<=0){
                                   bo = false;
                                   break;
                                 }
                               }
                               if(bo){
                                 matchId = item["SKU"];//给sku赋值
                                 _getStockBySkus(matchId);
                                 sale_price = item["sale_price"].toString();//售价
                                 SkuIds = [];
                                 for(var i=0;i<matchId.length;i++){
                                   SkuIds.add(matchId[i]["skuId"]);
                                 }
                               }
                             }
                           }
                          });
                        }
                      },
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: _versions[k[index]]==j?Color(0xff68627e):mapLabel[k[index]][j]==1?Color(0xffdfdee3):Colors.white,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      width: 1,
                      color: _versions[k[index]]==j?Color(0xff68627e):mapLabel[k[index]][j]==1?Color(0xffdfdee3):Color(0xff68627e),
                    )
                  ),
                )
              ],
            ),
          )
      );
    }
    return standar;
  }
  //底部
  Widget bottom(){
    var size = MediaQuery.of(context).size;
    var widths = size.width;
    return widget.purchase==false?
    Align(
        alignment: FractionalOffset.bottomCenter,
        child:Container(
            height: ScreenUtil().setHeight(100),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: Colors.black12,width: 1.0)
                )
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: widths*0.8,
                  height: ScreenUtil().setHeight(80),
                  child: InkWell(
                    child: Center(child: Text("确定",style: TextStyle(color: Colors.white),),),
                    onTap: (){
                    // skuId,商品Id,店铺Id ,商品规格,商品数量
                      if(inventory==0){//||stock.length ==0
                        return null;
                      }else{
                        if(widget.enableMatrix!=true){
                          push.addAll(widget.sku[0]);
                        }
                        widget.enableMatrix==true?
                        _adds(SkuIds,widget.commodityId.toString(),"1",push,quantity):
                        _addsNone(widget.sku,widget.commodityId.toString(),"1",quantity);
                      }
                    },
                  ),
                  decoration: BoxDecoration(
                      color:inventory==0?Colors.grey:Color(0xff68627E),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                ),
              ],
            )
        )
    ):
    Align(
        alignment: FractionalOffset.bottomCenter,
        child:Container(
            height: ScreenUtil().setHeight(100),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: Colors.black12,width: 1.0)
                )
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: widths*0.8,
                  height: ScreenUtil().setHeight(80),
                  child: InkWell(
                    child: Center(child: Text("确定",style: TextStyle(color: Colors.white),),),
                    onTap: (){
                      // skuId,商品Id,店铺Id ,商品规格,商品数量
                      if(inventory==0){//||stock.length ==0
                        return null;
                      }else{
                        Navigator.pop(context);
                        print("SkuIds$SkuIds");
                        widget.enableMatrix==true?
                        _addOrderView(SkuIds,widget.commodityId.toString(),"1",push,quantity):
                        _addOrderView(SkuId,widget.commodityId.toString(),"1",push,quantity);
                      }
                    },
                  ),
                  decoration: BoxDecoration(
                      color:inventory==0?Colors.grey:Color(0xff68627E),
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                ),
              ],
            )
        )
    );
  }
  //widget.purchase==null?
//    Align(
//        alignment: FractionalOffset.bottomCenter,
//        child:Container(
//            height: ScreenUtil().setHeight(100),
//            decoration: BoxDecoration(
//                color: Colors.white,
//                border: Border(
//                    top: BorderSide(color: Colors.black12,width: 1.0)
//                )
//            ),
//            child: Row(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                Expanded(child: InkWell(
//                  child: Container(
//                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(40),right: ScreenUtil().setWidth(40),
//                        top: ScreenUtil().setHeight(10),bottom: ScreenUtil().setHeight(10)),
//                    child: Center(
//                      child: Text("立即购买",style: TextStyle(color: Colors.white)),
//                    ),
//                    decoration: BoxDecoration(
//                      color: Color.fromRGBO(049, 049, 049, 1),
//                      borderRadius: BorderRadius.circular(10),
//                    ),
//                  ),
//                  onTap: (){
//                    // skuId,商品Id,店铺Id ,商品规格,商品数量
//                    if(inventory==0){//||stock.length ==0
//                      return null;
//                    }else{
//                      widget.enableMatrix==true?
//                      _addOrderView(SkuIds,widget.commodityId.toString(),"1",push,quantity):
//                      _addOrderView(SkuId,widget.commodityId.toString(),"1",push,quantity);
//                    }
//                  },
//                )),
//                Expanded(child: InkWell(
//                  child: Container(
//                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(40),right: ScreenUtil().setWidth(40),
//                        top: ScreenUtil().setHeight(10),bottom: ScreenUtil().setHeight(10)),
//                    child: Center(
//                      child: Text("加入购物车",style: TextStyle(color: Colors.white),),
//                    ),
//                    decoration: BoxDecoration(
//                      color: Color.fromRGBO(104, 098, 126, 1),
//                      borderRadius: BorderRadius.circular(10),
//                    ),
//                  ),
//                  onTap: (){
//                    // skuId,商品Id,店铺Id ,商品规格,商品数量
//                    if(inventory==0){
//                      return null;
//                    }else{
//                      widget.enableMatrix==true?
//                      _adds(SkuIds,widget.commodityId.toString(),"1",push,quantity):
//                      _adds(SkuId,widget.commodityId.toString(),"1",push,quantity);
//                    }
//                  },
//                )),
//              ],
//            )
//        )
//    ):
}