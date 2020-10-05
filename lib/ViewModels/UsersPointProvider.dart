import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:points_admin/Models/Rewards.dart';
import 'package:points_admin/Services/UsersPointService.dart';

class UsersPointProvider extends ChangeNotifier {
  bool isFetching = false;
  bool get getFetching => isFetching;
  int point = 0;
  List<Rewards> rewardsList = null;
  List<Rewards> get getRewardsList => rewardsList;
  Future<void> getAllRewardsList(String token , int id) async {
    setFetching(true);
    if(rewardsList == null){
      rewardsList = new List<Rewards>();
    }
    var data = await UsersPOintService.getRewardsList(token , id);
    if(data != null && data != []){
      var datas = json.decode(data);
      for(int i = 0; i < datas.length; i++){
        rewardsList.add(Rewards.fromJson(datas[i]));
      }
    }
    setFetching(false);
    print(data);
  }
  Future<void> setFetching(bool value){
    isFetching = value;
    notifyListeners();
  }
  Future<void> getUsersPoint(String token , int id) async {
    var data = await UsersPOintService.getUsersById(token , id);
    print(data);
    var decode = json.decode(data);
    point = decode["users_point"];
    notifyListeners();
  }
}