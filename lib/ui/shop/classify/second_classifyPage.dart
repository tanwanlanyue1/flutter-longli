import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/untils/element/shop/CrosswiseMove.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../../../ui/myCenter/commodity/commodity_details.dart';
import 'package:flutter/services.dart';//只输入数字
import 'package:provider/provider.dart';
import 'package:flutter_widget_one/common/model/provider_brand.dart';
import 'all_brandPage.dart';
import '../../../ui/myCenter/commodity/share_weixin.dart';
import 'package:flutter_widget_one/untils/element/shop/GoodsOneTwoThree.dart';
class SecondClassifyPage extends StatefulWidget {
  final arguments;
  SecondClassifyPage({this.arguments,});
  _SecondClassifyPageState createState() => _SecondClassifyPageState();
}

class _SecondClassifyPageState extends State<SecondClassifyPage> {
  ScrollController _scrollController = ScrollController();//上拉刷新
  List _id = [];//判断是否从分类页面进来
  List _bra = [];//判断是否从品牌页面进来
  List _classify = [];//初始化赋值给这个数组
  List _brand = [];//筛选的品牌
  List _catagory = [];//筛选的分类
  List brand = [];//品牌
  List cataId = [];//分类的id
  List catacolo = [];//分类选中
  List brandcolo = [];//品牌选中
  List prefixs = [];//搜索建议
  String max = "";
  String min = "";
  String keys = "";
  int total = 0;//总数据条数
  int pag = 2; //分页
  bool synthesize = true;//综合
  bool sales = false;//销量
  bool end = false;//倒叙
  bool positive = false;//正序
  bool newest = false;//最新
  @override
  void initState() {
    if(widget.arguments['keywords'] != null){
      keys = widget.arguments["keywords"];
      _searchKeyWord(keys);
    }else if(widget.arguments["brandNameList"] !=null){
      _bra.add(widget.arguments["brandNameList"]);//判断从品牌页面进来
      brand.add(widget.arguments["brandNameList"]);
      _brandName(brand);
    }else{
      cataId.add(widget.arguments["id"]);//判断从分类页面进来
      _id.add(widget.arguments["id"]);//综合查询调用该分类id
      _searchSuggestion(cataId);
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        //表示你滚动的位置是否达到了最大滚动的位置也就是底部，如果是执行——loadData这个方法
        if(_classify.length<total){
//          synthesize = false;//综合
//          sales = false;//销量
//          end = false;//倒叙
//          positive = false;//正序
//          newest = true;//最新
          if(synthesize == true){
            //综合
            _searchPag(pag,_id,_bra,keys,"","");
          }else if(sales == true){
            //销量
            _searchPag(pag,_id,_bra,keys,"virtualSale","");
          }else if(newest == true){
            //最新
            _searchPag(pag,_id,_bra,keys,"createTime","");
          }else if(end == true){
            //倒叙
            _searchPag(pag,_id,_bra,keys,"minPrice","0");
          }else if(positive == true){
            //倒叙
            _searchPag(pag,_id,_bra,keys,"minPrice","1");
          }
        }else{
          Toast.show("暂无更多商品", context, duration: Toast.LENGTH_SHORT,
              gravity: Toast.CENTER);
        }
      }
    });
    super.initState();
  }
  //搜索商品  分类Id
  _searchSuggestion(List catagoryId)async{
    var result = await HttpUtil.getInstance().get(
        servicePath['search'],
        data: {
          "cataIds":catagoryId.join(','),
        }
    );
    if (result["code"] == 0) {
//      print("${result["result"]}");
      setState(() {
        _classify = result["result"]["list"]==null?[]:result["result"]["list"];
        _brand = result["result"]["brandList"]==null?[]:result["result"]["brandList"];
        _catagory = result["result"]["cataList"]==null?[]:result["result"]["cataList"];
        total = result["result"]["total"]==null?0:result["result"]["total"];
        pag = 2;
      });
    } else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
  //搜索商品 关键字
  _searchKeyWord(String keyword)async{
//    print("keyword:$keyword");
    var result = await HttpUtil.getInstance().get(
        servicePath['search'],
        data: {
          "keyword":keyword,
        }
    );
    if (result["code"] == 0) {
      setState(() {
        _classify = result["result"]["list"]==null?[]:result["result"]["list"];
        _brand = result["result"]["brandList"]==null?[]:result["result"]["brandList"];
        _catagory = result["result"]["cataList"]==null?[]:result["result"]["cataList"];
        total = result["result"]["total"]==null?0:result["result"]["total"];
        pag = 2;
        prefixs = [];
//        print(">>>>>>>>$total");
      });
    } else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
  //品牌名搜索商品
  _brandName(List brandName)async{
    var result = await HttpUtil.getInstance().get(
        servicePath['search'],
        data: {
          "brandNameList":brandName.join(","),
        }
    );
    if (result["code"] == 0) {
      setState(() {
        _classify = result["result"]["list"]==null?[]:result["result"]["list"];
        _brand = result["result"]["brandList"]==null?[]:result["result"]["brandList"];
        _catagory = result["result"]["cataList"]==null?[]:result["result"]["cataList"];
        total = result["result"]["total"]==null?0:result["result"]["total"];
        pag = 2;
      });
    } else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
  //最新
  _new(String createTime,List catagoryId,String keyword,List brandNameList)async{
//    print("createTime:$createTime "+"catagoryId:$catagoryId "+"keyword:$keyword "+"brandNameList:$brandNameList");
    var result = await HttpUtil.getInstance().get(
        servicePath['search'],
        data: {
          "orderBy":createTime,
          "cataIds":catagoryId.join(","),
          "keyword":keyword,
          "brandNameList":brandNameList.join(','),
        }
    );
    if (result["code"] == 0) {
      setState(() {
        _classify = result["result"]["list"];
        _brand = result["result"]["brandList"]==null?[]:result["result"]["brandList"];
        _catagory = result["result"]["cataList"]==null?[]:result["result"]["cataList"];
        total = result["result"]["total"]==null?0:result["result"]["total"];
        pag = 2;
      });
    } else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
  //销量筛选
  _virtualSale(String virtualSale,List catagoryId,String keyword,List brandNameList,)async{
//    print(catagoryId);
    var result = await HttpUtil.getInstance().get(
        servicePath['search'],
        data: {
          "orderBy":virtualSale,
          "cataIds":catagoryId.join(","),
          "keyword":keyword,
          "brandNameList":brandNameList.join(','),
        }
    );
    if (result["code"] == 0) {
      setState(() {
        _classify = result["result"]["list"];
        _brand = result["result"]["brandList"]==null?[]:result["result"]["brandList"];
        _catagory = result["result"]["cataList"]==null?[]:result["result"]["cataList"];
        total = result["result"]["total"]==null?0:result["result"]["total"];
        pag = 2;
      });
    } else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
  //搜索商品 根据价格进行排序 是否倒序 0->是 1->否
  _priceSort(List catagoryId,String salePrice,int isDesc,String keyword,List brandNameList)async{
//    print("catagoryId:$catagoryId "+"originalPrice$salePrice "+"isDesc$isDesc "+"keyword:$keyword "+"brandNameList:$brandNameList");
    var result = await HttpUtil.getInstance().get(
        servicePath['search'],
        data: {
          "cataIds":catagoryId.join(','),
          "orderBy":salePrice,
          "isDesc":isDesc,
          "keyword":keyword,
          "brandNameList":brandNameList.join(','),
        }
    );
    if (result["code"] == 0) {
      setState(() {
        _classify= result["result"]["list"];
        _brand = result["result"]["brandList"]==null?[]:result["result"]["brandList"];
        _catagory = result["result"]["cataList"]==null?[]:result["result"]["cataList"];
        total = result["result"]["total"]==null?0:result["result"]["total"];
        pag = 2;
      });
    } else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
  //筛选商品的搜索
  _screenSuggestion({List catagoryId,String startPrice,String endPrice,List brandName,String keyword})async{
    var result = await HttpUtil.getInstance().get(
        servicePath['search'],
        data: {
          "cataIds":catagoryId.join(','),
          "startPrice":startPrice,
          "endPrice":endPrice,
          "brandNameList":brandName.join(','),
          "keyword":keyword,
        }
    );
    if (result["code"] == 0) {
      setState(() {
        _classify = result["result"]["list"]==null?[]:result["result"]["list"];
        _brand = result["result"]["brandList"]==null?[]:result["result"]["brandList"];
        _catagory = result["result"]["cataList"]==null?[]:result["result"]["cataList"];
        total = result["result"]["total"]==null?0:result["result"]["total"];
        pag = 2;
      });
    } else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
  //上拉搜索
  _searchPag(int crrPage,List catagoryId,List brandName,String keyword,String orderBy,String isDesc)async{
//    print("crrPage:$crrPage"+"catagoryId:$catagoryId"+"brandName:$brandName"+"keyword:$keyword");
    //有一个总数据的条数
    var result = await HttpUtil.getInstance().get(
        servicePath['search'],
        data: {
          "crrPage":crrPage,
          "catagIds":catagoryId==null?catagoryId:catagoryId.join(','),
          "brandNameList":brandName==null?brandName:brandName.join(','),
          "keyword":keyword,
          "orderBy":orderBy,
          "isDesc":isDesc,
        }
    );
    if (result["code"] == 0) {
     setState(() {
       pag++;
       _classify.addAll(result["result"]["list"]);
     });
    } else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
  //搜索建议
  _search(String prefix)async{
    var result = await HttpUtil.getInstance().get(
        servicePath['searchSuggestion'],
        data: {
          "prefix":prefix,
        }
    );
    if (result["code"] == 0) {
      setState(() {
        prefixs = result["suggestion"];
      });
    } else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }

  //货架跳详情
  GoodsOnTop(val){
//    print('货架组件val==》$val');
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return CommodityDetails(id: val['id'],);
    }));
  }

  TextEditingController searchController = TextEditingController();//关键字搜索控制器
  final TextEditingController _minimum =  TextEditingController();
  final TextEditingController _maximum =  TextEditingController();
  final TextEditingController  _prefix=  TextEditingController(); //搜索建议
  @override
  Widget build(BuildContext context) {
    final _PersonalBrand = Provider.of<PersonalBrand>(context);
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading:false,
            title: Container(
              child: _TopSearchs(),
            ),
            actions: <Widget>[
              InkWell(
                child: Container(
                    margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                    width: ScreenUtil().setWidth(50),
                    child: Image.asset("images/homePage/share.png"),
                ),
                onTap: (){
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return GestureDetector(
                          child: Container(
                            height: ScreenUtil().setHeight(150),
                            color: Color(0xfff1f1f1),
                            child: ShareWeixin(),
                          ),
                          onTap: () => false,
                        );
                      });
                },
              )
            ],
            backgroundColor: Colors.white,
          ),
          body: prefixs.length==0?Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _towClassify(),
                  ],
                ),
                controller: _scrollController,
              ),
              _screen(),
            ],
          ):
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
            child: ListView(
              children:_suggest(),
            ),
          ),
      endDrawer:_PersonalBrand.allBrand==false?_endDrawer():AllBrand(),
    ),
        onWillPop: (){
          Navigator.pop(context,"1");
        });
  }
  //右侧菜单
  Widget _endDrawer(){
    final _PersonalBrand = Provider.of<PersonalBrand>(context);
    return GestureDetector(
      child: Container(
        width: ScreenUtil().setWidth(600),
        color: Color(0xFFE8E8E8),
        margin: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                //头部筛选
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20)),
                      child: InkWell(
                        child: Icon(Icons.arrow_back,),
                        onTap: (){
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Expanded(child: Container(
                      width: ScreenUtil().setWidth(300),
                      height: ScreenUtil().setHeight(50),
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20)),
                      child: Center(child: Text("筛选",style: TextStyle(fontSize: ScreenUtil().setSp(25)),),),
                    )),
                  ],),
                //珑梨推荐
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20)),
                  child: Text("珑梨推荐",style: TextStyle(fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(25)),),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      height: ScreenUtil().setHeight(50),
                      width: ScreenUtil().setWidth(150),
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20)),
                      child: Center(
                        child: Text("包邮",style: TextStyle(fontSize: ScreenUtil().setSp(25)),),
                      ),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(000, 000, 000, 0.1),
                          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10))
                      ),
                    ),
                    Container(
                      height: ScreenUtil().setHeight(50),
                      width: ScreenUtil().setWidth(150),
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20)),
                      child: Center(
                        child: Text("新品",style: TextStyle(fontSize: ScreenUtil().setSp(25)),),
                      ),
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(000, 000, 000, 0.1),
                          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10))
                      ),
                    ),
                  ],
                ),
                //价格区间
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(10)),
                  child:Row(
                    children: <Widget>[
                      Text("价格区间",style: TextStyle(fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(25)),),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(20)),
                        height: ScreenUtil().setHeight(50),
                        width: ScreenUtil().setWidth(150),
                        child: TextField(
                          controller: _minimum,
//                          enableInteractiveSelection:false ,
                          maxLines: 1,
                          keyboardType: TextInputType.number,//键盘类型，数字键盘
                          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//只允许输入数字
                          style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),fontFamily: '思源',textBaseline: TextBaseline.alphabetic),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintText: ' 最低值',
                              hintStyle: TextStyle(
                                  fontSize: ScreenUtil().setSp(25)),
                              contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),)),
                          onChanged: (v){
                            setState(() {
                              min = _minimum.text;
                            });
                          },
                        ),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(000, 000, 000, 0.1),
                            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5))
                        ),
                      ),
                      Container(margin:EdgeInsets.only(left: ScreenUtil().setWidth(10)),child: Text("一",),),
                      Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                        height: ScreenUtil().setHeight(50),
                        width: ScreenUtil().setWidth(150),
                        child:  TextField(
                          controller: _maximum,
//                          enableInteractiveSelection:false ,
                          maxLines: 1,
                          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],//只允许输入数字
                          style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),fontFamily: '思源',textBaseline: TextBaseline.alphabetic),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              hintText: ' 最高值',
                              hintStyle: TextStyle(
                                  fontSize: ScreenUtil().setSp(25)),
                              contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),)),
                          onChanged: (v){
                            setState(() {
                              max = _maximum.text;
                            });
                          },
                        ),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(000, 000, 000, 0.1),
                            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5))
                        ),
                      ),
                    ],
                  ),
                ),
                //分类
                Container(
                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20)),
                  child: Text("分类",style: TextStyle(fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(25)),),
                ),
                Wrap(
                  spacing: 30, //主轴上子控件的间距
                  runSpacing: 15, //交叉轴上子控件之间的间距
                  children: _brandcatagor(),
                ),
                //品牌
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20)),
                      child: Text("品牌",style: TextStyle(fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(25)),),
                    ),
                    Spacer(),
                    Container(
                      child: InkWell(
                        child: Text("查看全部",style: TextStyle(fontSize: ScreenUtil().setSp(20)),),
                        onTap: (){
                          _PersonalBrand.SetAllBrand();
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                      child: InkWell(
                        child: Icon(Icons.chevron_right),
                      ),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 30, //主轴上子控件的间距
                  runSpacing: 15, //交叉轴上子控件之间的间距
                  children: _brandLi(),
                ),
              ],
            ),
            //底部确定
            Align(
              alignment: FractionalOffset.bottomCenter,
              child:  Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),bottom: ScreenUtil().setHeight(10),
                    right: ScreenUtil().setWidth(20)),
                child:Row(
                  children: <Widget>[
                    Expanded(
                        child: InkWell(
                      child: Container(
                        height: ScreenUtil().setHeight(50),
                        child: Center(child: Text("重置",style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1)),),),

                      ),
                      onTap: (){
                        setState(() {
                          cataId = [];
                          cataId.add(widget.arguments["id"]);
                          max = "";
                          min = "";
                          brand = [];
                          brandcolo = [];
                          catacolo = [];
                        });
                      },
                    )
                    ),
                    InkWell(
                      child: Container(
                        height: ScreenUtil().setHeight(60),
                        width: ScreenUtil().setWidth(250),
                        child: Center(
                          child: Text("确定",style: TextStyle(color: Colors.white),),
                        ),
                        color: Color.fromRGBO(104, 098, 126, 1),
                      ),
                      onTap: ()async{
                        Navigator.pop(context);
                        brand.addAll(_PersonalBrand.AllBrandList);
                        await _screenSuggestion(catagoryId:cataId,startPrice:min,endPrice:max,brandName:brand,keyword: keys);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  //顶部搜索栏
  Widget _TopSearchs(){
    var size = MediaQuery.of(context).size;
    var widths = size.width;
    return Container(
      child: Row(
        children: <Widget>[
          InkWell(
            child:  Container(
              alignment: Alignment.centerLeft,
              height: ScreenUtil().setHeight(40),
              margin: EdgeInsets.all(ScreenUtil().setWidth(5)),
              child: Image.asset("images/setting/leftArrow.png",color: Colors.black,),
            ),
            onTap: (){Navigator.pop(context);},
          ),
          Expanded(
              child: Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(25),right: ScreenUtil().setWidth(25),),
              width: widths,
              height: ScreenUtil().setHeight(70),
              alignment: Alignment.center,
              child: TextField(
                controller: _prefix,
//                enableInteractiveSelection:false ,
                onChanged: (searchController){_search(searchController);},
                maxLines: 1,
                style: TextStyle(color: Color.fromRGBO(171, 174, 176, 1),fontFamily: '思源',textBaseline: TextBaseline.alphabetic),
                decoration: InputDecoration(
                  prefixIcon: InkWell(
                    child: Icon(Icons.search,color: Colors.black,),
                    onTap: (){},
                  ),
                  hintText: '请输入要搜索的内容',
                  hintStyle: TextStyle(fontSize: ScreenUtil().setSp(25),color: Color.fromRGBO(171, 174, 176, 1)),
                  border: OutlineInputBorder(borderSide: BorderSide.none,),
                  suffixIcon: InkWell(
                    child: Icon(Icons.clear,color: Color.fromRGBO(171, 174, 176, 1),),
                    onTap: (){setState(() {searchController.text="";});},
                  ),
                  contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),bottom: ScreenUtil().setHeight(20),),
                ),
                textInputAction: TextInputAction.search,
                onEditingComplete: ()async{},
              ),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(171, 174, 176, 0.3),
                  borderRadius: BorderRadius.circular(ScreenUtil().setWidth(35))
              ),
            )
          ),
        ],
      ),
    );
  }
  //顶部搜索栏
  Widget _TopSearch(){
    //屏幕宽高
    final size =MediaQuery.of(context).size;
    final width =size.width;
    final height =size.height;
    return Container(
      height: ScreenUtil().setHeight(60),
//      margin: EdgeInsets.only(top: ScreenUtil().setHeight(height*0.015),bottom: ScreenUtil().setHeight(20),
//          left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(20)
//      ),
      child: Container(
        width: width*0.75,
        alignment: Alignment.center,
        child: TextField(
          controller: _prefix,
//          enableInteractiveSelection:false ,
          maxLines: 1,
          onChanged: (searchController){_search(searchController);},
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: ' 请输入要搜索的内容',
            hintStyle: TextStyle(fontSize: ScreenUtil().setSp(30),fontFamily: '思源',textBaseline: TextBaseline.alphabetic),
//            suffixIcon: Container(
//              width: ScreenUtil().setWidth(30),
//              margin: EdgeInsets.only(right: ScreenUtil().setHeight(20)),
//              child: InkWell(
//                child: Container(
//                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
//                  child: Icon(Icons.border_clear),
//                ),
//                onTap: (){
//                  Navigator.pushNamed(context, '/scanView');
//                },
//              ),
//            ),
            contentPadding: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20),),
          ),
          textInputAction:TextInputAction.none,
        ),
      ),
    );
  }
  //筛选
  Widget _screen(){
    return Container(
      height: ScreenUtil().setHeight(100),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              child:  Builder(builder: (context) =>
                  InkWell(
                    child:  Center(child: Text("综合",
                      style: synthesize==true?TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenUtil().setSp(28),
                        decorationStyle: TextDecorationStyle.double,
                      ):
                      TextStyle(fontSize: ScreenUtil().setSp(22),),
                    ),),
                    onTap: (){
                      setState(() {
                        synthesize = true;
                        sales = false;//销量
                        end = false;//倒叙
                        positive = false;//正序
                        newest = false;//最新
                      });
                      if(_id!=""&&_id.length!=0){
                        _searchSuggestion(_id);
                      }else if(keys!=""&&keys!=null){
                        _searchKeyWord(keys);
                      }else if(_bra.length!=0&&_bra!=""){
                        _brandName(_bra);
                      }
                    },
                  ),),
            ),
          ),
//销量
//          Expanded(
//            child: Container(
//              child:  Builder(builder: (context) =>
//                  InkWell(
//                    child:  Center(child: Text("销量",
//                      style: sales==true?TextStyle(fontSize: ScreenUtil().setSp(22),
//                        decoration: TextDecoration.underline,
//                        decorationColor: Colors.red,
//                        decorationStyle: TextDecorationStyle.double,
//                      ):
//                      TextStyle(fontSize: ScreenUtil().setSp(22),),
//                    ),),
//                    onTap: (){
//                      setState(() {
//                        synthesize = false;
//                        sales = true;//销量
//                        end = false;//倒叙
//                        positive = false;//正序
//                        newest = false;//最新
//                      });
//                      _virtualSale("virtualSale",_id,keys,_bra);
//                    },
//                  ),),
//            ),
//          ),
          Expanded(
            child: Container(
              child:  Builder(builder: (context) =>
                  GestureDetector(//
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("价格",
                            style: end==true||positive==true?TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(28),
                              decorationStyle: TextDecorationStyle.double,
                            ):
                            TextStyle(fontSize: ScreenUtil().setSp(22),),),
                          Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                InkWell(
                                  child: Icon(Icons.arrow_drop_up,size: ScreenUtil().setSp(35),),
                                  onTap: (){
                                    setState(() {
                                      synthesize = false;
                                      sales = false;//销量
                                      end = false;//倒叙
                                      positive = true;//正序
                                      newest = false;//最新
                                    });
                                    _priceSort(_id,"minPrice",1,keys,_bra);
                                  },
                                ),
                                InkWell(
                                  child: Icon(Icons.arrow_drop_down,size: ScreenUtil().setSp(35),),
                                  onTap: (){
                                    setState(() {
                                      synthesize = false;
                                      sales = false;//销量
                                      end = true;//倒叙
                                      positive = false;//正序
                                      newest = false;//最新
                                    });
                                    _priceSort(_id,"minPrice",0,keys,_bra);
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                  ),),
            ),
          ),
          Expanded(
            child: Container(
              child:  Builder(builder: (context) =>
                  GestureDetector(
                      child:InkWell(
                        child:  Center(child: Text("最新", style: newest==true?
                        TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil().setSp(28),
                            decorationStyle: TextDecorationStyle.double,
                          ):
                          TextStyle(fontSize: ScreenUtil().setSp(22),),
                        ),),
                        onTap: () {
                          setState(() {
                            synthesize = false;
                            sales = false;//销量
                            end = false;//倒叙
                            positive = false;//正序
                            newest = true;//最新
                          });
                          _new("createTime",_id,keys,_bra);
                        },
                      )
                  ),),
            ),
          ),
          Expanded(
            child: Container(
              child:  Builder(builder: (context) =>
                  InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text("筛选", style: TextStyle(fontSize: ScreenUtil().setSp(22)),),
                        Container(
                          margin: EdgeInsets.only(right: ScreenUtil().setWidth(25)),
                          height: ScreenUtil().setHeight(30),
                          child: Image.asset("images/shop/screen.png"),
                        )
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        synthesize = false;
                        sales = false;//销量
                        end = false;//倒叙
                        positive = false;//正序
                        newest = false;//最新
                      });
                      Scaffold.of(context).openEndDrawer();
                    },
                  ),),
            ),
          ),
        ],
      ),
    );
  }
  //三级分类菜单
  Widget _towClassify(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(100)),
        child:   _classify.length > 0 ?GoodsOneTwoThree(
          col: 1,
          data: _classify,
          callback: (value)=>GoodsOnTop(value),
        ):Container(child: Center(child: Text('暂无商品'),),),
//      child: InkWell(
//        child: Container(
//          child: GridView.builder(
//              itemCount:_classify.length==null?0:_classify.length,
//              shrinkWrap: true, //解决无限高度问题
//              physics: NeverScrollableScrollPhysics(),
//              //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
//              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                //横轴元素个数
//                crossAxisCount: 2,
//                //子组件宽高长度比例
//                childAspectRatio: 7/9,
//              ),
//              itemBuilder: (BuildContext context, int index) {
//                String Imgs = _classify[index]["mainPic"];//定义图片字段
//                String title = _classify[index]["title"];//定义title字段
//                double price = _classify[index]["minPrice"]==null?0.0:
//                double.parse(_classify[index]["minPrice"].toString());
//                int ids = _classify[index]["id"];//id
//                return GestureDetector(
//                  child: Container(
//                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
//                    child: Column(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      children: <Widget>[
//                        Imgs!=null?
//                        Container(
//                          height: ScreenUtil().setHeight(250),
//                          child: Image.network("${_result+Imgs}",fit: BoxFit.cover,),
//                        ):
//                        Container(),
//                        Container(
//                          alignment: Alignment.bottomCenter,
//                          child: Text("$title",maxLines: 1,overflow: TextOverflow.ellipsis,),
//                        ),
//                        Container(
//                          alignment: Alignment.bottomCenter,
//                          child: Text("￥$price",maxLines: 1,overflow: TextOverflow.ellipsis,),
//                        ),
//                      ],
//                    ),
//                  ),
//                  onTap: (){
//                    print('ids=>$ids');
//                    Navigator.push(context, MaterialPageRoute(builder: (_) {
//                      return CommodityDetails(id: ids,);
//                    }));
//                  },
//                );
//              }),
//        ),
//      )
    );
  }
  //筛选品牌循环
  List<Widget> _brandLi(){
    List<Widget> brandLi = [];
//    print(_brand);
    for(var i = 0;i<_brand.length;i++){
      brandLi.add(
          InkWell(
            child: Container(
              padding: EdgeInsets.all(10),
              color: brandcolo.indexOf(i)==-1?Colors.white:Color.fromRGBO(104, 098, 126, 1),
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(10),top: ScreenUtil().setHeight(10)),
              child: Text("${_brand[i]}",style: TextStyle(color:  brandcolo.indexOf(i)==-1?Colors.black:Colors.white,),),
            ),
            onTap: (){
              setState(() {
                if(brand.indexOf(_brand[i])==-1){
                  brand.add(_brand[i]);
                  brandcolo.add(i);
                }else{
                  brand.remove(_brand[i]);
                  brandcolo.remove(i);
                }
              });
            },
          )
      );
    }
    return brandLi;
  }
  //筛选分类循环
  List<Widget> _brandcatagor(){
    List<Widget> brandcatagor = [];
    for(var i = 0;i<_catagory.length;i++){
      brandcatagor.add(
          InkWell(
            child: Container(
              padding: EdgeInsets.all(10),
              color: catacolo.indexOf(i)==-1?Color.fromRGBO(255, 255, 255, 1):Color.fromRGBO(104, 098, 126, 1),
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(10),top: ScreenUtil().setHeight(10)),
              child:  Text("${_catagory[i]["name"]}",style: TextStyle(color: catacolo.indexOf(i)==-1?Colors.black:Colors.white),),

            ),
            onTap: (){
              setState(() {
                if(cataId.indexOf(_catagory[i]["id"])==-1){
                  cataId.add(_catagory[i]["id"]);
                  catacolo.add(i);
                }else{
                  cataId.remove(_catagory[i]["id"]);
                  catacolo.remove(i);
                }
              });
            },
          )
      );
    }
    return brandcatagor;
  }
  //搜索建议
  List<Widget> _suggest(){
    List<Widget> suggest = [];
    for(var i = 0;i<prefixs.length;i++){
      suggest.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: ()async{
                  setState(() {_searchKeyWord(prefixs[i]);});
                },
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: ScreenUtil().setHeight(30),top: ScreenUtil().setHeight(20),bottom: ScreenUtil().setHeight(30)),
                  child:Text("${prefixs[i]}"),
                ),
              )
            ],
          )
      );
    }
    return suggest;
  }
}
