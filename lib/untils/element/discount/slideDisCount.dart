import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_widget_one/untils/httpRequest/http_url.dart";

class SlideDisCount extends StatefulWidget {
  final data;
  SlideDisCount({
    this.data = null,
});
  @override
  _SlideDisCountState createState() => _SlideDisCountState();
}

class _SlideDisCountState extends State<SlideDisCount> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('CrosswiseMove,data==>${widget.data}');
    _data = widget.data == null ? _data : widget.data;

  }

  List _data = [
    {'price':56,'desc':89,'isGet':false},
    {'price':156,'desc':919,'isGet':false},
    {'price':5206,'desc':1399,'isGet':false},
    {'price':6,'desc':1899,'isGet':false},
    {'price':11196,'desc':99999,'isGet':false},
  ];
  //  领取状态
  setData(index){
    print(index);
    setState(() {
      _data[index]['isGet'] = !_data[index]['isGet'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(240),
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount:_data.length,
          itemBuilder:(context,index){
            final size =MediaQuery.of(context).size;
            final _width = size.width;
            final _height = size.height;
            return Container(
              width: _width/2.5,
              height:ScreenUtil().setHeight(200),
              margin: EdgeInsets.only(
                  top: ScreenUtil().setHeight(30),
                  bottom: ScreenUtil().setHeight(30),
                  left: ScreenUtil().setWidth(10),
                  right: ScreenUtil().setWidth(10)
              ),
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/discount/countTwo.png',),
                    fit: BoxFit.fill,
                  )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height:ScreenUtil().setHeight(200),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('￥',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(40)),),
                              Text('${_data[index]['price']}',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(45)),)
                            ],
                          ),
                          Text('满${_data[index]['desc']}元可用',style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(24)),)
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                        width: ScreenUtil().setWidth(85),
                        height:ScreenUtil().setHeight(200),
                        child:
                        _data[index]['isGet'] ==false?Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text("立",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(26)),),
                            Text("即",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(26)),),
                            Text("领",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(26)),),
                            Text("取",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(26)),),
                          ],
                        )
                            :
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text("已",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(26)),),
                            Text("领",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(26)),),
                            Text("取",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(26)),),
                          ],
                        )
                    ),
                    onTap: (){
                      setData(index);
                    },
                  ),
                ],
              ),
            ),
            );
          }

      ),
    );
  }
}
