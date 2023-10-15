import 'package:flutter/material.dart';

class PersonalBrand with ChangeNotifier {
  bool allBrand = false;//展示全部品牌
  bool bar = false;//展示全部品牌
  List allBrandList = [];
  get AllBrands => allBrand;
  get AllBrandList => allBrandList;
  get bars => bar;


//  改变状态
  void SetAllBrand(){
    allBrand = !allBrand;
    notifyListeners();
  }
//  改变悬浮展示
  void SetAllbar(){
    bar = true;
    notifyListeners();
  }
  void SetAllbars(){
    bar = false;
    notifyListeners();
  }
}