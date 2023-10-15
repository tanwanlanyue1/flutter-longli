import 'package:flutter/material.dart';
import '../customData/prototype_data.dart';
class VitalModel with ChangeNotifier {

  Map PrototypeData = Map<String, dynamic>.from(Prototype);//自定义页面的初始化数据
  bool colors1 = false;//颜色面板开关

  get PrototypeDatas => PrototypeData;
  get colorsButton => colors1;
//  get pageColors => pageColors;

  //修改页面标题
  void setTitle(String str) {
    PrototypeData['title'] = str;
    notifyListeners();
  }
  //控制颜色面板显示隐藏
  void setColors1(bool bools){
    colors1 = bools;
    notifyListeners();
  }

//  背景色
  void setBackground(String a) {
    PrototypeData["list"][0]["page"]["background"] = a;
    notifyListeners();
  }

  //添加商品组
  void addCommodity(int a) {
    PrototypeData["list"][0]["items"].add(
      {
        "id": "goods",
        "data": {
          "col": a,
          "data": [
            {
              "thumb": "https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-1.jpg",
              "price": null,
              "productprice": "15000.00",
              "title": "这里是商品标题",
              "sales": "0",
              "gid": "",
              "bargain": 0,
              "credit": 0,
              "ctype": 1
            },
            {
              "thumb": "https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-2.jpg",
              "price": null,
              "productprice": "99.00",
              "title": "这里是商品标题",
              "sales": "0",
              "gid": "",
              "bargain": 0,
              "credit": 0,
              "ctype": 1
            },
            {
              "thumb": "https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-3.jpg",
              "price": null,
              "productprice": "99.00",
              "sales": "0",
              "title": "这里是商品标题",
              "gid": "",
              "bargain": 0,
              "credit": 0,
              "ctype": 0
            },
            {
              "thumb": "https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-4.jpg",
              "price": null,
              "productprice": "99.00",
              "title": "这里是商品标题",
              "sales": "0",
              "gid": "",
              "bargain": 0,
              "credit": 0,
              "ctype": 1
            },
          ]
        }
      },
    );
    notifyListeners();
  }
  //删除组
  void delateCommodity(int a) {
    PrototypeDatas["list"][0]["items"].removeAt(a);
    notifyListeners();
  }
  //添加轮播图
  void addBanner(){
    PrototypeData["list"][0]["items"].add(
    {
    "id":"banner",
    "data":[
      {
      "imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/banner-1.jpg",
      "linkurl":""
      },
      {
        "imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/banner-2.jpg",
        "linkurl":""
      }
      ],
    }
    );
    notifyListeners();
  }
  //添加优惠券
  void addCoupon(int a){
    PrototypeData["list"][0]["items"].add(
      {
        "id":"coupon",
        "data":{
          "col":a,
          "list":[
            {
              "name":"优惠券名称",
              "desc":"满100元可用",
              "price":"89.90",
              "couponid":"",
              "background":"#fd5454",
              "bordercolor":"#fd5454",
              "textcolor":"#ffffff",
              "couponcolor":"#55b5ff",
              "coupontype":"全类品"
            },
            {
              "name":"优惠券名称",
              "desc":"满100元可用",
              "price":"89.90",
              "couponid":"",
              "background":"#ff9140",
              "bordercolor":"#ff9140",
              "textcolor":"#ffffff",
              "couponcolor":"#ff5555",
              "coupontype":"全类品"
            },
            {
              "name":"优惠券名称",
              "desc":"满100元可用",
              "price":"89.90",
              "couponid":"",
              "background":"#54b5fd",
              "bordercolor":"#54b5fd",
              "textcolor":"#ffffff",
              "couponcolor":"#ff913f",
              "coupontype":"全类品"
            },
          ]
        }
      },
    );
    notifyListeners();
  }
  //添加热区模块
  void addHotPhoto(){
    PrototypeDatas["list"][0]["items"].add(
      {
        "id":"hotphoto",
        "data":[
          {
            "title":"1",
            "top":"0",
            "left":"0",
            "width":"100",
            "height":"100",
            "linkurl":"1",
            "thumb":""
          },
        ],
        "imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-1.jpg"
      },
    );
    notifyListeners();
  }
  //添加图片橱窗
  void addPicturew(){
    PrototypeData["list"][0]["items"].add(
      {
        "id":"picturew",
        "list":[
          {
            "imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/cube-1.jpg",
            "linkurl":"pages/index/index"
          },
          {
            "imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/cube-2.jpg",
            "linkurl":"pages/index/index"
          },
          {
            "imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/cube-3.jpg",
            "linkurl":"pages/index/index"
          },
          {
            "imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/cube-4.jpg",
            "linkurl":"pages/index/index"
          }
        ]
      },
    );
    notifyListeners();
  }
  //添加展播图
  void addPictures(){
    PrototypeData["list"][0]["items"].add(
      {
        "id":"pictures",
        "list":[
          {
            "imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-1.jpg",
            "linkurl":"pages/index/index",
            "title":"标题1"
          },
          {
            "imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-2.jpg",
            "linkurl":"pages/index/index",
            "title":""
          },
          {
            "imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-4.jpg",
            "linkurl":"pages/index/index",
            "title":""
          }
        ]
      },
    );
    notifyListeners();
  }
  //添加商品橱窗
  void addGpictures(){
    PrototypeData["list"][0]["items"].add(
      {
        "id":"gpictures",
        "list":[
          {
            "title":"【熨纹紧致】JAMALFI平滑肤质淡化痘印提升面部光泽驻颜柠檬原液 30ml",
            "thumb":"https://shop.fdg1868.cn/attachment/images/1/2019/03/w313h922i2h6hi7gD26bFhD3G3198n.jpg",
            "price":"598.00",
            "gid":"131",
            "bargain":"0"
          },
          {
            "thumb":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-2.jpg",
            "price":null,
            "productprice":"99.00",
            "title":"这里是商品标题",
            "sales":"0",
            "gid":"",
            "bargain":0,
            "credit":0,
            "ctype":1
          },
          {
            "thumb":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-3.jpg",
            "price":null,
            "productprice":"99.00",
            "sales":"0",
            "title":"这里是商品标题",
            "gid":"",
            "bargain":0,
            "credit":0,
            "ctype":0
          },
          {
            "thumb":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-1.jpg",
            "price":null,
            "productprice":"99.00",
            "title":"这里是商品标题",
            "sales":"0",
            "gid":"",
            "bargain":0,
            "credit":0,
            "ctype":1
          }
        ]
      },
    );
    notifyListeners();
  }
  //选项卡
  void addTabber(){
    PrototypeData["list"][0]["items"].add(
        {
          "id":"tabbar",
          "list":[
            {
              "card_id":"text1",
              "tabbar_name":"选项1",
              "id":0,
              "data":[
                {
                  "title":"【熨纹紧致】JAMALFI平滑肤质淡化痘印提升面部光泽驻颜柠檬原液 30ml",
                  "thumb":"https://shop.fdg1868.cn/attachment/images/1/2019/03/w313h922i2h6hi7gD26bFhD3G3198n.jpg",
                  "price":"598.00",
                  "gid":"131",
                  "bargain":"0",
                  "cardid":"text1"
                },
                {
                  "title":"【熨纹紧致】JAMALFI平滑肤质淡化痘印提升面部光泽驻颜柠檬原液 30ml",
                  "thumb":"https://shop.fdg1868.cn/attachment/images/1/2019/03/w313h922i2h6hi7gD26bFhD3G3198n.jpg",
                  "price":"598.00",
                  "gid":"131",
                  "bargain":"0",
                  "cardid":"text1"
                },
                {
                  "title":"【熨纹紧致】JAMALFI平滑肤质淡化痘印提升面部光泽驻颜柠檬原液 30ml",
                  "thumb":"https://shop.fdg1868.cn/attachment/images/1/2019/03/w313h922i2h6hi7gD26bFhD3G3198n.jpg",
                  "price":"598.00",
                  "gid":"131",
                  "bargain":"0",
                  "cardid":"text1"
                },
                {
                  "title":"【熨纹紧致】JAMALFI平滑肤质淡化痘印提升面部光泽驻颜柠檬原液 30ml",
                  "thumb":"https://shop.fdg1868.cn/attachment/images/1/2019/03/w313h922i2h6hi7gD26bFhD3G3198n.jpg",
                  "price":"598.00",
                  "gid":"131",
                  "bargain":"0",
                  "cardid":"text1"
                },
              ]
            },
            {
              "card_id":"text2",
              "tabbar_name":"选项2",
              "id":1,
              "data":[
                {
                  "title":"【紧致毛孔】JAMALFI减少皱纹晒后修护阿玛菲奇迹面霜 50ml",
                  "thumb":"https://shop.fdg1868.cn/attachment/images/1/2019/03/yKgFTBW4F9yxiXbyFyGTyK48xZ9FzB.jpg",
                  "price":"498.00",
                  "gid":"147",
                  "bargain":"0",
                  "cardid":"text2"
                }
              ]
            },
            {
              "card_id":"text3",
              "tabbar_name":"选项3",
              "id":2,
              "data":[

              ]
            }
          ]
        }
    );
    notifyListeners();
  }


  //商品组中添加一项
  void addOneCommodity(int Index){
    PrototypeData["list"][0]["items"][Index]["data"]["data"].add(
      {
        "thumb": "https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-1.jpg",
        "price": null,
        "productprice": "99.00",
        "title": "这里是商品标题",
        "sales": "0",
        "gid": "",
        "bargain": 0,
        "credit": 0,
        "ctype": 1
      },
    );
    notifyListeners();
  }

//  Index： 第几组
//  i：第几项
//  str:键名
//  newStr：新数据

  //商品组中修改数据（需传入以上数据）
  void onChangeCommodity(int Index,int i,String str,String newStr){
    PrototypeData["list"][0]["items"][Index]["data"]["data"][i][str] = newStr;
    notifyListeners();
  }
  //商品组删除一项
  void deleteIndexData(int Index,int i,){
    PrototypeData["list"][0]["items"][Index]["data"]["data"].removeAt(i);
    notifyListeners();
  }

  //轮播组删除一项
  void deleteIndexBanner(int Index,int i,){
    PrototypeData["list"][0]["items"][Index]["data"].removeAt(i);
    notifyListeners();
  }
  //轮播组中添加一项
  void addOneBanner(int Index){
    PrototypeData["list"][0]["items"][Index]["data"].add(
      {
        "imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/banner-1.jpg",
        "linkurl":""
      },
    );
    notifyListeners();
  }

  //优惠券中添加一组
  void addOneCoupon(int Index){
    PrototypeData["list"][0]["items"][Index]["data"]["list"].add(
      {
        "name":"优惠券名称",
        "desc":"满100元可用",
        "price":"89.90",
        "couponid":"",
        "background":"#fd5454",
        "bordercolor":"#fd5454",
        "textcolor":"#ffffff",
        "couponcolor":"#55b5ff",
        "coupontype":"全类品"
      },
    );
    notifyListeners();
  }
  //优惠券中修改数据（需传入以上数据）
  void onChangeCoupon(int Index,int i,String str,String newStr){
    PrototypeData["list"][0]["items"][Index]["data"]["list"][i][str] = newStr;
    notifyListeners();
  }
  //优惠券中删除某一项数据
  void deleteCoupon(int Index,int i){
    PrototypeData["list"][0]["items"][Index]["data"]["list"].removeAt(i);
    notifyListeners();
  }

//  热区修改某一项
  void onChangeHotphoto(int Index,int i,String str,String newStr){
    PrototypeData["list"][0]["items"][Index]["data"][i][str] = newStr;
    notifyListeners();
  }
  //热区中添加一项
  void addOneHotphoto(int Index){
    PrototypeData["list"][0]["items"][Index]["data"].add(
      {
        "title":"1",
        "top":"0",
        "left":"0",
        "width":"100",
        "height":"100",
        "linkurl":"1",
        "thumb":""
      },
    );
    notifyListeners();
  }
//  热区中删除一项
  void deleteOneHotphoto(int Index,int i){
    PrototypeData["list"][0]["items"][Index]["data"].removeAt(i);
    notifyListeners();
  }

  //  图片橱窗添加一项
  void addOnePicturew(int index){
    PrototypeData["list"][0]["items"][index]["list"].add(
        {
          "imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/cube-1.jpg",
          "linkurl":"pages/index/index"
        });
    notifyListeners();
  }
  //  图片橱窗添加一项
  void deleteOnePicturew(int index,int i){
    PrototypeData["list"][0]["items"][index]["list"].removeAt(i);
    notifyListeners();
  }

  //展播图修改某一项
  void onChangePictures(int Index,int i,String str,String newStr){
    PrototypeData["list"][0]["items"][Index]["list"][i][str] = newStr;
    notifyListeners();
  }
  //展播图添加一项
  void addOnePictures(int index) {
    PrototypeData["list"][0]["items"][index]["list"].add(
        {
          "imgurl":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-4.jpg",
          "linkurl":"pages/index/index",
          "title":""
        }
    );
    notifyListeners();
  }
  //展播图删除一项
  void deleteOnePictures(int index,int i){
    PrototypeData["list"][0]["items"][index]["list"].removeAt(i);
    notifyListeners();
  }
  // 商品橱窗加添加一项
  void addOneGpictures(int index){
    PrototypeData["list"][0]["items"][index]["list"].add(
      {
        "thumb":"https://shop.fdg1868.cn/addons/ewei_shopv2/plugin/diypage/static/images/default/goods-2.jpg",
        "price":null,
        "productprice":"99.00",
        "title":"这里是商品标题",
        "sales":"0",
        "gid":"",
        "bargain":0,
        "credit":0,
        "ctype":1
      },
    );
    notifyListeners();
  }
  //商品橱窗删除一项
  void deleteOneGpictures(int index,int i){
    PrototypeData["list"][0]["items"][index]["list"].removeAt(i);
    notifyListeners();
  }
  //展播图修改某一项
  void onChangeGpictures(int Index,int i,String str,String newStr){
    PrototypeData["list"][0]["items"][Index]["list"][i][str] = newStr;
    notifyListeners();
  }
  // 选项卡添加一项
  void addOneTabber(int index){
    PrototypeData["list"][0]["items"][index]["list"].add(
      {
        "card_id":"text1",
        "tabbar_name":"选项卡",
        "id":0,
        "data":[
        ]
      },
    );
    notifyListeners();
  }
  // 选项卡修改某一项名字
  void onChangeTabber(int Index,int i,String newStr){
    PrototypeData["list"][0]["items"][Index]["list"][i]["tabbar_name"] = newStr;
    notifyListeners();
  }
  // 选项卡删除某一页中的某一项
  void deleteTabber(int index,int widgetI,int i){
    PrototypeData["list"][0]["items"][index]["list"][widgetI]["data"].removeAt(i);
    notifyListeners();
  }
  // 选项卡删除某一页
  void deleteTabberPage(int index,int widgetI){
    PrototypeData["list"][0]["items"][index]["list"].removeAt(widgetI);
    notifyListeners();
  }
  // 选项卡添加一页
  void addOneTabberShop(int index,int widgetI,){
    PrototypeData["list"][0]["items"][index]["list"][widgetI]["data"].add(
      {
        "title":"【熨纹紧致】JAMALFI平滑肤质淡化痘印提升面部光泽驻颜柠檬原液 30ml",
        "thumb":"https://shop.fdg1868.cn/attachment/images/1/2019/03/w313h922i2h6hi7gD26bFhD3G3198n.jpg",
        "price":"598.00",
        "gid":"131",
        "bargain":"0",
        "cardid":"text1"
      },
    );
    notifyListeners();
  }
  //上移
  void moveUp (int i){

    if(i > 0){
      int upIndex = i-1;//上一项下标
      Map upIndexData = PrototypeData["list"][0]["items"][upIndex];////上一项数据
      PrototypeData["list"][0]["items"][upIndex] = PrototypeData["list"][0]["items"][i];
      PrototypeData["list"][0]["items"][i] = upIndexData;
    }else{
      return;
    }
    notifyListeners();
  }
  //下移
  void moveDown(int i){
    if(i == PrototypeDatas["list"][0]["items"].length -1){
      return;
    }

    int upIndex = i+1;//上一项下标
    Map upIndexData = PrototypeData["list"][0]["items"][upIndex];////上一项数据
    PrototypeData["list"][0]["items"][upIndex] = PrototypeData["list"][0]["items"][i];
    PrototypeData["list"][0]["items"][i] = upIndexData;
    notifyListeners();
  }
}