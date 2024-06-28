import 'package:wowfit/Models/userModel.dart';
import 'package:wowfit/controller/registerController.dart';

String getGenderPathString(String path){
  if(currentUser.gender==Gender.female){
    return path;
  }else{
    var a = path.split(".");
    return("${a.first}_male.${a.last}");
  }
}