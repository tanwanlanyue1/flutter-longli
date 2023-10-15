import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/common/model/provider_personal.dart';
import 'package:flutter_widget_one/untils/customTools/awit_tool/awitTools.dart';
import 'package:flutter_widget_one/untils/element/CustomList/decoration.dart';
import 'package:flutter_widget_one/untils/element/shop/CrosswiseMove.dart';
import 'package:provider/provider.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:toast/toast.dart';
import 'share_weixin.dart';
import 'ui_ScrollView.dart';
import 'add_ToShoppingCart.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import '../../../ui/myCenter/commodity/sku_page.dart';
import 'dart:convert' as convert;
import 'package:flutter_widget_one/ui/indexPage.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_widget_one/untils/element/bottomSheet/CustomBottomSheet.dart';
import 'comment.dart';
import 'package:flutter_widget_one/ui/myCenter/personal/adapter.dart';
class CommodityDetails extends StatefulWidget {
  int id;
  CommodityDetails({
    this.id,
});
  @override
  _CommodityDetailsState createState() => _CommodityDetailsState();
}
enum FormType {
  detailty,
  argument,
  explain,
}
class _CommodityDetailsState extends State<CommodityDetails> {
  static final _img = 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1568885928547&di=8c20f108ef2a436ccb0856fb7000dc60&imgtype=0&src=http%3A%2F%2Fimg5q.duitang.com%2Fuploads%2Fitem%2F201502%2F20%2F20150220235727_MLT5j.jpeg';
  bool _money = false;
  bool enableMatrix = true; //是否有规格
  Map _shopDetails = null; //商品数据
  List _specification = [];//规格
  List _listPicture = [];//轮播图片
  List matrix = [];//无规格
  List cartList = [];//购物车列表
  int cart = 0;//购物车的长度
  String _title = "";//标题
  String _subTitle="";//副标题
  int _virtualSale; //销量
  double _salePrice;//价格
  double _minVipPrice;//vip最低价格
  double _appBar = 0;
  String _picture;//商品详情图片
  String salePriceSection;//价格区间
  bool collection = false;//是否收藏
  int cardDataindex = 0;//轮播下标
  String brand = "";//品牌
  List _details = []; //商品详情装修
  List<Map> _titles = [
    {"image":_img},
    {"image":_img},
    {"image":_img},
    {"image":_img},
    {"image":_img},
    {"image":_img},
    {"image":_img},
    {"image":_img},
  ];
  FormType _form = FormType.detailty;

  var _Scontroller = new ScrollController(); //Listview控制器
  final PageController _controller = PageController(initialPage:0,);
  //监听
  _onScroll(offset){//这个是监听滚动列表的  也就是下拉的高度
    double alpha=(offset/2)/100;//alpha?appBar_scroll_offset;我觉得设置100即可，没必要声明一个常量
    if(alpha<0){
      alpha=0;
    }else if(alpha>1){
      alpha=1;
    }
    setState(() {
      _appBar=alpha;
    });
  }
//  收藏事件
  void _changeHearts(String commodityIds)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['addCollection'],
        data: {
          "commodityIds": commodityIds,
        } //地址id
    );
    if (result["code"] == 0) {
      Toast.show("已添加收藏", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      setState(() {
        collection = true;
      });
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
  // 取消收藏
  void _removeCollection(String commodityIds)async{
    var result = await HttpUtil.getInstance().post(
        servicePath['removeCollection'],
        data: {
          "commodityIds": commodityIds,
        } //地址id
    );
    if (result["code"] == 0) {
      Toast.show("修改成功", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
        setState(() {
          collection = false;
        });
    }else if(result["code"]==401){
      Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Navigator.pushNamed(context, '/LoginPage');
    }else {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
  //商品详情
  void _shopIdDetails()async{
//    print("商品ids:${widget.id}"); //82 85 单规格和无规格
    var result = await HttpUtil.getInstance().get(servicePath['shopDetails'] + "${widget.id}",);
    if(result["code"] == 0){
     var str2 = convert.jsonDecode(result["commodity"]['matrix']);
     setState(() {
       _shopDetails = result==null?[]:result;
       _specification = str2==null?[]:str2;
       _title = result["commodity"]["title"]==null||result["commodity"]["title"].length==0?"":result["commodity"]["title"];
       _subTitle = result["commodity"]["subTitle"]==null?"":result["commodity"]["subTitle"];
       _virtualSale = result["commodity"]["virtualSale"]==null?0:result["commodity"]["virtualSale"];
       _salePrice = result["commodity"]["minPrice"]==null?0.0:result["commodity"]["minPrice"].toDouble();
       _minVipPrice = result["commodity"]["minVipPrice"]==null?0.0:result["commodity"]["minVipPrice"].toDouble();
       _listPicture = result["commodity"]["thumbs"]==null?[]:convert.jsonDecode(result["commodity"]["thumbs"]);
       _picture = result["commodity"]["mainPic"]==null?"":result["commodity"]["mainPic"];
       salePriceSection = result["commodity"]["salePriceSection"]==null?"":result["commodity"]["salePriceSection"];
       collection = result["commodity"]["collection"]==null?false:result["commodity"]["collection"];
       brand = result["commodity"]["brand"]==null?false:result["commodity"]["brand"];
       _details = result["commodity"]["detailsId"] !=null&& result["commodity"]["detailsId"] != '' ? convert.jsonDecode(result["commodity"]["detailsId"])['item']:[];
//       print('==>s${ convert.jsonDecode(result["commodity"]["detailsId"])['item']}');
       if( result["commodity"]["enableMatrix"]==false){
         setState(() {
           enableMatrix = false;
           if(result["commodity"]["matrix"]!=null){
             for(var i=0;i<convert.json.decode(result["commodity"]["matrix"]).length;i++){
               matrix = convert.json.decode(result["commodity"]["matrix"])[i]["SKU"];
//               print(matrix);
             }
           }
         });
       }
     });
//     print("str2:${str2}");
    }else if(result["code"] == 500){
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      Navigator.pop(context);
    }
  }
  //查询购物车列表
  _cartList()async{
    var result = await HttpUtil.getInstance().get(
      servicePath['findCartList'],
    );
    if (result["code"] == 0) {
      print('==>$result');
      setState(() {
        cartList = result["result"]['orderCartList'];
//        cartList = result["result"];
        cart = cartList.length;
      });
    }else if (result["code"] == 500) {
      Toast.show("异常", context, duration: 2, gravity: Toast.CENTER);
    }
  }
  @override
  void initState() {
    _shopIdDetails();
    _cartList();
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    _Scontroller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
          child: Stack(
            children: <Widget>[
              NotificationListener( //监听滚动列表
                  onNotification: (scrollnotification) {
                    if (scrollnotification is ScrollNotification && scrollnotification.depth == 0
                        && scrollnotification.metrics.pixels.toDouble() < 200) { //意思就是找到下标为0个的时候，开始监听
                      //滚动且是列表滚动的时候
                      _onScroll(scrollnotification.metrics.pixels);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: Adapt.px(100)),
                    child: ListView(
                      controller: this._Scontroller,
                      children: <Widget>[
//                        UiScrollView(liImg : _listPicture),
                        lunbo(),
                        title(), //商品标题
                        money(), //开通赏金卡会员
                        more(), //说明
                        commercialStandard(), //商品规格
                        commodityComment(), //商品评论
                        groupRecommend(), //相似推荐
                        commodityDetails(),
                        DecorationPage(
                          data: _details,
                        ),
                      ],
                    ),
                  )
              ),
              Opacity1(), //顶部透明层1
              Opacity2(), //顶部透明层2
              buttonAll(), //底部栏
            ],
          )
      ),
    );
  }
  //顶部透明层1
  Widget Opacity1(){
    return Opacity(
      opacity:_appBar,//如果不传这个参数会报错，必须传的参数
      child: Container(
          height:Adapt.px(80),
          decoration: BoxDecoration(color: Color(0xfff1f1f1)),
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                child: Container(
                    width: ScreenUtil().setWidth(60),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xfff1f1f1)),
                    child: Image.asset("images/collect/collect2.png"),
                ),
                onTap: (){
                  Navigator.pop(context);
                },
              ),
//              Expanded(
//                child: Container(
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      InkWell(
//                        child:  Container(
//                          child: Text("商品"),
//                          margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
//                          padding: EdgeInsets.only(bottom: Adapt.px(5)),
//                        ),
//                        onTap: (){
//                          _Scontroller.jumpTo(0);
//                          _onScroll(0);
//                        },
//                      ),
//                      InkWell(
//                        child:  Container(
//                          child: Text("评论"),
//                          margin: EdgeInsets.only(right: ScreenUtil().setWidth(30)),
//                          padding: EdgeInsets.only(bottom: Adapt.px(5)),
//                        ),
//                        onTap: (){
//                          _Scontroller.jumpTo(Adapt.px(1100));
//                          _onScroll(200);
//                        },
//                      ),
//                      InkWell(
//                        child:  Container(
//                          child: Text("详情"),
//                          padding: EdgeInsets.only(bottom: Adapt.px(5)),
//                        ),
//                        onTap: (){
//                          _Scontroller.jumpTo(Adapt.px(1900));
//                          _onScroll(200);
//                        },
//                      ),
//
//                    ],
//                  ),
//                ),
//              ),
              Container(
                child: Row(
                  children: <Widget>[
                    InkWell(
                      child: Container(
                          width: ScreenUtil().setWidth(60),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xfff1f1f1)),
                          child: Image.asset("images/collect/collect1.png")
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
      ),
    );
  }
  //顶部透明层2
  Widget Opacity2(){
    return  Opacity(
      opacity: 1 - _appBar,//如果不传这个参数会报错，必须传的参数
      child: Container(
          height:Adapt.px(80),
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                child: Container(
                    width: ScreenUtil().setWidth(60),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Color.fromRGBO(0, 0, 0, 0.5)),
                    child: Image.asset("images/collect/collect2.png"),
                ),
                onTap: (){
                  Navigator.pop(context);
                },
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    InkWell(
                      child: Container(
                          width: ScreenUtil().setWidth(60),
//                          height: ScreenUtil().setWidth(50),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Color.fromRGBO(0, 0, 0, 0.5)),
                          child: Image.asset("images/collect/collect1.png"),
                      ),
                      onTap: (){
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return GestureDetector(
                                child: Container(
                                  height: Adapt.px(150),
                                  color: Color(0xfff1f1f1),
                                  child: ShareWeixin(),
                                ),
                                onTap: () => false,
                              );
                            });
                      },
                    ),
                  ],
                ),
              )
            ],
          )
      ),
    );
  }
  //头部轮播
  Widget lunbo(){
    return Stack(
      children: <Widget>[
        Container(
          height: Adapt.px(920),
        ),
        Container(
            height: Adapt.px(860),
            child: _listPicture.length > 0 ? Swiper(
              itemCount: _listPicture.length-1,
              viewportFraction: 1,
              scale: 1,
              autoplay: _listPicture.length > 0 ?true:false,
              itemBuilder: (BuildContext context, int index) {
                return _swipers(index+1);
              },
              //改变时做的事
              onIndexChanged: (int index) {
                setState(() {cardDataindex = index;});
              },
            ):AwitTools(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: circle(),
        ),
        collection == false ?
        Positioned(
            bottom: Adapt.px(0),
            right: ScreenUtil().setWidth(20),
            child:
            InkWell(
              child: Container(
                  width: ScreenUtil().setWidth(111),
                  child: Image.asset("images/collect/collect.png")
              ),
              onTap: (){
                _changeHearts(widget.id.toString());
              },
            ) ):
        Positioned(
            bottom: Adapt.px(10),
            right: ScreenUtil().setWidth(20),
            child:
            InkWell(
              child: Container(
                  width: ScreenUtil().setWidth(111),
                  child: Image.asset("images/collect/collect3.png")
              ),
              onTap: (){
                _removeCollection(widget.id.toString());
              },
            )
        ),
      ],
    );
  }
  //商品标题
  Widget title(){
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
             Expanded(
               child:  Text("$brand",style: TextStyle(fontSize: ScreenUtil().setSp(30),color: Color.fromRGBO(27, 27, 27, 1),
                 fontFamily: "思源"),
                 maxLines: 1, overflow: TextOverflow.ellipsis,),
             )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(20),
            top: ScreenUtil().setWidth(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: _title.length==0?Text(""):Text("$_title",style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
        _subTitle.length == 0 ?
        Container():
        Container(
          margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(20),
            top: ScreenUtil().setWidth(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text("$_subTitle",
                  style: TextStyle(fontSize: ScreenUtil().setSp(30),
                      color: Color.fromRGBO(196, 196, 196, 1)),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(20), top: Adapt.px(20)),
          padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(// '￥${_salePrice}',
                      '￥${salePriceSection}',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(40), color: Colors.black),
                    ),
                    Container(
                      width: ScreenUtil().setWidth(80),
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(30),bottom: Adapt.px(5)),
//                      padding: EdgeInsets.only(top: ScreenUtil().setWidth(2),bottom: Adapt.px(2)),
                      child: Center(
                        child: Text("VIP",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(26)),),
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(102, 096, 123, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    _minVipPrice == null ? Text("") :
                    Container(
                      margin: EdgeInsets.only(bottom: Adapt.px(5)),
                      child: Text(
                        ' ￥$_minVipPrice',
                        style: TextStyle(fontSize: ScreenUtil().setSp(30), color: Color.fromRGBO(102, 096, 123, 1)),
                      ),
                    ),
                  ],
                ),
              ),
//              Text(
//                "销量：${_virtualSale}+",
//                style: TextStyle(fontSize: ScreenUtil().setSp(25)),
//                maxLines: 1, overflow: TextOverflow.ellipsis,)
            ],),
        ),
      ],
    );
  }
 //轮播样式
  Widget _swipers(index){
    return index== 1
        ? Container(
            height: Adapt.px(860),
            decoration: BoxDecoration(
                color: Color(0xffDDDCE1),
                image: DecorationImage(
                    image: NetworkImage(ApiImg + _listPicture[index],),
                    fit: BoxFit.fill
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(Adapt.px(112)),),
            ),
          )
        : Container(
            height: Adapt.px(860),
            decoration: BoxDecoration(
                color: Color(0xffDFDEE3),
                borderRadius: BorderRadius.only(
                  bottomLeft:  Radius.circular(Adapt.px(112)),)
          ),
          child: Center(
            child: Container(
              height: ScreenUtil().setWidth(600),
              width: ScreenUtil().setWidth(600),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(ApiImg + _listPicture[index],),
                    fit: BoxFit.fill
                ),
              ),
            ),
          )
      );
  }
  //赏金卡会员
  Widget money(){
    return Container(
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(25)),
      margin: EdgeInsets.only(top: Adapt.px(20),),
      height: Adapt.px(150),
      child: Center(
        child: InkWell(
          child: Row(
            children: <Widget>[
              Text("珑梨会员下单9.5折，本次可节省￥xxx >",style: TextStyle(fontSize: ScreenUtil().setSp(25)),),
              SizedBox(width: ScreenUtil().setWidth(10),),
            ],
          ),
          onTap: (){},
        ),
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/collect/collect4.png"),
        )
      ),
    );
  }
  //说明 分类
  Widget more(){
    return  Container(
      padding: EdgeInsets.only(left:ScreenUtil().setWidth(40), right: ScreenUtil().setWidth(40)),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: ScreenUtil().setWidth(20), color: Color.fromRGBO(245, 245, 245, 1)))
      ),
      child: Row(
        children: <Widget>[
          Expanded(child: Text("精选好货",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),),
          Expanded(child: Text("超低折扣",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),),
          Expanded(child: Text("品牌授权",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),),
          Expanded(child: Text("满288包邮",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),),
        ],
      ),
    );
  }
  //商品规格
  Widget commercialStandard(){
   return Container(
      padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)),
      height: Adapt.px(80),
      child:Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
            child: Text("商品规格",style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(20),left: ScreenUtil().setWidth(20)),
            child: InkWell(
              child: Image.asset("images/collect/collect5.png"),
              onTap: (){
                showModalBottomSheet(
                    context: context,
                    backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Adapt.px(30)),
                        topRight: Radius.circular(Adapt.px(30)),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return GestureDetector(
                        child: enableMatrix==true?
                        Container(
                          margin: EdgeInsets.only(top:Adapt.px(30)),
                          color: Color.fromRGBO(255, 255, 255, 1),
                          child:  salePriceSection==""?SkuPage(_picture,_specification,widget.id,_salePrice.toString(),null,enableMatrix):
                          SkuPage(_picture,_specification,widget.id,salePriceSection,null,enableMatrix),
                        ):
                        Container(
                          margin: EdgeInsets.only(top:Adapt.px(30)),
                          color: Color.fromRGBO(255, 255, 255, 1),
                          child:  salePriceSection==""?SkuPage(_picture,matrix,widget.id,_salePrice.toString(),null,enableMatrix):
                          SkuPage(_picture,matrix,widget.id,salePriceSection,null,enableMatrix),
                        ),
                        onTap: () => false,
                      );
                    });
              },
            ),
          )
        ],
      ),
     decoration: BoxDecoration(
         border: Border(bottom: BorderSide(width: ScreenUtil().setWidth(20), color: Color.fromRGBO(245, 245, 245, 1)))
     ),
    );
  }
  //商品评论
  Widget commodityComment() {
    return Container(
      margin: EdgeInsets.only(
          top: Adapt.px(20),
      ),
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(20),
          right: ScreenUtil().setWidth(20),
          top: Adapt.px(10),
          bottom: Adapt.px(10)
      ),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: ScreenUtil().setWidth(20), color: Color(0xf1f1f1ff)))
      ),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: Adapt.px(10)),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                  child: Text("用户评论(1)",style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Spacer(),
                InkWell(
                  onTap: (){
//                    Navigator.pushNamed(context, '/comment');
                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                      return Comment(//跳转评论页
                        id: widget.id,
                        enableMatrix: enableMatrix,
                        picture: _picture,
                        salePriceSection: salePriceSection,
                        matrix: matrix,
                        specification:_specification,
                      );
                    }));
                  },
                  child: Container(
                  width:ScreenUtil().setWidth(160),
                  margin: EdgeInsets.only(right: Adapt.px(10),),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '更多', textAlign: TextAlign.end,
                          style: TextStyle(fontSize: ScreenUtil().setSp(24),color: Color.fromRGBO(171, 174, 176, 1)),
                        ),
                      ),
                      Container(
                          width: ScreenUtil().setWidth(60),
                          alignment: Alignment.center,
                          child: Image.asset("images/collect/collect5.png")),
                    ],
                  ),
                ),)
              ],
            ),
          ),
         Container(
           height: Adapt.px(280),
           child:  ListView.builder(
               scrollDirection: Axis.horizontal,
               itemCount:4,
               itemBuilder:(context,index){
                 return Container(
                   width: ScreenUtil().setWidth(580),
                   margin: EdgeInsets.all(ScreenUtil().setWidth(20)),
                   padding: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                   child: Row(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: <Widget>[
                       Expanded(
                           child:Column(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: <Widget>[
                               Container(
                                 child: Row(
                                   children: <Widget>[
                                     Container(
                                         width: ScreenUtil().setWidth(100),
                                         height: Adapt.px(100),
                                         decoration: BoxDecoration(
                                             shape: BoxShape.circle,
                                             image: DecorationImage(
                                                 image: NetworkImage(
                                                     'https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg'),
                                                 fit: BoxFit.cover
                                             )
                                         )
                                     ),
                                     Container(
                                       margin: EdgeInsets.only(
                                           left: ScreenUtil().setWidth(10)),
                                       child: Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: <Widget>[
                                           Container(
                                             child: Text("名字",style: TextStyle(color: Color(0xFFd2ae71),fontSize: ScreenUtil().setSp(30)),maxLines: 1,),
                                           ),
                                           Container(
                                             height: Adapt.px(40),
                                             child: Image.asset("images/collect/collect6.png"),
                                           ),
                                         ],
                                       ),
                                     ),
                                   ],
                                 ),
                               ),
                               Container(
                                 height: Adapt.px(80),
                                 margin: EdgeInsets.only(
                                     top: Adapt.px(10)),
                                 child: Text("想卖啥都行想卖啥都行想卖啥都行想卖啥都行想卖啥都行",
                                   style: TextStyle(
                                       fontSize: ScreenUtil().setSp(28)),
                                   overflow: TextOverflow.ellipsis,
                                   maxLines: 2,
                                 ),
                               ),
                             ],
                           ),),
                        Container(
                          height: Adapt.px(200),
                          width: ScreenUtil().setWidth(200),
                          margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(20),
                              right: ScreenUtil().setWidth(20)),
                          alignment: Alignment.bottomRight,
                          child: Container(
                            margin: EdgeInsets.only(right: Adapt.px(20),bottom: Adapt.px(20)),
                            padding: EdgeInsets.only(left: Adapt.px(15),right: Adapt.px(15)),
                            child: Text("3张",style: TextStyle(color: Colors.white,fontSize: Adapt.px(30)),),
                            decoration: BoxDecoration(
                              color: Color(0xff6C6C6E),
                            ),
                          ),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://pic2.zhimg.com/v2-639b49f2f6578eabddc458b84eb3c6a1.jpg")
                              ),
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(20))
                          ),
                        )
                     ],
                   ),
                   decoration: BoxDecoration(
                     border: Border.all(width: 1,color: Color.fromRGBO(171, 174, 176, 1)),
                      borderRadius: BorderRadius.circular(ScreenUtil().setWidth(15)
                   ))
                 );
               }
           ),
         ),
//          Row(
//            children: <Widget>[
//              Container(
//                margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
//                height: Adapt.px(100),
//                width: Adapt.px(100),
//                child: Image.network(_img,fit: BoxFit.cover,),
//              ),
//              Expanded(
//                  child: Container(
//                    margin: EdgeInsets.only(top: Adapt.px(20),left: ScreenUtil().setWidth(20)),
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        Text(" xxx",style: TextStyle(fontSize: ScreenUtil().setSp(25)),),
//                        Container(
//                          child:Image.asset("images/collect/collect6.png"),
//                        )
//                      ],
//                    ),
//                  ),
//              ),
//            ],
//          ),
//          Row(
//            children: <Widget>[
//            Expanded(
//                child: Container(
//                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: Adapt.px(20),right: ScreenUtil().setWidth(20)),
//                  child: Text("评论: 好喜欢 好想买 好评好评！！！",style: TextStyle(fontSize: ScreenUtil().setSp(25)),
//                    maxLines: 2,overflow: TextOverflow.ellipsis,),
//            )),
//            ],
//          ),
        ],
      ),
    );
  }
  //相似推荐
  Widget groupRecommend(){
    return Container(
      margin: EdgeInsets.only(top: Adapt.px(20),),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: ScreenUtil().setWidth(20), color: Color(0xf1f1f1ff)))
      ),
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(20),
          right: ScreenUtil().setWidth(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
         Container(
           child:  Text("相似推荐",style: TextStyle(fontSize: ScreenUtil().setSp(26),fontWeight: FontWeight.bold),),
           padding: EdgeInsets.only(bottom: Adapt.px(10)),
         ),
          CrosswiseMove()
        ]
      ),
    );
  }
  //商品详情
  Widget commodityDetails(){
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: ScreenUtil().setWidth(30.0),top: Adapt.px(100.0)),
          child: Row(
            children: <Widget>[
              InkWell(
                child: Container(child: Text('商品详情',style: TextStyle(color: _form == FormType.detailty?
                Colors.black:Color.fromRGBO(171, 174, 176, 1),
                    fontSize: ScreenUtil().setSp(30)),),),
                onTap: (){
                  setState(() {
                    _form = FormType.detailty;
                  });
                },),
              InkWell(
                child: Container(margin:EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                  child: Text('产品信息',style: TextStyle(color: _form == FormType.argument?
                  Colors.black:Color.fromRGBO(171, 174, 176, 1),
                      fontSize: ScreenUtil().setSp(30)),),),
                onTap: (){
                  setState(() {
                    _form = FormType.argument;
                  });
                },),
              InkWell(
                child: Container(margin:EdgeInsets.only(left: ScreenUtil().setWidth(30)),
                  child: Text('售后说明',style: TextStyle(color: _form == FormType.explain?
                  Colors.black:Color.fromRGBO(171, 174, 176, 1),
                      fontSize: ScreenUtil().setSp(30)),),),
                onTap: (){
                  setState(() {
                    _form = FormType.explain;
                  });
                },),
            ],
          ),),
        _form==FormType.detailty?_detailty():Column(
          children:_argument(),
        ),
      ],
    );
  }
  //商品详情
  Widget _detailty(){
    return Container(
      margin: EdgeInsets.all(ScreenUtil().setWidth(20)),
      child: _picture==""?Text(""):Image.network("${ApiImg+_picture.toString()}",fit: BoxFit.cover,),
    );
  }
  //产品信息
  List<Widget> _argument(){
    List<Widget> argument = [];
    for(var i=0;i<5;i++){
      argument.add(
        Container(
          margin: EdgeInsets.all(Adapt.px(25)),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                child: Text("品牌",style: TextStyle(fontSize: ScreenUtil().setSp(30),fontWeight: FontWeight.bold),),
              ),
              Expanded(child: Text("信息xxxx",maxLines: 1,style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)),))
            ],
          ),
        )
      );
    }
    return argument;
  }
  //底部栏目
  Widget buttonAll(){
    return Align(
        alignment: FractionalOffset.bottomCenter,
        child: Container(
          height: Adapt.px(100),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(color: Colors.black12, width: 1.0)
              )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: Adapt.px(60),
                      width: ScreenUtil().setWidth(50),
                      margin: EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: InkWell(
                              child: Image.asset("images/collect/collect8.png",fit: BoxFit.cover,),
                              onTap: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => indexPage(index: 2)),
                                        (route) => route == null
                                );
                              },
                            ),
                          ),
                          cart==0?
                          Container():
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              height: Adapt.px(25),
                              width: ScreenUtil().setWidth(25),
                              child: Center(
                                child: cart>99?
                                Text("99+",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(15)),):
                                Text("$cart",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(15)),),
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xff6C6781),
                                borderRadius: BorderRadius.circular(Adapt.px(15)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: Adapt.px(50),
                      child: Image.asset("images/collect/collect9.png"),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            customShowModalBottomSheet(
                                context: context,
                                backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        Adapt.px(30)),
                                    topRight: Radius.circular(
                                        Adapt.px(30)),
                                  ),
                                ),
                                builder: (BuildContext context) {
                                  return GestureDetector(
                                    child: enableMatrix == true ?
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          height: Adapt.px(6),
                                          width: ScreenUtil().setWidth(180),
                                          margin: EdgeInsets.only(
                                              top: Adapt.px(20)
                                          ),
                                          decoration: BoxDecoration(
                                              color: Color(0xffF1F1F1),
                                              borderRadius: BorderRadius.circular(Adapt.px(10))
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(top: Adapt.px(30)),
                                            color: Color.fromRGBO(255, 255, 255, 1),
                                            //_salePrice _minVipPricevip价格
                                            child: salePriceSection == "" ? SkuPage(_picture, _specification,
                                                widget.id, _salePrice.toString(), true, enableMatrix) :
                                            SkuPage(_picture, _specification,
                                                widget.id, salePriceSection,
                                                true, enableMatrix),
                                          ),
                                        )
                                      ],
                                    )
//                                        //原sku规格
////                                        Container(
////                                          margin: EdgeInsets.only(top: Adapt.px(30)),
////                                          color: Color.fromRGBO(255, 255, 255, 1),//_salePrice _minVipPricevip价格
////                                            child: salePriceSection==""?SkuPage(_picture,_specification,widget.id,_salePrice.toString(),true,enableMatrix):
////                                            SkuPage(_picture,_specification,widget.id,salePriceSection,true,enableMatrix),
////                                        )
                                        : Column(
                                      children: <Widget>[
                                        Container(
                                          height: Adapt.px(10),
                                          width: ScreenUtil().setWidth(180),
                                          margin: EdgeInsets.only(
                                              top: Adapt.px(20)
                                          ),
                                          decoration: BoxDecoration(
                                              color: Color(0xffF1F1F1),
                                              borderRadius: BorderRadius
                                                  .circular(
                                                  Adapt.px(10))
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: Adapt.px(
                                                    30)),
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1), //_salePrice
                                            child: salePriceSection == ""
                                                ? SkuPage(
                                                _picture, matrix, widget.id,
                                                _salePrice.toString(), true,
                                                enableMatrix)
                                                :
                                            SkuPage(_picture, matrix, widget.id,
                                                salePriceSection, true,
                                                enableMatrix),
                                          ),
                                        )
                                      ],
                                    ),
                                    //原sku规格
//                                            Container(
//                                              margin: EdgeInsets.only(top: Adapt.px(30)),
//                                              color: Color.fromRGBO(255, 255, 255, 1),//_salePrice
//                                              child: salePriceSection==""?SkuPage(_picture,matrix,widget.id,_salePrice.toString(),true,enableMatrix):
//                                              SkuPage(_picture,matrix,widget.id,salePriceSection,true,enableMatrix),
//                                            ),
                                    onTap: () => false,
                                  );
                                });
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(20),
                              right: ScreenUtil().setWidth(25),
                            ),
                            width: ScreenUtil().setWidth(230),
                            height: Adapt.px(90),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(049, 049, 049, 1),
//                                  borderRadius: BorderRadius.only(topRight: Radius.circular(20.0),bottomRight:Radius.circular(20.0)),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text('立即购买', style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,),),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            customShowModalBottomSheet(
                                context: context,
                                backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(Adapt.px(30)),
                                    topRight: Radius.circular(Adapt.px(30)),
                                  ),
                                ),
                                builder: (BuildContext context) {
                                  return GestureDetector(
                                    child: enableMatrix == true ?
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          height: Adapt.px(6),
                                          width: ScreenUtil().setWidth(180),
                                          margin: EdgeInsets.only(
                                              top: Adapt.px(20)
                                          ),
                                          decoration: BoxDecoration(
                                              color: Color(0xffF1F1F1),
                                              borderRadius: BorderRadius
                                                  .circular(Adapt.px(10))
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: Adapt.px(
                                                    20)),
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                            child: salePriceSection == ""
                                                ? SkuPage(
                                                _picture, _specification,
                                                widget.id,
                                                _salePrice.toString(), false,
                                                enableMatrix)
                                                :
                                            SkuPage(_picture, _specification,
                                                widget.id, salePriceSection,
                                                false, enableMatrix),
                                          ),
                                        )
                                      ],
                                    )
//                                        原sku规格
//                                        Container(
//                                          margin: EdgeInsets.only(top: Adapt.px(30)),
//                                          color: Color.fromRGBO(255, 255, 255, 1),
//                                          child:  salePriceSection==""?SkuPage(_picture,_specification,widget.id,_salePrice.toString(),false,enableMatrix):
//                                          SkuPage(_picture,_specification,widget.id,salePriceSection,false,enableMatrix),
//                                        )
                                        : Column(
                                      children: <Widget>[
                                        Container(
                                          height: Adapt.px(6),
                                          width: ScreenUtil().setWidth(180),
                                          margin: EdgeInsets.only(
                                              top: Adapt.px(20)
                                          ),
                                          decoration: BoxDecoration(
                                              color: Color(0xffF1F1F1),
                                              borderRadius: BorderRadius
                                                  .circular(
                                                  Adapt.px(10))
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: Adapt.px(
                                                    20)),
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                            //salePriceSection 价格
                                            child: salePriceSection == ""
                                                ? SkuPage(
                                                _picture, matrix, widget.id,
                                                _salePrice.toString(), false,
                                                enableMatrix)
                                                :
                                            SkuPage(_picture, matrix, widget.id,
                                                salePriceSection, false,
                                                enableMatrix),
                                          ),
                                        )
                                      ],
                                    ),
//                                        Container(
//                                          margin: EdgeInsets.only(top: Adapt.px(30)),
//                                          color: Color.fromRGBO(255, 255, 255, 1),//salePriceSection 价格
//                                          child:  salePriceSection==""?SkuPage(_picture,matrix,widget.id,_salePrice.toString(),false,enableMatrix):
//                                          SkuPage(_picture,matrix,widget.id,salePriceSection,false,enableMatrix),
//                                        ),
                                    onTap: () => false,
                                  );
                                });
                          },
                          child: Container(
                            width: ScreenUtil().setWidth(230),
                            height: Adapt.px(90),
                            margin: EdgeInsets.only(right: Adapt.px(25),),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(104, 098, 126, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text('加入购物车', style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold,),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              )
            ],
          ),
        )
    );
  }
  //底部的小点点
  List<Widget> circle(){
    List<Widget> circleA = [];
    for (var i = 0; i < _listPicture.length-1; i++) {
      circleA.add(
        Container(
          height: Adapt.px(820),
          alignment: Alignment.bottomCenter,
          child: InkWell(
            child: cardDataindex == i?
            Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
              height: Adapt.px(10),
              width: Adapt.px(28),
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 1),
                borderRadius: BorderRadius.circular(20),
              ),
            ):
            Container(
              margin: EdgeInsets.only(right: ScreenUtil().setWidth(15)),
              height: Adapt.px(10),
              width: Adapt.px(10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(114, 116, 122, 1),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      );
    }
    return circleA;
  }
}
