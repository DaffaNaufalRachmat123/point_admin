import 'package:dio/dio.dart';
import 'package:points_admin/Utils/UriConfig.dart';

class UsersPOintService {
  static Dio dio = new Dio();
  static Future getUsersById(String token , int id) async {
    var response = await dio.get(UriConfig.url + "/api/users/point/" + id.toString() , options : Options(
      headers : {
        "Content-Type" : "application/json",
        "Authorization" : token
      },
        followRedirects : false,
        validateStatus : (status) {
          return status <= 500;
        }
    ));
    if(response.statusCode == 200){
      return response.data;
    } else {
      return null;
    }
  }
  static Future getRewardsList(String token , int id) async {
    var response = await dio.get(UriConfig.url + "/api/users/reward_list/" + id.toString() , options : Options(
      headers : {
        "Content-Type" : "application/json",
        "Authorization" : token
      },
        followRedirects : false,
        validateStatus : (status) {
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