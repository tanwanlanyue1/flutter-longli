import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//加入购物车
class AddToShoppingCart extends StatefulWidget {
  int type;//1 :加入购物车 ,2 : 立即购买
  double price;
  int repertory;
  List listImg;
  List standard;
  AddToShoppingCart({
    this.type,
    this.price,
    this.repertory,
    this.listImg,
    this.standard,
});
  @override
  _AddToShoppingCartState createState() => _AddToShoppingCartState();
}

class _AddToShoppingCartState extends State<AddToShoppingCart> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.repertory);
    print(widget.price);
    print(widget.listImg[0]);
    print(widget.standard[0]);
  }
  int _Indexs = null;
  @override
  Widget build(BuildContext context) {
    return _shoppingCart();
  }
  //加入购物车
  Widget _shoppingCart(){
    return Stack(
      children: <Widget>[
        Align(//关闭按钮
          alignment: FractionalOffset.topRight,
          child:IconButton(
            icon: Icon(Icons.highlight_off),
            onPressed:() async {
              Navigator.pop(context);
              setState(() {_Indexs = null;});
            } ,
          ) ,
        ),
        Container(
          height: 2000.0,
          child: new Column(
            children: <Widget>[
              Container( height: 1, color: Colors.black, ),
              Container(
                height: 110.0,
                padding: EdgeInsets.only(left: 20.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 100.0,
                      color: Colors.grey,
                      child: Image.network(widget.listImg[0],fit: BoxFit.fill,),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(

                                    child: Row(
                                      children: <Widget>[
                                        Text('￥',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                                        Text(' ${widget.price}',style: TextStyle(fontSize: 18.0, color: Colors.red,fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    padding: EdgeInsets.only(top: 20.0,left: 20.0),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: Text('库存${widget.repertory}件',style: TextStyle(fontSize: 13.0,color: Colors.grey),),
                                  ),
                                ],
                              ),
                            ],

                          ),
                          Container(
                            padding: EdgeInsets.only(left: 20.0,top: 10.0),
                            child: Text('已选某某某商品'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20.0),
                height: 30.0,
                child: Text('规格分类：'),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: ListView(
                    children: <Widget>[
                      WrapWidget(),
                    ],
//                  color:Colors.grey
                  ),
                ),
              )
            ],
          ),
        ),
        widget.type == 1 ?
        Align(//底部确定
          alignment: FractionalOffset.bottomCenter,
          child: Container(
            height: 50.0,
            color: Colors.white,
            child: Center(
              child: Container(
                height: 40.0,
                width: 320.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  color: Colors.red,
                ),
                child: Center(child: Text(' 加入购物车 ',style: TextStyle(fontSize: 15.0,color: Colors.white,fontWeight: FontWeight.bold),),),
              ),
            ),
          ),
        ):
        Align(//底部确定
          alignment: FractionalOffset.bottomCenter,
          child: Container(
            height: 50.0,
            color: Colors.white,
            child: Center(
              child: Container(
                height: 40.0,
                width: 320.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  color: Colors.red,
                ),
                child: Center(child: Text(' 立即购买 ',style: TextStyle(fontSize: 15.0,color: Colors.white,fontWeight: FontWeight.bold),),),
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget WrapWidget(){
    return Wrap(
      spacing: 30, //主轴上子控件的间距
      runSpacing: 15, //交叉轴上子控件之间的间距
      children: Boxs(), //要显示的子控件集合
    );
  }
  List<Widget> Boxs() => List.generate(widget.standard.length, (index) {
    return GestureDetector(
      onTap: (){
        setState(() {
          _Indexs = index;
        });
      },
      child: Container(
          height: ScreenUtil().setHeight(60),
          padding: EdgeInsets.only(
              left:  ScreenUtil().setWidth(15),
              right: ScreenUtil().setWidth(15)
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color:Color(0xffffffff),
            border: index == _Indexs ? Border.all(width: 1.0,color: Colors.amber):null
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.network(widget.listImg[0],fit: BoxFit.fill,),
              Text(
                "  ${widget.standard[index]['套餐']} "+ "${ widget.standard[index]['颜色']} "+"${ widget.standard[index]['版本']}",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: ScreenUtil().setSp(25),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
      ),
    );
  }
  );
}
