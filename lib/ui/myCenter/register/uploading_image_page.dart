import 'package:flutter/material.dart';
import 'package:flutter_widget_one/untils/customTools/awit_tool/awitTools.dart';
import 'dart:async';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_widget_one/untils/httpRequest/dio.dart';
import 'package:toast/toast.dart';
import '../../../untils/httpRequest/http_url.dart';
import '../../../untils/httpRequest/https_untils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../myCenter/password/login_page.dart';
import '../../../common/model/provider_personal.dart';
import 'package:flutter_widget_one/untils/httpRequest/dio.dart';
import 'package:dio/dio.dart';
class UploadingImage extends StatefulWidget {
  final arguments;
  UploadingImage({this.arguments,});
  @override
  _UploadingImageState createState() => _UploadingImageState();
}

enum AppState {
  free,
  picked,
  cropped,
}

class _UploadingImageState extends State<UploadingImage> {
  AppState state;
  File imageFile;//上个页面传的值
  int _id;//消费者id
  var _idImg;//图片id
  bool upLoading = false;//上传
  @override
  void initState() {
    super.initState();
    state = AppState.free;
    imageFile = widget.arguments;
//    _particularsa();
//    if(widget.arguments==1){
//      _pickImage();
//    }else if(widget.arguments==2){
//      _getImage();
//    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: imageFile != null ? Image.file(imageFile) :
        Container(
          child: Center(
            child: Text("正在读取图片...."),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _cropImage();
//          if (state == AppState.free)
//            _pickImage();
//          else if (state == AppState.picked)
//            _cropImage();
//          else if (state == AppState.cropped) _clearImage();
        },
        child: Text("裁剪"),
      ),
    );
  }

//打开图库
//  Future<Null> _pickImage() async {
//    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
//    if (imageFile != null) {
//      setState(() {
//        state = AppState.picked;
//      });
//    }
//  }
//打开相机
//  Future<Null> _getImage() async {
//    imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
//    if (imageFile != null) {
//      setState(() {
//        state = AppState.picked;
//      });
//    }
//  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.grey,
          toolbarTitle:  '裁剪',
          toolbarWidgetColor: Colors.white,
        )
    );
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
        _uploadImg(croppedFile);
        upLoading = true;
      });
    }
  }

  //上传图片
  _uploadImg(File imgfile,) async {
    String path = imgfile.path;
    var names = path.substring(path.lastIndexOf("/") + 1, path.length);
//    print("names:$names");
    if(names.endsWith("jpg")==true||names.endsWith("png")==true||names.endsWith("jpeg")==true){
      FormData formData = new FormData.from({
        "file": UploadFileInfo(File(path), names),
        "fileName	": names,
      });
      var response = await ShopPaperImgDao2.uploadHttp("uploadImg", formData);
      if(response["code"]==0){
        print(response);
        setState(() {
          _idImg = response["data"];
        });
        Navigator.pop(context,_idImg);
//        Navigator.pushNamed(context,'/personalDetails',arguments: _idImg);
      }else if(response["code"]==401){
        Toast.show("登录已过期", context, duration: 1, gravity:  Toast.CENTER);
        Navigator.pushNamed(context, '/LoginPage');
      }else{
        Toast.show("${response.data["msg"]}", context, duration: 2, gravity:  Toast.CENTER);
      }
    }else{
      Toast.show("图片格式不正确，请更换图片", context, duration: 2, gravity:  Toast.CENTER);
    }
  }

}