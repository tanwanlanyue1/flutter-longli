import 'package:flutter/material.dart';


class PersonalShop with ChangeNotifier {
  List remove = [];
  bool allCheck = false;//全选
  get Removes => remove;
  get AllCheck => allCheck;



//  改变状态
  void SetAllBrand(ids){
    remove.add(ids);
    notifyListeners();
  }
  //移除数组中数据
  void SetAll(){
    remove = [];
    notifyListeners();
  }
  void SetAllRemove(ids){
    remove.remove(ids);
    notifyListeners();
  }
  //全选
  void SetAllCheck(){
    allCheck = !allCheck;
    notifyListeners();
  }
  void SetCheckTrue(){
    allCheck = true;
    notifyListeners();
  }
  void SetCheckFalse(){
    allCheck = false;
    notifyListeners();
  }
}