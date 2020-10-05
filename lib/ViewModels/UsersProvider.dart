import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:points_admin/Models/Users.dart';
import 'package:points_admin/Services/UsersService.dart';

class UsersProvider extends ChangeNotifier {
  List<Users> usersList = null;
  List<Users> get getUsersList => usersList;
  int limit = 10;
  int offset = 0;
  bool isFetching = false;
  bool get getFetching => isFetching;
  bool isLoggedIn = false;
  bool get getLogin => isLoggedIn;
  Future loginUser(String username , String password) async {
    setFetching(true);
    Users users = new Users();
    users.id = 0;
    users.username = username;
    users.email = "";
    users.password = password;
    users.transactions_count = 0;
    users.users_point = 0;
    users.is_user_admin = 'user';
    var data = await UsersService.loginUser(users);
    print(data);
    setFetching(false);
    return data;
  }
  Future<void> setIsLoggedIn(bool value){
    isLoggedIn = value;
    notifyListeners();
  }
  Future<void> getAllUsersList(String token) async {
    setFetching(true);
    if(usersList == null)
      usersList = new List<Users>();
    var data = await UsersService.getUsersList(token , limit , offset);
    if(data != null){
      var datas = json.decode(data);
      for(int i = 0; i < datas.length; i++){
        usersList.add(Users.fromJson(datas[i]));
      }
    }
    setFetching(false);
  }
  Future<void> addNewUser(Users users) async {
    usersList.insert(0 , users);
    notifyListeners();
  }
  Future createUser(String token , String username , String email , String password , String is_user_admin) async {
    setFetching(true);
    Users users = new Users();
    users.id = 0;
    users.username = username;
    users.password = password;
    users.email = email;
    users.transactions_count = 0;
    users.users_point = 0;
    users.is_user_admin = is_user_admin;
    var data = await UsersService.createUser(token , users);
    print(data);
    setFetching(false);
    return data;
  }
  Future getUserById(String token , int id) async {
    var response = await UsersService.getUsersById(token , id);
    return response;
  }
  Future updateUser(String token , Users users) async {
    setFetching(true);
    var data = await UsersService.updateUser(token , users);
    print(data);
    setFetching(false);
    return data;
  }
  Future<void> changeUpdate(Users users , int index){
    usersList[index].username = users.username;
    usersList[index].email = users.email;
    usersList[index].is_user_admin = users.is_user_admin;
    notifyListeners();
  }
  Future<void> deleteUsers(int index) async {
    if(usersList != null){
      usersList.removeAt(index);
      notifyListeners();
    }
  }
  Future removeUsers(String token , int id) async {
    setFetching(true);
    var data = await UsersService.deleteUser(token , id);
    setFetching(false);
    return data;
  }
  Future<void> setFetching(bool value){
    isFetching = value;
    notifyListeners();
  }
}