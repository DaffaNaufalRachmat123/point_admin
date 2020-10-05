import 'package:dio/dio.dart';
import 'package:points_admin/Models/Rewards.dart';
import 'package:points_admin/Utils/UriConfig.dart';

class RewardsService {
  static Dio dio = new Dio();
  static Future getRewardsList(String token , int limit , int offset) async {
    var response = await dio.get(UriConfig.url + "/api/rewards/index/" + limit.toString() + "/" + offset.toString() , options : Options(
      headers : {
        "Content-Type" : "application/json",
        "Authorization" : token
      },
      followRedirects : false,
      validateStatus : (status){
        return status <= 500;
      }
    ));
    if(response.statusCode == 200){
      return response.data;
    } else {
      return null;
    }
  }
  static Future getRewardsById(int id , String token) async {
    var response = await dio.get(UriConfig.url + "/api/rewards/get/" + id.toString() , options : Options(
      headers : {
        "Content-Type" : "application/json",
        "Authorization" : token
      },
      followRedirects : false,
      validateStatus: (status){
        return status <= 500;
      }
    ));
    if(response.statusCode == 200){
      return response.data;
    } else {
      return null;
    }
  }
  static Future createRewards(String token , Rewards rewards) async {
    var response = await dio.post(UriConfig.url + "/api/rewards/create" , data : rewards.toJsonCreate() , options : Options(
      headers : {
        "Content-Type" : "application/json",
        "Authorization" : token
      },
      followRedirects : false,
      validateStatus : (status){
        return status <= 500;
      }
    ));
    print(response);
    if(response.statusCode == 200){
      return response.data;
    } else {
      return null;
    }
  }
  static Future updateRewards(String token , Rewards rewards) async {
    var response = await dio.put(UriConfig.url + "/api/rewards/update/" + rewards.id.toString() , data : rewards.toJsonUpdate() , options : Options(
      headers : {
        "Content-Type" : "application/json",
        "Authorization" : token
      },
      followRedirects : false,
      validateStatus : (status){
        return status <= 500;
      }
    ));
    if(response.statusCode == 200){
      return response.data;
    } else {
      return null;
    }
  }
  static Future removeRewards(String token , int id) async {
    var response = await dio.delete(UriConfig.url + "/api/rewards/remove/" + id.toString() , options : Options(
      headers : {
        "Content-Type" : "application/json",
        "Authorization" : token
      },
      followRedirects : false,
      validateStatus : (status){
        return status <= 500;
      }
    ));
    print(response);
    if(response.statusCode == 200){
      return response.data;
    } else {
      return null;
    }
  }
}