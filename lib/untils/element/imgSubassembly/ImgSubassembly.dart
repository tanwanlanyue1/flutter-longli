import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/untils/element/A_ontab/Page_searchOnTab.dart';
import 'package:flutter_widget_one/untils/element/CustomList/structure.dart';
import 'package:flutter_widget_one/untils/httpRequest/http_url.dart';

class ImgSubassembly extends StatefulWidget {
  final col;
  final data;
  final callback;
  ImgSubassembly({
    this.col = 1,
    this.data =null,
    this.callback,
});
  @override
  _ImgSubassemblyState createState() => _ImgSubassemblyState();
}

class _ImgSubassemblyState extends State<ImgSubassembly> {

  List _data = [
    {"thumb":"${ApiImg+'pg_5100'}"},
    {"thumb":"${ApiImg+'pg_c24d'}"},
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _data = widget.data == null ? _data : widget.data;
    });
  }
  @override
  Widget build(BuildContext context) {
    setState(() {
      _data = widget.data == null ? _data : widget.data;
    });
    return _imgList();
  }

  //多列展示
  Widget _imgList(){
    switch(widget.col) {
      case 0:
        return _one();
        break;

      case 1:
        return _two();
        break;

      case 2:
        return _three();
        break;

      case 3:
        return _four();
        break;

      default:
        return Center(child: Text("等待更新"),);
        break;
    }
  }

  Widget _one(){
    return Column(
      children:_imgs(),
    );
  }

  Widget _two(){
    return Container(
      alignment: Alignment.topLeft,
      padding:EdgeInsets.only(
        left: ScreenUtil().setWidth(10),
        right: ScreenUtil().setWidth(10),
        top: ScreenUtil().setWidth(30),
      ),
      child: Wrap(
        children:_img2(),
      ),
    );
  }

  Widget _three(){
    return Container(
      alignment: Alignment.topLeft,
      padding:EdgeInsets.only(
        left: ScreenUtil().setWidth(15),
        right: ScreenUtil().setWidth(15),
        top: ScreenUtil().setWidth(30),
      ),
      child: Wrap(
        children:_img3(),
      ),
    );
  }

  Widget _four(){
    return Container(
      height: ScreenUtil().setWidth(600),
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount:_data.length,
          itemBuilder:(context,index){
            return InkWell(
              onTap: (){
                PagesearchOnTab(_data[index],context);
              },
              child: Container(
                width:ScreenUtil().setWidth(470),
                height: ScreenUtil().setWidth(570),
                margin:EdgeInsets.only(
                  left: ScreenUtil().setWidth(25),
                  bottom: ScreenUtil().setWidth(30),
                ),
                child:InkWell(
                  child:  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
                        image: DecorationImage(
                          image: NetworkImage(_data[index]['thumb']),
                          fit: BoxFit.fill,
                        )
                    ),
                  ),
                  onTap: (){
                    PagesearchOnTab(_data[index],context);
                  },
                )
              ),
            );
          }
      ),
    );
  }

  List<Widget> _imgs(){
    List<Widget> ALL = [];
    final size =MediaQuery.of(context).size;
    final _width = size.width;
    for(var item in _data){
      ALL.add(
          InkWell(
            onTap: (){
              PagesearchOnTab(item,context);
            },
            child: Container(
              width: _width,
              child: CachedNetworkImage(
                imageUrl: item['thumb'],
                fit: BoxFit.fill,
                placeholder: (context, url) =>Container(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
//              Image.network(item['thumb'],fit: BoxFit.fitWidth,),
            ),
          )
      );
    }
    return ALL;
  }

  List<Widget> _img2(){
    final size =MediaQuery.of(context).size;
    final _width = size.width;
    final _height = size.height;
    List<Widget> ALL = [];
    for(var item in _data){
      ALL.add(
          InkWell(
            onTap: (){
              print('item=>${item}');
            },
            child: InkWell(
              child: Container(
                width:ScreenUtil().setWidth(338),
                height: ScreenUtil().setHeight(259),
                margin:EdgeInsets.only(
                  left: ScreenUtil().setWidth(13),
                  right: ScreenUtil().setWidth(13),
                  bottom: ScreenUtil().setWidth(24),
                ),
                child:InkWell(
                  child:  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
                        image: DecorationImage(
                          image: NetworkImage(item['thumb']),
                          fit: BoxFit.fill,
                        )
                    ),
                  ),
                  onTap: (){
                    PagesearchOnTab(item,context);
                  },
                )
              ),
            )
          )
      );
    }
    return ALL;
  }

  List<Widget> _img3(){
    final size =MediaQuery.of(context).size;
    final _width = size.width;
    final _height = size.height;
    List<Widget> ALL = [];
    for(var item in _data){
      ALL.add(
          InkWell(
              onTap: (){widget.callback(item);},
              child: InkWell(
                child: Container(
                  width: ScreenUtil().setWidth(220),
                  height: ScreenUtil().setWidth(220),
                  margin:EdgeInsets.only(
                    left: ScreenUtil().setWidth(10),
                    right: ScreenUtil().setWidth(10),
                    bottom: ScreenUtil().setWidth(30),
                  ),
                  child: InkWell(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
                          image: DecorationImage(
                            image: NetworkImage(item['thumb']),
                            fit: BoxFit.fill,
                          )
                      ),
                    ),
                    onTap: (){
                      PagesearchOnTab(item,context);
                    },
                  )
                ),
              )
          )
      );
    }
    return ALL;
  }

}
