import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';
import 'package:provider/provider.dart';
import '../../../common/model/provider_personal.dart';
class InterestPage extends StatefulWidget {
  final arguments;
  InterestPage({this.arguments,});

  @override
  _InterestPageState createState() => _InterestPageState();
}

class _InterestPageState extends State<InterestPage> {
  List lable = [];
  List lableId = [];//已选择的标签
  List lableName = [];//已选择的标签
  @override
  void initState() {
    // TODO: implement initState
    lab();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  //获取标签列表
  void lab()async{
    var result = await HttpUtil.getInstance().post(
      servicePath['getLable'],
    );
    if (result["code"] == 0) {
     setState(() {
       lable = result["data"];
     });
    }else if (result["code"] == 401) {
      final _personalModel = Provider.of<PersonalModel>(context);
      _personalModel.quit();
      Toast.show("${result["msg"]},请先登录", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
      Navigator.pushNamed(context, '/LoginPage');
    }else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _background(),
          ListView(
            children: <Widget>[
              _top(),
              _multiple(),
              _label(),
            ],
          ),
        ],
      ),
    );
  }
  //背景
  Widget _background(){
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var size = mediaQuery.size;
    var heights = size.height;
    var widths = size.width;
    return Container(
      width: widths,
      height: heights,
      child: Image.asset("images/setting/background.jpg",fit: BoxFit.cover,),
    );
  }
  //顶部
  Widget _top(){
    return Container(
      margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
      child: Row(
        children: <Widget>[
          Expanded(
              child: InkWell(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.keyboard_arrow_left,color: Colors.white,size: ScreenUtil().setSp(80),),
                    Container(
                      child: Text("选择兴趣标签",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(40)),),
                    ),
                  ],
                ),
                onTap: (){
                  Navigator.pop(context);
                },
              )
          ),
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(40)),
            child: InkWell(
              child: Text("完成",style: TextStyle(color: Colors.white),),
              onTap: (){
                List result = [lableId,lableName];
                Navigator.pop(context,result);
              },
            ),
          ),
        ],
      ),
    );
  }
  //可多选
  Widget _multiple(){
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(30),bottom: ScreenUtil().setHeight(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("可多选，至少选1项",style: TextStyle(fontSize: ScreenUtil().setSp(32),color: Colors.white),),
        ],
      ),
    );
  }
  //标签内容
  Widget _label(){
    lableId = widget.arguments[0];
    lableName = widget.arguments[1];
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            child: GridView.builder(
                itemCount: lable.length,
                shrinkWrap: true, //解决无限高度问题
                physics: NeverScrollableScrollPhysics(),
                //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //横轴元素个数
                  crossAxisCount: 3,
                  //子组件宽高长度比例
                  childAspectRatio: 7/9,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                width: ScreenUtil().setWidth(250),
                                height: ScreenUtil().setHeight(250),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage("$ApiImg"+"${lable[index]["picture"]}"),fit: BoxFit.cover
                                  ),
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(ScreenUtil().setWidth(25)),
                                        topRight: Radius.circular(ScreenUtil().setWidth(25)))
                                ),
                              ),
                              lableId.indexOf(lable[index]["id"])!=-1?
                              Positioned(
                                  right: ScreenUtil().setWidth(20),
                                  top: ScreenUtil().setHeight(10),
                                  child: Container(
                                    width: ScreenUtil().setWidth(50),
                                    child: Image.asset("images/setting/lable.png",fit: BoxFit.cover,),
                                  )
                              ):
                              Positioned(
                                  right: ScreenUtil().setWidth(20),
                                  top: ScreenUtil().setHeight(10),
                                  child: Container()
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            child: Text("# ${lable[index]["name"]} #",maxLines: 1,overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Color(0xffAAAAAA),fontSize: ScreenUtil().setSp(30)),),
                            decoration: BoxDecoration(
                              color: Colors.white,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(ScreenUtil().setWidth(25)),
                                    bottomRight: Radius.circular(ScreenUtil().setWidth(25)))
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: (){
                      setState(() {
                        if(lableId.indexOf(lable[index]["id"])==-1){
                          lableId.add(lable[index]["id"]);
                        }else{
                          lableId.remove(lable[index]["id"]);
                        }
                        if(lableName.indexOf(lable[index]["name"])==-1){
                          lableName.add(lable[index]["name"]);
                        }else{
                          lableName.remove(lable[index]["name"]);
                        }
                      });
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
