import 'package:flutter/material.dart';
import '../customData/prototype_data.dart';

class TestModel with ChangeNotifier {
  Map Testdata = Test;

  String versionName = '0-0-08';//版本号
  bool upgradable = false;//版本是否有更新
  bool updating = false;//强制更新
  Map entity = {
    'isForce':false
  };//版本信息是的需要更新

  get TextDatas => Testdata;
  get VersionName => versionName;
  get Entity => entity;
  get Upgradable => upgradable;
  get UpdatingS => updating;

  void setEntity(Map maps){
    entity = maps;
    notifyListeners();
  }

  void setUpgradable(bool bo){
    upgradable = bo;
    notifyListeners();
  }

  void setUpdatingS(bool bo){
    updating = bo;
    notifyListeners();
  }

}