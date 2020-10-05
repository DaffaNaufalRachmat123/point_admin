import 'package:flutter/material.dart';
import 'package:points_admin/Models/Transactions.dart';
import 'package:points_admin/Models/Users.dart';
import 'package:points_admin/Services/TransactionsService.dart';
import 'dart:convert';

import 'package:points_admin/Services/UsersService.dart';

class TransactionsProvider extends ChangeNotifier {
  List<Transactions> transactionsList = null;
  List<Transactions> get getTransactionsList => transactionsList;
  List<Users> usersList = null;
  List<String> dropdownUserList = new List<String>();
  List<Users> get getUsersList => usersList;
  bool isFetching = false;
  bool get getFetching => isFetching;
  int limit = 10;
  int offset = 0;
  Future<void> getAllUsersList(String token) async {
    setFetching(true);
    if(usersList == null)
      usersList = new List<Users>();
    var data = await UsersService.getUsersListTransactions(token , limit , offset);
    print(data);//
    if(data != null){
      var datas = json.decode(data);
      for(int i = 0; i < datas.length; i++){
        dropdownUserList.add(Users.fromJson(datas[i]).username);
        usersList.add(Users.fromJson(datas[i]));
      }
    }
    setFetching(false);
  }
  Future<void> addNewTransactions(Transactions transactions) async {
    if(transactionsList == null){
      transactionsList = new List<Transactions>();
    }
    transactionsList.insert(0 , transactions);
    notifyListeners();
  }
  Future<void> changeUpdate(Transactions transactions , int index) async {
    if(transactionsList != null){
      transactionsList[index] = transactions;
      notifyListeners();
    }
  }
  Future removeTransactions(int index) async {
    if(transactionsList != null){
      transactionsList.removeAt(index);
      notifyListeners();
    }
  }
  Future getAllTransactionsList(String token) async {
    setFetching(true);
    if(transactionsList == null)
      transactionsList = new List<Transactions>();
    var data = await TransactionsService.getAllTransactionList(token , limit , offset);
    if(data != null){
      var datas = json.decode(data);
      for(int i = 0; i < datas.length; i++){
        transactionsList.add(Transactions.fromJson(datas[i]));
      }
    }
    setFetching(false);
  }
  Future getTransactionsById(int id , String token) async {
    var data = await TransactionsService.getTransactionById(token , id);
    return data;
  }
  Future createTransactions(String token , Transactions rewards) async {
    var data = await TransactionsService.createTransaction(token , rewards);
    return data;
  }
  Future updateTransactions(String token , Transactions rewards) async {
    var data = await TransactionsService.updateTransaction(token , rewards);
    return data;
  }
  Future deleteTransactions(String token , int id) async {
    var data = await TransactionsService.deleteTransaction(token , id);
    return data;
  }
  Future<void> setFetching(bool value){
    isFetching = value;
    notifyListeners();
  }
}