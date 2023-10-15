import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_one/common/model/provider_brand.dart';
import 'package:provider/provider.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'package:toast/toast.dart';
class AllBrand extends StatefulWidget {
  @override
  _AllBrandState createState() => _AllBrandState();
}

class _AllBrandState extends State<AllBrand> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: ScreenUtil().setHeight(60)),
      width: ScreenUtil().setWidth(600),
      color: Color(0xFFE8E8E8),
      child: ContactPage(),
    );
  }
}

class ContactPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ContactPageState();
  }
}

class _ContactPageState extends State<ContactPage> {
  List allBrands = [];
  List all = [];
  List<ContactInfo> contactList = List();
  String _checkTag = "A";
  @override
  void initState() {
    super.initState();
    _brandList ();
  }
  //sku查全部品牌列表
  _brandList () async {
    var result = await HttpUtil.getInstance().get(
      servicePath['getBrandAll'],
    );
    if (result["code"] == 0) {
      setState(() {
        all = result["data"];
        initData();
      });
    } else if (result["code"] == 500) {
      Toast.show("${result["msg"]}", context, duration: Toast.LENGTH_SHORT,
          gravity: Toast.CENTER);
    }
  }
  @override
  Widget build(BuildContext context) {
    final _PersonalBrand = Provider.of<PersonalBrand>(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body:Container(
        height: size.height,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                //头部筛选
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20)),
                      child: InkWell(
                        child: Icon(Icons.arrow_back,),
                        onTap: (){
                          _PersonalBrand.AllBrandList.addAll(allBrands);
                          _PersonalBrand.SetAllBrand();
                        },
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: ScreenUtil().setWidth(300),
                      height: ScreenUtil().setHeight(50),
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(20),top: ScreenUtil().setHeight(20)),
                      child: Center(child: Text("全部品牌",style: TextStyle(fontSize: ScreenUtil().setSp(25)),),),
                    ),
                  ],),
                Container(
                  height: size.height-ScreenUtil().setHeight(140),
                  child: QuickSelectListView(
                    data: contactList,
                    itemBuilder: (context, model) => _buildListItem(model),
                    suspensionWidget: _buildSusWidget(_checkTag),
                    isUseRealIndex: true,
                    itemHeight: 60,
                    suspensionHeight: 20,
                    onSusTagChanged: _onSusTagChanged,
                  ),
                )
              ],
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child:  Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(20)),
                height: ScreenUtil().setHeight(80),
                color: Colors.white,
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
                              allBrands = [];
                            });
                          },
                        )
                    ),
                    InkWell(
                      child: Container(
                        height: ScreenUtil().setHeight(80),
                        width: ScreenUtil().setWidth(250),
                        child: Center(
                          child: Text("确定",style: TextStyle(color: Colors.white),),
                        ),
                        color: Color(0xff68627e),
                      ),
                      onTap: ()async{
                        _PersonalBrand.AllBrandList.addAll(allBrands);
                        _PersonalBrand.SetAllBrand();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


// 展示的内容 A awsl0 awsla1 B b2  b3
  ///
  /// 初始化数据
  ///all
  void initData() {
    for(var i=0;i<all.length;i++){
      if(all[i]["firstChar"]=="A"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'A',imgs: all[i]["image"]),);
      }else if(all[i]["firstChar"]=="B"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'B',imgs: all[i]["image"]));
      }else if(all[i]["firstChar"]=="C"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'C',imgs: all[i]["image"]));
      }else if(all[i]["firstChar"]=="D"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'D',imgs: all[i]["image"]));
      }else if(all[i]["firstChar"]=="E"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'E',imgs: all[i]["image"]));
      }else if(all[i]["firstChar"]=="F"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'F',imgs: all[i]["image"]));
      }else if(all[i]["firstChar"]=="G"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'G',imgs: all[i]["image"]));
      }else if(all[i]["firstChar"]=="H"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'H',imgs: all[i]["image"]));
      }else if(all[i]["firstChar"]=="I"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'I',imgs: all[i]["image"]));
      }else if(all[i]["firstChar"]=="J"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'J',imgs: all[i]["image"]));
      }else if(all[i]["firstChar"]=="K"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'K',imgs: all[i]["image"]));
      }else if(all[i]["firstChar"]=="L"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'L',imgs: all[i]["image"]));
      }else if(all[i]["firstChar"]=="M"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'M',imgs: all[i]["image"]));
      }else if(all[i]["firstChar"]=="N"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'N',imgs: all[i]["image"]));
      }else if(all[i]["firstChar"]=="O"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'O',imgs: all[i]["image"]));
      }else if(all[i]["firstChar"]=="P"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'P',imgs: all[i]["image"]));
      }else if(all[i]["firstChar"]=="Q"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'Q',imgs: all[i]["image"]));
      }else if(all[i]["firstChar"]=="R"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'R',imgs: all[i]["image"]));
      }else if(all[i]["firstChar"]=="S"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'S',imgs: all[i]["image"]));
      }else if(all[i]["firstChar"]=="T"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'T',imgs: all[i]["image"]));
      }else if(all[i]["firstChar"]=="U"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'U',imgs: all[i]["image"]));
      }else if(all[i]["firstChar"]=="V"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'V',imgs: all[i]["image"]));
      }else if(all[i]["firstChar"]=="W"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'W',imgs: all[i]["image"]));
      }else if(all[i]["firstChar"]=="X"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'X',imgs: all[i]["image"]));
      }else if(all[i]["firstChar"]=="Y"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'Y',imgs: all[i]["image"]));
      }else if(all[i]["firstChar"]=="Z"){
        contactList
            .add(ContactInfo(name: '${all[i]["cnName"]}', namePinyin: 'Z',imgs: all[i]["image"]));
      }
    }
  }
  ///
  /// 创建每一个条目
  ///
  _buildListItem(ContactInfo model,) {
    String susTag = model.getSuspensionTag();
    return Column(
      children: <Widget>[
        Offstage(
          offstage: model.isShowSuspension != true,
          child: _buildSusWidget(susTag),
        ),
        SizedBox(
          height: 60.0,
          child: ListTile(
            title: new Container(
              child: new Column(
                children: <Widget>[
                   Container(
                    height: 50.0,
                    color:Colors.white,
                    child: InkWell(
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding:  EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                            child:  Text(model.name,style: TextStyle(color: Color(0xff8a8a8a)),),
                          ),
                          Spacer(),
                          allBrands.indexOf(model.name) != -1 ?
                          Container(
                            margin: EdgeInsets.only(
                                right: ScreenUtil().setWidth(25)),
                            child: Image.asset("images/shop/checkMark.png"),
                          ) :
                          Container()
                        ],
                      ),
                      onTap: (){
                        setState(() {
                          if(allBrands.indexOf(model.name)==-1){
                            allBrands.add(model.name);
                          }else{
                            allBrands.remove(model.name);
                          }
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
                    height: 0.5,
                    color: Color(0xffebebeb),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  ///
  /// 标签回调监听
  ///
  _onSusTagChanged(String tag) {
    setState(() {
      _checkTag = tag;
    });
  }

  ///
  /// 这是tag控件
  ///
  _buildSusWidget(String susTag) {
    return Container(
      height: 20.0,
      padding: const EdgeInsets.only(left: 15.0),
      color: Color.fromRGBO(245, 245, 245, 1),
      alignment: Alignment.centerLeft,
      child: Text(
        '${susTag==null?"":susTag}',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xff999999),
        ),
      ),
    );
  }
}

class ContactInfo extends ISuspensionBean {
  String name;
  String namePinyin;
  String imgs;
  ContactInfo({this.name,this.namePinyin,this.imgs});

  @override
  String getSuspensionTag() {
    // TODO: implement getSuspensionTag
    return namePinyin;
  }
}


///悬挂 Bean.
abstract class ISuspensionBean {
  bool isShowSuspension;

  String getSuspensionTag(); //Suspension Tag
}

class QuickSelectListViewHeader {
  QuickSelectListViewHeader({
    @required this.height,
    @required this.builder,
    this.tag = "↑",
  });

  final int height;
  final String tag;
  final WidgetBuilder builder;
}

///在所有sus部分回调(map:用于将列表滚动到指定的标记位置)。
typedef void OnSusSectionCallBack(Map<String, int> map);

///悬挂部件。目前只支持固定高度的项目!
class SuspensionListView extends StatefulWidget {
  ///ISuspensionBean数据
  final List<ISuspensionBean> data;

  ///内容小部件(必须包含ListView)。
  final Widget contentWidget;

  ///悬浮部件
  final Widget suspensionWidget;

  ///ListView 滚动控制器。
  final ScrollController controller;

  ///悬架部件高度。
  final int suspensionHeight;

  ///item Height.
  final int itemHeight;

  ///在sus标签更改回调。
  final ValueChanged<String> onSusTagChanged;

  ///在sus部分回调。
  final OnSusSectionCallBack onSusSectionInited;

  final QuickSelectListViewHeader header;

  SuspensionListView({
    Key key,
    @required this.data,
    @required this.contentWidget,
    @required this.suspensionWidget,
    @required this.controller,
    this.suspensionHeight: 40,
    this.itemHeight: 50,
    this.onSusTagChanged,
    this.onSusSectionInited,
    this.header,
  })  : assert(contentWidget != null),
        assert(controller != null),
        super(key: key);

  @override
  _SuspensionWidgetState createState() => new _SuspensionWidgetState();
}

class _SuspensionWidgetState extends State<SuspensionListView> {
  int _suspensionTop = 0;
  int _lastIndex;
  int _suSectionListLength;

  List<int> _suspensionSectionList = new List();
  Map<String, int> _suspensionSectionMap = new Map();

  @override
  void initState() {
    super.initState();
    if (widget.header != null) {
      _suspensionTop = -widget.header.height;
    }
    widget.controller.addListener(() {
      int offset = widget.controller.offset.toInt();
      int _index = _getIndex(offset);
      if (_index != -1 && _lastIndex != _index) {
        _lastIndex = _index;
        if (widget.onSusTagChanged != null) {
          widget.onSusTagChanged(_suspensionSectionMap.keys.toList()[_index]);
        }
      }
    });
  }

  int _getIndex(int offset) {
    if (widget.header != null && offset < widget.header.height) {
      if (_suspensionTop != -widget.header.height &&
          widget.suspensionWidget != null) {
        setState(() {
          _suspensionTop = -widget.header.height;
        });
      }
      return 0;
    }
    for (int i = 0; i < _suSectionListLength - 1; i++) {
      int space = _suspensionSectionList[i + 1] - offset;
      if (space > 0 && space < widget.suspensionHeight) {
        space = space - widget.suspensionHeight;
      } else {
        space = 0;
      }
      if (_suspensionTop != space && widget.suspensionWidget != null) {
        setState(() {
          _suspensionTop = space;
        });
      }
      int a = _suspensionSectionList[i];
      int b = _suspensionSectionList[i + 1];
      if (offset >= a && offset < b) {
        return i;
      }
      if (offset >= _suspensionSectionList[_suSectionListLength - 1]) {
        return _suSectionListLength - 1;
      }
    }
    return -1;
  }

  void _init() {
    _suspensionSectionMap.clear();
    int offset = 0;
    String tag;
    if (widget.header != null) {
      _suspensionSectionMap[widget.header.tag] = 0;
      offset = widget.header.height;
    }
    widget.data?.forEach((v) {
      if (tag != v.getSuspensionTag()) {
        tag = v.getSuspensionTag();
        _suspensionSectionMap.putIfAbsent(tag, () => offset);
        offset = offset + widget.suspensionHeight + widget.itemHeight;
      } else {
        offset = offset + widget.itemHeight;
      }
    });
    _suspensionSectionList
      ..clear()
      ..addAll(_suspensionSectionMap.values);
    _suSectionListLength = _suspensionSectionList.length;
    if (widget.onSusSectionInited != null) {
      widget.onSusSectionInited(_suspensionSectionMap);
    }
  }

  @override
  Widget build(BuildContext context) {
    _init();
    var children = <Widget>[
      widget.contentWidget,
    ];
    if (widget.suspensionWidget != null) {
      children.add(Positioned(
        top: _suspensionTop.toDouble() - 0.1,

        ///-0.1修复部分手机丢失精度问题
        left: 0.0,
        right: 0.0,
        child: widget.suspensionWidget,
      ));
    }
    return Stack(children: children);
  }
}

///调用它来为listview构建子对象。
typedef Widget ItemWidgetBuilder(BuildContext context, ISuspensionBean model);

typedef Widget IndexBarBuilder(
    BuildContext context, List<String> tags, IndexBarTouchCallback onTouch);
typedef Widget IndexHintBuilder(BuildContext context, String hint);

class QuickSelectListView extends StatefulWidget {
  QuickSelectListView(
      {Key key,
        this.data,
        this.topData,
        this.itemBuilder,
        this.suspensionWidget,
        this.isUseRealIndex: true,
        this.itemHeight: 50,
        this.suspensionHeight: 40,
        this.onSusTagChanged,
        this.header,
        this.indexBarBuilder,
        this.indexHintBuilder,
        this.showIndexHint: true})
      : assert(itemBuilder != null),
        super(key: key);

  ///with ISuspensionBean Data
  final List<ISuspensionBean> data;

  ///with ISuspensionBean topData, Do not participate in [A-Z] sorting (such as hotList).
  final List<ISuspensionBean> topData;

  final ItemWidgetBuilder itemBuilder;

  ///suspension widget.
  final Widget suspensionWidget;

  ///is use real index data.(false: use INDEX_DATA_DEF)
  final bool isUseRealIndex;

  ///item Height.
  final int itemHeight;

  ///suspension widget Height.
  final int suspensionHeight;

  ///on sus tag change callback.
  final ValueChanged<String> onSusTagChanged;

  final QuickSelectListViewHeader header;

  final IndexBarBuilder indexBarBuilder;

  final IndexHintBuilder indexHintBuilder;

  final bool showIndexHint;

  @override
  State<StatefulWidget> createState() {
    return new _QuickSelectListViewState();
  }
}

class _Header extends ISuspensionBean {
  String tag;

  @override
  String getSuspensionTag() => tag;

  @override
  bool get isShowSuspension => false;
}

class _QuickSelectListViewState extends State<QuickSelectListView> {
  Map<String, int> _suspensionSectionMap = Map();
  List<ISuspensionBean> _cityList = List();
  List<String> _indexTagList = List();
  bool _isShowIndexBarHint = false;
  String _indexBarHint = "";

  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onIndexBarTouch(IndexBarDetails model) {
    setState(() {
      _indexBarHint = model.tag;
      _isShowIndexBarHint = model.isTouchDown;
      int offset = _suspensionSectionMap[model.tag];
      if (offset != null) {
        _scrollController.jumpTo(offset
            .toDouble()
            .clamp(.0, _scrollController.position.maxScrollExtent));
      }
    });
  }

  void _init() {
    _cityList.clear();
    if (widget.topData != null && widget.topData.isNotEmpty) {
      _cityList.addAll(widget.topData);
    }
    List<ISuspensionBean> list = widget.data;
    if (list != null && list.isNotEmpty) {
      SuspensionUtil.sortListBySuspensionTag(list);
      _cityList.addAll(list);
    }

    SuspensionUtil.setShowSuspensionStatus(_cityList);

    if (widget.header != null) {
      _cityList.insert(0, _Header()..tag = widget.header.tag);
    }
    _indexTagList.clear();
    if (widget.isUseRealIndex) {
      _indexTagList.addAll(SuspensionUtil.getTagIndexList(_cityList));
    } else {
      _indexTagList.addAll(INDEX_DATA_DEF);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _personalModel = Provider.of<PersonalBrand>(context);
    _init();
    var children = <Widget>[
      SuspensionListView(
        data: widget.header == null ? _cityList : _cityList.sublist(1),
        contentWidget: ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: _cityList.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0 && _cityList[index] is _Header) {
                return SizedBox(
                    height: widget.header.height.toDouble(),
                    child: widget.header.builder(context));
              }
              return widget.itemBuilder(context, _cityList[index]);
            }),
        suspensionWidget: widget.suspensionWidget,
        controller: _scrollController,
        suspensionHeight: widget.suspensionHeight,
        itemHeight: widget.itemHeight,
        onSusTagChanged: widget.onSusTagChanged,
        header: widget.header,
        onSusSectionInited: (Map<String, int> map) =>
        _suspensionSectionMap = map,
      )
    ];

    Widget indexBar;
    if (widget.indexBarBuilder == null) {
      indexBar = IndexBar(
        data: _indexTagList,
        width: 36,
        onTouch: _onIndexBarTouch,
      );
    } else {
      indexBar = widget.indexBarBuilder(
        context,
        _indexTagList,
        _onIndexBarTouch,
      );
    }
    children.add(Align(
      alignment: Alignment.centerRight,
      child: indexBar,
    ));
    Widget indexHint;
    if (widget.indexHintBuilder != null) {
      indexHint = widget.indexHintBuilder(context, '$_indexBarHint');
    } else {
      indexHint = Card(
        color: Colors.black54,
        child: Container(
          alignment: Alignment.center,
          width: ScreenUtil().setWidth(80.0),
          height: ScreenUtil().setHeight(80.0),
          child: Text(
            '$_indexBarHint',
            style: TextStyle(
              fontSize: ScreenUtil().setSp(32.0),
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    if (_isShowIndexBarHint && widget.showIndexHint) {
      children.add(
          _personalModel.bars==true?Center(
            child: indexHint,
          ):Container());
    }
    return Stack(children: children);
  }
}

///Suspension Util.
class SuspensionUtil {
  ///sort list  by suspension tag.
  static void sortListBySuspensionTag(List<ISuspensionBean> list) {
    if (list == null || list.isEmpty) return;
    list.sort((a, b) {
      if (a.getSuspensionTag() == "@" || b.getSuspensionTag() == "#") {
        return -1;
      } else if (a.getSuspensionTag() == "#" || b.getSuspensionTag() == "@") {
        return 1;
      } else {
        return a.getSuspensionTag().compareTo(b.getSuspensionTag());
      }
    });
  }

  ///通过悬挂标签获取索引数据列表
  static List<String> getTagIndexList(List<ISuspensionBean> list) {
    List<String> indexData = new List();
    if (list != null && list.isNotEmpty) {
      String tempTag;
      for (int i = 0, length = list.length; i < length; i++) {
        String tag = list[i].getSuspensionTag();
        if (tag.length > 2) tag = tag.substring(0, 2);
        if (tempTag != tag) {
          indexData.add(tag);
          tempTag = tag;
        }
      }
    }
    return indexData;
  }

  ///设置显示暂停状态。
  static void setShowSuspensionStatus(List<ISuspensionBean> list) {
    if (list == null || list.isEmpty) return;
    String tempTag;
    for (int i = 0, length = list.length; i < length; i++) {
      String tag = list[i].getSuspensionTag();
      if (tempTag != tag) {
        tempTag = tag;
        list[i].isShowSuspension = true;
      } else {
        list[i].isShowSuspension = false;
      }
    }
  }
}

///触摸回调IndexModel。
typedef void IndexBarTouchCallback(IndexBarDetails model);

///IndexModel.
class IndexBarDetails {
  String tag; //current touch tag.
  int position; //current touch position.
  bool isTouchDown; //is touch down.

  IndexBarDetails({this.tag, this.position, this.isTouchDown});
}

///默认索引数据。
const List<String> INDEX_DATA_DEF = const [
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z",
  "#"
];

class IndexBar extends StatefulWidget {
  IndexBar(
      {Key key,
        this.data: INDEX_DATA_DEF,
        @required this.onTouch,
        this.width: 30,
        this.itemHeight: 16,
        this.color = Colors.transparent,
        this.textStyle =
        const TextStyle(fontSize: 12.0, color: Color(0xFF666666)),
        this.touchDownColor = const Color(0xffeeeeee),
        this.touchDownTextStyle =
        const TextStyle(fontSize: 12.0, color: Colors.black)});

  ///索引数据。
  final List<String> data;

  ///IndexBar 宽度(def: 30)。
  final int width;

  ///IndexBar 项高度(def:16).
  final int itemHeight;

  /// 背景颜色
  final Color color;

  ///索引栏触摸颜色。
  final Color touchDownColor;

  ///IndexBar文本样式。
  final TextStyle textStyle;

  final TextStyle touchDownTextStyle;

  ///调项目联系。
  final IndexBarTouchCallback onTouch;

  @override
  _SuspensionListViewIndexBarState createState() =>
      _SuspensionListViewIndexBarState();
}

class _SuspensionListViewIndexBarState extends State<IndexBar> {
  bool _isTouchDown = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: _isTouchDown ? widget.touchDownColor : widget.color,
      width: widget.width.toDouble(),
      child: _IndexBar(
        data: widget.data,
        width: widget.width,
        itemHeight: widget.itemHeight,
        textStyle: widget.textStyle,
        touchDownTextStyle: widget.touchDownTextStyle,
        onTouch: (details) {
          if (widget.onTouch != null) {
            if (_isTouchDown != details.isTouchDown) {
              setState(() {
                _isTouchDown = details.isTouchDown;
              });
            }
            widget.onTouch(details);
          }
        },
      ),
    );
  }
}

/// Base IndexBar.
class _IndexBar extends StatefulWidget {
  ///索引数据。
  final List<String> data;

  ///IndexBar width(def:30).
  final int width;

  ///IndexBar item height(def:16).
  final int itemHeight;

  ///IndexBar text style.
  final TextStyle textStyle;

  final TextStyle touchDownTextStyle;

  ///调项目联系。
  final IndexBarTouchCallback onTouch;

  _IndexBar(
      {Key key,
        this.data: INDEX_DATA_DEF,
        @required this.onTouch,
        this.width: 30,
        this.itemHeight: 16,
        this.textStyle,
        this.touchDownTextStyle})
      : assert(onTouch != null),
        super(key: key);

  @override
  _IndexBarState createState() => _IndexBarState();
}

class _IndexBarState extends State<_IndexBar> {
  List<int> _indexSectionList = new List();
  int _widgetTop = -1;
  int _lastIndex = 0;
  bool _widgetTopChange = false;
  bool _isTouchDown = false;
  IndexBarDetails _indexModel = new IndexBarDetails();

  ///get index.
  int _getIndex(int offset) {
    for (int i = 0, length = _indexSectionList.length; i < length - 1; i++) {
      int a = _indexSectionList[i];
      int b = _indexSectionList[i + 1];
      if (offset >= a && offset < b) {
        return i;
      }
    }
    return -1;
  }

  void _init() {
    _widgetTopChange = true;
    _indexSectionList.clear();
    _indexSectionList.add(0);
    int tempHeight = 0;
    widget.data?.forEach((value) {
      tempHeight = tempHeight + widget.itemHeight;
      _indexSectionList.add(tempHeight);
    });
  }

  _triggerTouchEvent() {
    if (widget.onTouch != null) {
      widget.onTouch(_indexModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _personalModel = Provider.of<PersonalBrand>(context);
    TextStyle _style = widget.textStyle;
    if (_indexModel.isTouchDown == true) {
      _style = widget.touchDownTextStyle;
    }
    _init();

    List<Widget> children = new List();
    widget.data.forEach((v) {
      children.add( SizedBox(
//        width: widget.width.toDouble(),
//        height: widget.itemHeight.toDouble(),
        child:  Text(v, textAlign: TextAlign.center, style: _style),
      ));
    });

    return GestureDetector(
      onVerticalDragDown: (DragDownDetails details) {
        if (_widgetTop == -1 || _widgetTopChange) {
          _widgetTopChange = false;
          RenderBox box = context.findRenderObject();
          Offset topLeftPosition = box.localToGlobal(Offset.zero);
          _widgetTop = topLeftPosition.dy.toInt();
        }
        int offset = details.globalPosition.dy.toInt() - _widgetTop;
        int index = _getIndex(offset);
        if (index != -1) {
          _lastIndex = index;
          _indexModel.position = index;
          _indexModel.tag = widget.data[index];
          _indexModel.isTouchDown = true;
          _personalModel.SetAllbar();
          Future.delayed(Duration(seconds: 1), () {
            _personalModel.SetAllbars();
          });
          _triggerTouchEvent();
        }
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        int offset = details.globalPosition.dy.toInt() - _widgetTop;
        int index = _getIndex(offset);
        if (index != -1 && _lastIndex != index) {
          _lastIndex = index;
          _indexModel.position = index;
          _indexModel.tag = widget.data[index];
          _indexModel.isTouchDown = true;
          _triggerTouchEvent();
        }
      },
      onVerticalDragEnd: (DragEndDetails details) {
        _indexModel.isTouchDown = false;
        _triggerTouchEvent();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
