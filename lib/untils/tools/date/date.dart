import 'package:flutter/material.dart';

import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class DatePickerInPage extends StatefulWidget {
  DatePickerInPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DatePickerInPageState();
}


const String INIT_DATETIME = '2018-10-21';
const String DATE_FORMAT = 'yyyy年|MM月,d日';

class _DatePickerInPageState extends State<DatePickerInPage> {
  DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.parse(INIT_DATETIME);
  }
  var now = new DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Container(

      child: Column(
        children: <Widget>[
          Container(
            child: DatePickerWidget(
              minDateTime: DateTime.parse('1900-00-00'),
              maxDateTime: DateTime.parse("$now"),
              initialDateTime: DateTime.parse(INIT_DATETIME),
              dateFormat: DATE_FORMAT,
              pickerTheme: DateTimePickerTheme(
                backgroundColor: Colors.white,
                cancelTextStyle: TextStyle(color: Colors.black),
                confirmTextStyle: TextStyle(color: Colors.black,),
                itemTextStyle: TextStyle(color: Colors.black),
                pickerHeight: ScreenUtil().setHeight(370),
                titleHeight:ScreenUtil().setHeight(0),
                itemHeight: ScreenUtil().setHeight(80),
              ),
              onChange: (dateTime, selectedIndex) {
                setState(() {
                  _dateTime = dateTime;
                });
              },
              onCancel: (){
                print("取消");
              },
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('    您的生日:',style: TextStyle(fontSize: ScreenUtil().setSp(30)),
//                  style: Theme.of(context).textTheme.subhead
              ),
              Container(
                height: ScreenUtil().setHeight(60),
                padding: EdgeInsets.only(left: 12.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  _dateTime != null
                      ? '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}'
                      : '',
                  style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                ),
              ),
              Spacer(),
              InkWell(
                child: Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Text("确定"),
                ),
                onTap: (){
                  String a = '${_dateTime.year}-${_dateTime.month.toString().padLeft(2, '0')}-${_dateTime.day.toString().padLeft(2, '0')}';
//                  DateTime _Times = new DateTime(_dateTime.year,_dateTime.month,_dateTime.day);
//                  _Times = DateTime.parse(a);
                  Navigator.pop(context,a);
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}