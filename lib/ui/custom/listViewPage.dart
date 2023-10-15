import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import '../../untils/tools/banner/banner_card.dart';
import '../../untils/tools/goods/goods_card.dart';
import '../../untils/tools/discountCoupon/discountCoupon_card.dart';
import '../../untils/tools/hotphoto/hotphoto_card.dart';
import '../../untils/tools/picturew/picturew_card.dart';
import '../../untils/tools/pictures/pictures_card.dart';
import '../../untils/tools/gpictures/gpictures_card.dart';
import '../../untils/tools/tabbar/tabber_card.dart';

import '../../common/model/provider_vital.dart';
import 'package:provider/provider.dart';

class ListViewPage extends StatefulWidget {
  @override
  _ListViewPageState createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {

  int Index = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: skeleton()
    );
  }
  List<Widget> skeleton (){
    final _vitalModels = Provider.of<VitalModel>(context);

    List<Widget> lists = [];

    for(var i = 0; i <_vitalModels.PrototypeDatas["list"][0]["items"].length; i++){

      switch(_vitalModels.PrototypeDatas['list'][0]['items'][i]["id"]){

        case 'banner':
          lists.add(
              NowWidget(
                i,
                SwiperView(
//                  data:_vitalModels.PrototypeDatas['list'][0]['items'][i]["data"],
                ),
              ),
          );
          break;

        case "goods":
          lists.add(
              NowWidget(
                i,
                GoodsCard(
                col:_vitalModels.PrototypeDatas['list'][0]['items'][i]["data"]["col"],
                data:_vitalModels.PrototypeDatas['list'][0]['items'][i]["data"]["data"],
              ),
              ),
          );
          break;

        case "coupon":
          lists.add(
            NowWidget(
                i,
                DiscountCouponCard(
                  col: _vitalModels.PrototypeDatas['list'][0]['items'][i]["data"]["col"],
                  data: _vitalModels.PrototypeDatas['list'][0]['items'][i]["data"]["list"],
                )
            ),
          );
          break;

        case "hotphoto":
          lists.add(
              NowWidget(
                  i,
                  HotphotoCard(
                    img:_vitalModels.PrototypeDatas['list'][0]['items'][i]["imgurl"],
                    data:_vitalModels.PrototypeDatas['list'][0]['items'][i]["data"],
                  )
              ),

          );
          break;

        case "picturew":
          lists.add(
              NowWidget(
                  i,
                  picturewCard(
                    data: _vitalModels.PrototypeDatas['list'][0]['items'][i]["list"],
                  )
              ),
          );
          break;

        case "pictures":
          lists.add(
              NowWidget(
                  i,
                  PicturesCard(
//                    data:_vitalModels.PrototypeDatas['list'][0]['items'][i]["list"],
                  )
              ),

          );
          break;

        case "gpictures":
          lists.add(
              NowWidget(
                  i,
                  GpicturesCard(
                    data:_vitalModels.PrototypeDatas['list'][0]['items'][i]["list"],
                  )
              ),
          );
          break;

        case "tabbar":
          lists.add(
              NowWidget(
                  i,
                  TabbarCard(
//                    data: _vitalModels.PrototypeDatas['list'][0]['items'][i]['list'],
                  )
              ),
          );
          break;

        default:
          lists.add(
              Container(
                height:20,
                child: Center(
                  child: Text('等待版本更新吧！！！后台出错啦！！！'),
                ),
              )
          );
          break;
      }
    }
    return lists;
  }

  Widget NowWidget(int i,Widget child){
    final _vitalModels = Provider.of<VitalModel>(context);
    return  Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            print(i);
            setState(() {
              Index = i;
            });
          },
          child: Container(
            margin: Index == i ? EdgeInsets.all(ScreenUtil().setWidth(10)) : null,
            decoration: BoxDecoration(
                border: Index == i ? Border.all(width: ScreenUtil().setWidth(4.0), color: Colors.deepOrange) : null
            ),
            child: Stack(
              children: <Widget>[
                child,
              ],
            ),
          ),
        ),
        Index == i ? Positioned(
          right: ScreenUtil().setWidth(15),
          bottom: ScreenUtil().setHeight(5),
          child: GestureDetector(
            onTap: () {
              _vitalModels.delateCommodity(i);
            },
            child: Image.asset("images/delete.png",width: ScreenUtil().setWidth(50),height:ScreenUtil().setHeight(60),),
          ),
        ) : Container(width: 0, height: 0,),
        Index == i ? Positioned(
          right: ScreenUtil().setWidth(100),
          bottom: ScreenUtil().setHeight(5),
          child: GestureDetector(
            onTap: () {

            },
            child: Image.asset("images/git.png",width: ScreenUtil().setWidth(40),height:ScreenUtil().setHeight(60),),
          ),
        ) : Container(width: 0, height: 0,),
        Index == i ? Positioned(
          right: ScreenUtil().setWidth(180),
          bottom: ScreenUtil().setHeight(5),
          child: GestureDetector(
            onTap: () {
              _vitalModels.moveUp(i);
              setState(() {
                Index = i==0 ? Index : --Index;
              });
            },
            child: Image.asset("images/up.png",width: ScreenUtil().setWidth(50),height:ScreenUtil().setHeight(60),),
          ),
        ) : Container(width: 0, height: 0,),
        Index == i ? Positioned(
          right: ScreenUtil().setWidth(260),
          bottom: ScreenUtil().setHeight(5),
          child: GestureDetector(
            onTap: () {
              _vitalModels.moveDown(i);
              setState(() {
               if(i + 1 < _vitalModels.PrototypeDatas["list"][0]["items"].length){
                 Index++;
               }
              });
            },
            child: Image.asset("images/down.png",width: ScreenUtil().setWidth(50),height:ScreenUtil().setHeight(60),),
          ),
        ) : Container(width: 0, height: 0,)
      ],
    );
  }
}
