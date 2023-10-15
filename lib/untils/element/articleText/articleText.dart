import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class articleText extends StatefulWidget {
  final data;
  articleText({
    this.data,
  });
  @override
  _articleTextState createState() => _articleTextState();
}

class _articleTextState extends State<articleText> {

  Map _data = {
    'classify': "文学类",
    'col': 0,
    'data':[],
    'name': "articleText",
    'topics': [],
    'type': 1,
  };

  searchArticleText(val,type){

  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if(widget.data['type'] == 0){
        _data = widget.data == null ? _data : widget.data;
      }else if(widget.data['type'] == 1){
        searchArticleText(widget.data['classify'],1);
      }else if(widget.data['type'] == 2){
        searchArticleText(widget.data['topics'],2);
      }
    });
    return Container(
      child:_article(),
    );
  }

  //多列展示
  Widget _article(){
    switch(widget.data['col']) {
//      case 0:
//        return one();
//        break;
//
//      case 1:
//        return two();
//        break;
//
//      case 2:
//        return three();
//        break;
//      case 3:
//        return four();
//        break;

      default:
        return Center(child: Text("等待更新"),);
        break;
    }
  }
}
