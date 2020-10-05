import 'package:dio/dio.dart';
import 'package:points_admin/Models/Transactions.dart';
import 'package:points_admin/Utils/UriConfig.dart';

class TransactionsService {
  static Dio dio = new Dio();
  static Future getAllTransactionList(String token , int limit , int offset) async {
    print('TOKEN : ' + token);
    var response = await dio.get(UriConfig.url + "/api/transactions/index/" + limit.toString() + "/" + offset.toString() , 
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
  static Future getTransactionById(String token , int id) async {
    var response = await dio.get(UriConfig.url + "/api/transactions/get/" + id.toString() , options : Options(
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
  static Future createTransaction(String token , Transactions transactions) async {
    var response = await dio.post(UriConfig.url + "/api/transactions/create" , data : transactions.toJsonCreate() , options : Options(
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
  static Future updateTransaction(String token , Transactions transactions) async {
    var response = await dio.put(UriConfig.url + "/api/transactions/update/" + transactions.id.toString() , data : transactions.toJsonUpdate() , options : Options(
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
  static Future deleteTransaction(String token , int id) async {
    var response = await dio.delete(UriConfig.url + "/api/transactions/remove/" + id.toString() , options : Options(
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