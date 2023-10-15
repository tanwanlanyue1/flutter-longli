
import 'package:flutter/material.dart';
import 'package:flutter_widget_one/ui/home/sign/share_page.dart';
import 'package:flutter_widget_one/ui/myCenter/commodity/commodity_details.dart';
import 'package:flutter_widget_one/ui/shop/classify/second_classifyPage.dart';
import 'package:flutter_widget_one/untils/element/CustomList/BrandCustom.dart';
import 'package:flutter_widget_one/untils/element/CustomList/structure.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';

//decorationType: -1,// 
// 0自定义页 1商城页面 2品牌馆 3分类页(弃用) 4.商品详情 5分类页
// 6积分商城-积分兑换商品或券  7领券中心 8.会员中心 9.每日签到 10.文章详情
void PagesearchOnTab(Map item,context){
  print('item$item');
  print('item${item['decorationType']}');
  if(item['decorationType'] == null){
    print('类型出错，跳出！');
    return;
  }

  switch(item['decorationType']) {
    case 0:
      print('自定义页');
      Navigator.push(context, MaterialPageRoute(builder: (_) {return Structure(seachTitle: item['linkId'],);}));
    break;

    case 1:
      print('商城页面');
      Navigator.pushNamed(context, '/');
    break;

    case 2:
      print('品牌馆');
      Navigator.push(context, MaterialPageRoute(builder: (_) {return BrandCustom(BrandCustomID: item['linkId'],);}));
      break;

    case 3:
      print('分类页废弃');
      break;

    case 4:
      print('商品详情');
      Navigator.push(context, MaterialPageRoute(builder: (_) {return CommodityDetails(id: item['linkId'],);}));
      break;

    case 5:
      print('分类页');
      Map _val = {"id":item["linkId"]};
      Navigator.pushNamed(context, '/secondClassifyPage',arguments: _val);
      break;

    case 6:
      print('积分商城-积分兑换商品或券');
      break;

    case 7:
      print('领券中心');
      Navigator.pushNamed(context, '/couponPage');
      break;

    case 8:
      print('会员中心');
      List vipLog = [true,true];
      Navigator.pushNamed(context, '/vipCenterPage',arguments: vipLog);
      break;

    case 9:
      _checkSign(context);
      print('每日签到');
      break;

    case 10:
      print('文章详情');
      Navigator.pushNamed(context, '/ArticlePage', arguments: item["linkId"]);
      break;

    default:
      print('出错！');
    break;
  }
}
//判断是否签到
_checkSign(context)async{
  print('判断是否签到');
  var result = await HttpUtil.getInstance().get(
    servicePath['checkSign'],
  );
  if(result['code'] == 0){
    if(result['result']['isSignIn'] ==0){
      Navigator.pushNamed(context, '/signPage');
    }else{
      Navigator.push( context, new MaterialPageRoute(builder: (context) =>
          SharePage(
              day:result['result']['signIn']['signSeries'] ,
              mood:result['result']['signIn']['mood'],
              moodImg:result['result']['signIn']['moodImg'],
              moodPhrase:result['result']['signIn']['moodPhrase']
          )
      ),
      );
    }
  }else if(result['code'] == 401){
    Navigator.of(context).pushNamed('/LoginPage');
  }else{
    Toast.show("请重试", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
  }
}