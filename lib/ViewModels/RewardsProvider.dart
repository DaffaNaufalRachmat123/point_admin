import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:points_admin/Models/Rewards.dart';
import 'package:points_admin/Services/RewardsService.dart';

class RewardsProvider extends ChangeNotifier {
  List<Rewards> rewardsList = null;
  List<Rewards> get getRewardsList => rewardsList;
  bool isFetching = false;
  bool get getFetching => isFetching;
  int limit = 10;
  int offset = 0;
  Future<void> addNewRewards(Rewards rewards) async {
    if(rewardsList == null){
      rewardsList = new List<Rewards>();
    }
    rewardsList.insert(0 , rewards);
    notifyListeners();
  }
  Future<void> changeUpdate(Rewards rewards , int index) async {
    if(rewardsList != null){
      rewardsList[index] = rewards;
      notifyListeners();
    }
  }
  Future<void> removeRewards(int index) async {
    if(rewardsList != null){
      rewardsList.removeAt(index);
      notifyListeners();
    }
  }
  Future getAllRewardsList(String token) async {
    setFetching(true);
    if(rewardsList == null)
      rewardsList = new List<Rewards>();
    var data = await RewardsService.getRewardsList(token , limit , offset);
    if(data != null){
      var datas = json.decode(data);
      for(int i = 0; i < datas.length; i++){
        rewardsList.add(Rewards.fromJson(datas[i]));
      }
    }
    setFetching(false);
  }
  Future getRewardsById(int id , String token) async {
    var data = await RewardsService.getRewardsById(id , token);
    return data;
  }
  Future createRewards(String token , Rewards rewards) async {
    var data = await RewardsService.createRewards(token , rewards);
    return data;
  }
  Future updateRewards(String token , Rewards rewards) async {
    var data = await RewardsService.updateRewards(token , rewards);
    return data;
  }
  Future deleteRewards(String token , int id) async {
    var data = await RewardsService.removeRewards(token , id);
    return data;
  }
  Future<void> setFetching(bool value){
    isFetching = value;
    notifyListeners();
  }
}