import 'package:flutter/material.dart';

class ShopCartModel with ChangeNotifier {

  List<Map> _shopList = [
    {
      "picture": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1569235880708&di=ab36921edcf87a1a5b3fdc7ab9c32334&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201505%2F12%2F20150512213058_GLvaf.thumb.224_0.jpeg",
      "title": "这是一条商品简介，超出部分会不显示最多两行，超出部分会不显示最多两行",
      "isCheck": false,
      "price": 60.00,
      "count": 1,
      "specification": "规格字段"
    },
    {
      "picture": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1569235860746&di=437c0fcb06d610e66557b2e55c5de051&imgtype=0&src=http%3A%2F%2Fimage.biaobaiju.com%2Fuploads%2F20180801%2F00%2F1533054791-GJXLDmZdWB.jpg",
      "title": "这是一条商品简介，超出部分会不显示最多两行，超出部分会不显示最多两行",
      "isCheck": false,
      "price": 70.00,
      "count": 3,
      "specification": "规格字段"
    },
    {
      "picture": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1569235880708&di=ab36921edcf87a1a5b3fdc7ab9c32334&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201505%2F12%2F20150512213058_GLvaf.thumb.224_0.jpeg",
      "title": "这是一条商品简介，超出部分会不显示最多两行，超出部分会不显示最多两行",
      "isCheck": false,
      "price": 60.00,
      "count": 1,
      "specification": "规格字段"
    },
    {
      "picture": "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1569235860746&di=437c0fcb06d610e66557b2e55c5de051&imgtype=0&src=http%3A%2F%2Fimage.biaobaiju.com%2Fuploads%2F20180801%2F00%2F1533054791-GJXLDmZdWB.jpg",
      "title": "这是一条商品简介，超出部分会不显示最多两行，超出部分会不显示最多两行",
      "isCheck": false,
      "price": 70.00,
      "count": 3,
      "specification": "规格字段"
    },
  ]; //购物车列表

  double _total = 0.0; //购物车合计

  bool allOptfor = false;//购物车全选
  get shopList => _shopList;
  get totals => _total;
  get allOptfors => allOptfor;
//修改是否选中
  void changeIscheck(int indexs,bool bols){
   _shopList[indexs]["isCheck"] = bols;
    notifyListeners();
    if( _shopList[indexs]["isCheck"] == false){
      allOptfor =false;
    }
  }
//计算购物车合计
  void totalsHeji(){
    double heji = 0.0;
    for(var i = 0; i < _shopList.length; i++){
      if(_shopList[i]["isCheck"] == true){
        heji +=_shopList[i]["price"]* shopList[i]["count"];
      }
    }
    this._total = heji;
    notifyListeners();
  }

  //购物车增加商品
  void addShopStore(int index, int count) {
    _shopList[index]["count"] = count;
    notifyListeners();
  }

  //全选 / 全不选
  void checkAll(bool bols)async{
    allOptfor = !allOptfor;
    for(var i = 0; i <_shopList.length; i++){
      _shopList[i]["isCheck"] = bols;

    }
    notifyListeners();
  }

  //删除所选

  void deleteShop() {

    var  _NewList = _shopList.where((_shopList) => _shopList["isCheck"] == false);
    if(_NewList.length != _shopList.length ){allOptfor = false;}
    _shopList = _NewList.toList();

    notifyListeners();
  }
}