import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:flutter_widget_one/ui/myCenter/commodity/commodity_details.dart';
import "package:flutter_widget_one/untils/httpRequest/http_url.dart";
class CrosswiseMove extends StatefulWidget {
  final data;
  final callback;
  CrosswiseMove({
    this.data,
    this.callback = null,
  });
  @override
  _CrosswiseMoveState createState() => _CrosswiseMoveState();
}

class _CrosswiseMoveState extends State<CrosswiseMove> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('CrosswiseMove,data==>${widget.data}');
    data = widget.data == null ? data : widget.data;

  }
  List data = [
    {"mainPic":"pg_c244", "title":"这是珑梨派商品标题两行超出不显示省略","minPrice":"123","minVipPrice":"288"},
    {"mainPic":"pg_c244", "title":"这是珑梨派商品标题两行超出不显示省略","minPrice":"23","minVipPrice":"2880"},
    {"mainPic":"pg_c244", "title":"这是商品标题","minPrice":"4343","minVipPrice":"2880"},
  ];

  // 商品详情
  _OnTabGoods(val){
//    print('货架组件val==》$val');
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return CommodityDetails(id: val['id'],);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      color: Colors.white,
      height: ScreenUtil().setHeight(470),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
              itemCount:data.length,
              itemBuilder:(context,index){
                String img = data[index]["mainPic"] !=null?data[index]["mainPic"]:'pg_4a5b';
                return InkWell(
                  onTap: (){
                    widget.callback ==null
                        ?_OnTabGoods(data[index])
                        :widget.callback(data[index]);
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(280),
                    margin: EdgeInsets.only(
                      top: ScreenUtil().setHeight(10),
                      bottom: ScreenUtil().setHeight(10),
                      left: ScreenUtil().setHeight(15),
                      right: ScreenUtil().setHeight(15),
                    ),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(280),
                          height: ScreenUtil().setWidth(280),
                          decoration: BoxDecoration(
                              color: Color(0xffF2F2F2),
                              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(15))
                          ),
                          child: Center(
                              child: Container(
                                width: ScreenUtil().setWidth(240),
                                height: ScreenUtil().setWidth(240),
                                child: CachedNetworkImage(
                                  imageUrl: ApiImg + img,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) =>Container(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
//                                Image.network(ApiImg + img,fit: BoxFit.fill,),
                              )
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(5),
                            left: ScreenUtil().setHeight(5),
                            right: ScreenUtil().setHeight(5),
                          ),
                          child: Text('${data[index]["title"]}',style: TextStyle(fontSize: ScreenUtil().setSp(28),),maxLines: 2,textAlign: TextAlign.left,overflow: TextOverflow.ellipsis,),
                        ),
                        Row(
                          children: <Widget>[
                            Text('￥${data[index]["minPrice"]}', style: TextStyle(
                                fontSize: ScreenUtil().setSp(30),
                                color: Color(0xff02253B)),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,),
                            Padding(
                                padding: EdgeInsets.only(
                                  top:ScreenUtil().setHeight(10),
                                  left: ScreenUtil().setHeight(10),
                                ),
                                child:Container(
                                  width: ScreenUtil().setWidth(25),
                                  height: ScreenUtil().setWidth(25),
                                  child: Image.asset('images/shop/mony.png',fit: BoxFit.fill,),
                                )
                            ),
                           Expanded(
                             child:  Padding(
                                 padding: EdgeInsets.only(
                                   top: ScreenUtil().setHeight(10),
                                 ),
                                 child:Text('￥${data[index]['minVipPrice']}', style: TextStyle(
                                     fontSize: ScreenUtil().setSp(25),
                                     color: Color(0xff78748F)),
                                   maxLines: 1,
                                   overflow: TextOverflow.ellipsis,
                                 )
                             ),
                           )
                          ],
                        )
//                        Padding(
//                          padding: EdgeInsets.only(
//                            left: ScreenUtil().setHeight(5),
//                            right: ScreenUtil().setHeight(5),
//                          ),
//                          child: Text("minVipPrice立减 ￥${data[index]["minVipPrice"]}",style: TextStyle(fontSize: ScreenUtil().setSp(25),color: Color(0xffB8B7BE)),maxLines: 1,textAlign: TextAlign.center,),
//                        )
                      ],
                    ) ,
                  ),
                );
        }
//        children: <Widget>[
//          Container(
//            width: ScreenUtil().setWidth(280),
////            color: Colors.red,
//            margin: EdgeInsets.only(
//              top: ScreenUtil().setHeight(25),
//              bottom: ScreenUtil().setHeight(25),
//              left: ScreenUtil().setHeight(15),
//              right: ScreenUtil().setHeight(15),
//            ),
//            child:Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              children: <Widget>[
//                Container(
//                  width: ScreenUtil().setWidth(280),
//                  height: ScreenUtil().setWidth(280),
//                  decoration: BoxDecoration(
//                      color: Color(0xffF2F2F2),
//                      borderRadius: BorderRadius.circular(ScreenUtil().setWidth(15))
//                  ),
//                  child: Center(
//                    child: Container(
//                      width: ScreenUtil().setWidth(240),
//                      height: ScreenUtil().setWidth(240),
//                      child: Image.asset("images/moods/LOGO.png"),
//                    )
//                  ),
//                ),
//                Padding(
//                  padding: EdgeInsets.only(
//                      top: ScreenUtil().setHeight(25),
//                      left: ScreenUtil().setHeight(5),
//                      right: ScreenUtil().setHeight(5),
//                  ),
//                  child: Text("这是标题顶顶顶顶是",style: TextStyle(fontSize: ScreenUtil().setSp(30),),maxLines: 1,textAlign: TextAlign.center,),
//                ),
//                Padding(
//                  padding: EdgeInsets.only(
//                    left: ScreenUtil().setHeight(5),
//                    right: ScreenUtil().setHeight(5),
//                  ),
//                  child: Text("￥3540",style: TextStyle(fontSize: ScreenUtil().setSp(30),),maxLines: 1,textAlign: TextAlign.center,),
//                ),
//                Padding(
//                  padding: EdgeInsets.only(
//                    left: ScreenUtil().setHeight(5),
//                    right: ScreenUtil().setHeight(5),
//                  ),
//                  child: Text("minVipPrice立减 ￥2880！",style: TextStyle(fontSize: ScreenUtil().setSp(25),color: Color(0xffB8B7BE)),maxLines: 1,textAlign: TextAlign.center,),
//                )
//              ],
//            ) ,
//          ),
//                 ],
      ),
    );
  }
}
