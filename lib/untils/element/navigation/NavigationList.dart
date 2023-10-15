import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/ui/home/home_page.dart';
import 'package:flutter_widget_one/untils/element/CustomList/shopPagePlubic.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';
import 'one.dart';

class NavigationList extends StatefulWidget {
  final data;
  NavigationList({
    this.data= null
});
  @override
  _NavigationListState createState() => _NavigationListState();
}

class _NavigationListState extends State<NavigationList> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.data);
    _data = widget.data == null ? _data : widget.data;
//    _ForList();
  }

  List _data = [
    {'name':'这是','list':[]},
    {'name':'跨版导航','list':[]},
    {'name':'并且','list':[]},
    {'name':'只能五个字','list':[]},
    {'name':'撑开','list':[]},
  ];


//  final bodyList = [OneList(),OneList(),OneList(), TwoList(),OneList(),TwoList(),OneList(),OneList(),OneList(),OneList(), TwoList(),OneList(),TwoList(),OneList()];

  var _Scontroller = new ScrollController(); //Listview控制器

  double begindx = 0;//按下坐标
  int _index = 0;//选项卡下标
  int _page = 0;//计算倍数得出第几屏


  //四个以上刷新下标
  _setIndex(indexs){
    setState(() {
      var _NweOffset = ScreenUtil().setWidth(160.0)*indexs;
//      print(indexs);
//      print('_NweOffset==$_NweOffset');
//      print('_offset==$_offset');
//      print(indexs~/4);//四的倍数
      int _scoll = indexs~/4;
      if(_index == _data.length-1 &&indexs ==0 ){
        _Scontroller.jumpTo(0);//最大滚动
      }else if(_index == 0 &&indexs ==_data.length-1 ){
        _Scontroller.jumpTo(_NweOffset);//最小滚动
      }else{
        if(_page != _scoll){
          _page = _scoll;
          _Scontroller.jumpTo(ScreenUtil().setWidth(500)*_scoll);
        }
      }
      _index = indexs;
    });
  }
  //1-4个刷新下标
  _setFour(index){
    setState(() {
      _index = index;
    });
  }
  //手指按下
  _onPointerDown(event){
    var dx = event.position.dx;
    setState(() {begindx = dx;});
  }
  //手指抬起
  _onPointerUp(event){
    var NewDx = event.position.dx;
    print(NewDx);
    if((NewDx-begindx)>100){
      var i2 = 0;
      if(_index-1 <0){
        i2 = _data.length-1;
      }else{
        i2 = _index-1;
      }
      print('向右');
      _setIndex(i2);
    }else if((NewDx-begindx)<-100){
      var i = 0;
      if(_index+1>_data.length-1){
        i = 0;
      }else{
        i = _index+1;
      }
      _setIndex(i);
      print('向左');
    }else{
      print('不切换');
      return;
    }
  }
  //1-4手指抬起
  _FourPointerUp(event){
    var NewDx = event.position.dx;
    if ((NewDx - begindx) > 100) {
      var i2 = 0;
      if (_index - 1 < 0) {
        i2 = _data.length - 1;
      } else {
        i2 = _index - 1;
      }
      _setFour(i2);
      print('向左');
    } else if ((NewDx - begindx) < -100) {
      var i = 0;
      if (_index + 1 > _data.length - 1) {
        i = 0;
      } else {
        i = _index + 1;
      }
      _setFour(i);
      print('向右');
    } else {
      print('不切换');
      return;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _Scontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _data = widget.data == null ? _data : widget.data;
    });
    return _listBar(_data.length);
  }

  //多列展示
  Widget _listBar(count){
    switch(count) {
      case 1:
        return _four();
        break;

      case 2:
        return _four();
        break;

      case 3:
        return _four();
        break;

      case 4:
        return _four();
        break;

      default:
        return _five();
        break;
    }
  }

  Widget _four(){
    return Column(
      children: <Widget>[
        Container(
          height: ScreenUtil().setHeight(90),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1.0, color: Color(0xffEFEFEF)))
          ),
          child: Row(
            children: _Centers(),
          ),
        ),
        Listener(
            onPointerDown: (event) {
              _onPointerDown(event);
            },
            onPointerUp: (event) {
              _FourPointerUp(event);
            },
            child: _byOne(_index)
        )
      ],
    );
  }

  Widget _five(){
    return Column(
      children: <Widget>[
        Container(
          height: ScreenUtil().setHeight(90),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1.0, color: Color(0xffEFEFEF)))
          ),
          child: ListView.builder(
              controller: this._Scontroller,
              scrollDirection: Axis.horizontal,
              itemCount:_data.length,
              itemBuilder:(context,i){
                return Container(
                  width:ScreenUtil().setWidth(160),
                  child: Stack(
                    children: <Widget>[
                      InkWell(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            child: Text(_data[i]['name'],
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(30),
                                color:_index == i ? Colors.black :Color(0xff828282),
                                fontWeight:_index == i ? FontWeight.bold :FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
//                              maxLines: 1,
//                              overflow: TextOverflow.ellipsis,
                            ),
                            padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(15)),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(width: 2.0,color:_index == i ? Colors.red :Colors.white))
                            ),
                          ),
                        ),
                        onTap: (){
                          _setIndex(i);
                        },
                      )
                    ],
                  ),
                );
              }
          )
        ),
        Listener(
            onPointerDown:(event){
              _onPointerDown(event);
            },
            onPointerUp:(event){
              _onPointerUp(event);
            },
            child:_byOne(_index)
//            Container(
//              child: bodyList[_index],
//            )
        )
      ],
    );
  }

  List<Widget> _Centers(){
    List<Widget> _ALL = [];
    for(var i=0; i<_data.length;i++){
      _ALL.add(
        Expanded(
          child: InkWell(
            onTap: (){_setFour(i);},
            child: Container(
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      child: Text(_data[i]['name'],
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(30),
                          color: _index == i ? Colors.black : Color(0xff828282),
                          fontWeight: _index == i ? FontWeight.bold : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      padding: EdgeInsets.only(
                          bottom: ScreenUtil().setHeight(15)
                      ),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 2.0,color:_index == i ? Colors.red :Colors.white))
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      );
    }
    return _ALL;
  }

  Widget _byOne(index){
    print(_data[index]['list']);
    return OneList(
      data: _data[index]['list'],
    );
  }
}
