import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';

class Classification extends StatefulWidget {
  final callback;
  final col;
  final data;
  Classification({
    this.col = 3,
    this.data,
    this.callback = null
});
  @override
  _ClassificationState createState() => _ClassificationState();
}

class _ClassificationState extends State<Classification> {

  List _data = [
    {'img':"pg_c244","name":'12313'},
    {'img':"pg_c244","name":'12sdadsa313'},
    {'img':"pg_c244","name":'12sdadsa313'},
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    print('Classification==>${widget.data}');
  }

void state(){
  _data = [];
  for(var i=0;i<widget.data.length;i++){
    if(widget.data[i]["status"]==true){
      _data.add(widget.data[i]);
    }
  }
}
  @override
  Widget build(BuildContext context) {
    state();
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 1.0, color: Color(0xffEFEFEF)))
      ),
      child: _class(),
    );
  }
  //多列展示
  Widget _class(){
    switch(widget.col) {
      case 2:
        return two();
        break;

      case 3:
        return three();
        break;

      default:
        return Center(child: Text("等待更新"),);
        break;
    }
  }

  Widget two(){
    return GridView.builder(
        itemCount: _data.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: ScreenUtil().setWidth(20.0),
          mainAxisSpacing: ScreenUtil().setHeight(5.0),
          crossAxisCount: widget.col,
          childAspectRatio: 1.3,
        ),
        itemBuilder: (BuildContext context, int index) {
          return  _data[index]["status"]==true?
          InkWell(
            onTap: (){
//              print(index);
            },
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: ScreenUtil().setWidth(130),
                    height: ScreenUtil().setWidth(130),
                    child: CachedNetworkImage(
                      imageUrl: ApiImg + _data[index]['img'],
                      fit: BoxFit.fill,
                      placeholder: (context, url) =>Container(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
//                      Image.network(ApiImg + _data[index]['img'],fit: BoxFit.fill,)
                  ),
                  Container(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                      width: ScreenUtil().setWidth(150),
                      child: Text('${_data[index]['name']}',textAlign: TextAlign.center,style: TextStyle(fontSize:ScreenUtil().setSp(30) ),maxLines: 1,overflow: TextOverflow.ellipsis,)
                  ),
                ],
              ),
            ),
          ):
          Container();
        });
  }

  Widget three(){
    return GridView.builder(
        itemCount: _data.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: ScreenUtil().setWidth(20.0),
          mainAxisSpacing: ScreenUtil().setHeight(5.0),
          crossAxisCount: widget.col,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: (){
              widget.callback(_data[index]);
            },
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _data[index]['img']==null?
                  Container(
                    width: ScreenUtil().setWidth(130),
                    height: ScreenUtil().setWidth(130),
                  ):
                  Container(
                      width: ScreenUtil().setWidth(130),
                      height: ScreenUtil().setWidth(130),
//                      child: Text(_data[index]['img']),
                      child: CachedNetworkImage(
                        imageUrl: ApiImg + _data[index]['img'],
                        fit: BoxFit.fill,
                        placeholder: (context, url) =>Container(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
//                      Image.network(ApiImg + _data[index]['img'],fit: BoxFit.fill,)
                  ),
                  Container(
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                      child: Text('${_data[index]['name']}',textAlign: TextAlign.center,style: TextStyle(fontSize:ScreenUtil().setSp(26),fontFamily: "思源" ),maxLines: 1,)
                  ),
                ],
              ),
            ),
          );
        });
  }
}
