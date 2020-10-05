import 'package:dio/dio.dart';
import 'package:points_admin/Models/Users.dart';
import 'package:points_admin/Utils/UriConfig.dart';

class UsersService {
  static Dio dio = new Dio();
  static Future loginUser(Users users) async {
    var response = await dio.post(UriConfig.url + "/api/users/login" , data : users.toJsonLogin() , options : Options(
      headers : {
        "Content-Type" : "application/json"
      },
      followRedirects : false,
      validateStatus : (status){
        return status <= 500;
      }
    ));
    return response.data;
  }
  static Future getUsersList(String token , int limit , int offset) async {
    print('TOKEN : ' + token);
    var response = await dio.get(UriConfig.url + "/api/users/index/" + limit.toString() + "/" + offset.toString() , 
      options : Options(
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
  static Future getUsersListTransactions(String token , int limit , int offset) async {
    print('TOKEN : ' + token);
    var response = await dio.get(UriConfig.url + "/api/users/index/transactions" , 
      options : Options(
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
  static Future getUsersById(String token , int id) async {
    var response = await dio.get(UriConfig.url + "/api/users/get/" + id.toString() , options : Options(
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
  static Future createUser(String token , Users users) async {
    var response = await dio.post(UriConfig.url + "/api/users/create" , data : users.toJsonCreate() , options : Options(
      headers : {
        "Content-Type" : "application/json",
        "Authorization" : token
      },
        followRedirects : false,
        validateStatus : (status) {
          return status <= 500;
        }
    ));
    return response.data;
  }
  static Future updateUser(String token , Users users) async {
    var response = await dio.put(UriConfig.url + "/api/users/update/" + users.id.toString() , data : users.toJsonUpdate() , options : Options(
      headers : {
        "Content-Type" : "application/json",
        "Authorization" : token
      },
        followRedirects : false,
        validateStatus : (status) {
          return status <= 500;
        }
    ));
    return response.data;
  }
  static Future deleteUser(String token , int id) async {
    var response = await dio.delete(UriConfig.url + "/api/users/remove/" + id.toString() , options : Options(
      headers : {
        "Content-Type" : "application/json",
        "Authorization" : token
      },
        followRedirects : false,
        validateStatus : (status) {
          return status <= 500;
        }
    ));
    return response.data;
  }
}