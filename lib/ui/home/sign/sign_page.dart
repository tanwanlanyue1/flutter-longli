import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_widget_one/ui/home/sign/share_page.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'package:flutter_widget_one/untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';
import 'myMood_page.dart';
import 'package:flutter_widget_one/router/router_animation/router_animate.dart';
class signPage extends StatefulWidget {
  @override
  _signPageState createState() => _signPageState();
}

class _signPageState extends State<signPage> {

  int count=9;
  int _showId = null;
  bool _isSignIn = true;
  List img= [];
  void onChangeds(val){
    setState(() {
      _showId = val;
    });
  }
//  心情卡列表
  _MoodqueryList()async{
    print('1');
    var result = await HttpUtil.getInstance().get(
      servicePath['MoodqueryList'],
      data: {'keyword':''}
    );
    if(result['code'] == 0){
      setState(() {
        List all = [];
        for(var item in result['result']){
          if(item['status'] ==true){all.add(item);}
        }
        img = all;
        _isSignIn = false;
      });
    }else if(result['code'] == 401){
      Navigator.of(context).pushReplacementNamed('/LoginPage');
    }else{
      Toast.show("请重试", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _MoodqueryList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("images/setting/background.jpg"), fit: BoxFit.cover,),
        ),
        child:
        _isSignIn?
        Center(
              child: Container(
                height: ScreenUtil().setHeight(50),
                width: ScreenUtil().setHeight(50),
                child: new CircularProgressIndicator(
                  strokeWidth: 4.0,
                  backgroundColor: Colors.grey,
                  // value: 0.2,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ):
        ListView(
          children: <Widget>[
            _top(),
            Text('翻一翻',textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
            AnimationLimiter(
              child:GridView.builder(
                padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
                shrinkWrap: true,
                physics:  NeverScrollableScrollPhysics(),
                itemCount: img.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 7/10
                ),
                itemBuilder: (context,index){
                  return AnimationConfiguration.staggeredGrid(
                    columnCount:img.length,
                    position: index,
                    duration: const Duration(milliseconds: 800),
                    child: SlideAnimation(
                      verticalOffset: 100.0,
                      child: FadeInAnimation(
                        child: cards(
                            index: index,
                            data:img[index],
                            id:img[index]['id'],
                            showId: _showId,
                            callBack: (value)=>onChangeds(value)
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      )
    );
  }
  //头部
  Widget _top(){
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment:Alignment.topLeft ,
              child: InkWell(
                child: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: ScreenUtil().setSp(80),),
                onTap: (){Navigator.pop(context);},
              ),
            ),
          ),
          Expanded(
              child: Container(
                alignment:Alignment.center ,
                child: Center(
                  child: Text("心情卡",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(45)),),
                ),
              )
          ),
          Expanded(
            child:  InkWell(
              child: Container(
                alignment:Alignment.centerRight ,
                padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                child: Text("每日一签",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(30)),),
              ),
              onTap: (){
              },
            ),
          )

        ],
      ),
    );
  }
}

class cards extends StatefulWidget {
  final int index;
  final int id;
  final int showId;
  final callBack;
  final data;
  cards({
    this.index,
    this.id,
    this.showId,
    this.callBack,
    this.data,
   });

  @override
  _cardsState createState() => _cardsState();
}



class _cardsState extends State<cards> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  @override
  Widget build(BuildContext context) {
    return FlipCard(
      key: cardKey,
      flipOnTouch: false,
      front: Container(
        child: InkWell(
          onTap: (){
            if(widget.showId == widget.id || widget.showId == null){
              cardKey.currentState.toggleCard();
              widget.callBack(widget.id);
              Future.delayed(Duration(milliseconds: 800),(){
                 Navigator.of(context).push(CustomRoute(MyMood(
                   data:widget.data
                 )));
              });
            }
          },
          child:
//          widget.data['cover3'].length==0?
//          Image.network(ApiImg + widget.data['cover'],fit: BoxFit.fill,):
//          Image.network(ApiImg + widget.data['cover3'],fit: BoxFit.fill,),
            Image.asset('${'images/moods/mood' + (widget.index + 1).toString() + '.png'}',),
        ),
      ),
      back:  InkWell(
        onTap: (){
          if(widget.showId == widget.id || widget.showId == null){
            widget.callBack(widget.id);
            Future.delayed(Duration(milliseconds: 800),(){
              Navigator.of(context).push(CustomRoute(MyMood(
                  data:widget.data
              )));
            });
          }
        },
        child: Container(
//          margin: EdgeInsets.only(
//              left: ScreenUtil().setWidth(15),
//              right: ScreenUtil().setWidth(15)
//          ),
          child: Image.network(ApiImg + widget.data['backCover'],fit: BoxFit.fill,),
        ),
      ),
    );
  }
}
