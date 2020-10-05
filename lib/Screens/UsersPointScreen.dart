import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:points_admin/Screens/LoginScreen.dart';
import 'package:points_admin/Utils/Constant.dart';
import 'package:points_admin/ViewModels/UsersPointProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersPointScreen extends StatelessWidget {
  @override
  Widget build ( BuildContext context ){
    return MultiProvider(
      providers : [
        ChangeNotifierProvider(
          builder : ( context ) => UsersPointProvider()
        )
      ],
      child : UsersPointScreens()
    );
  }
}

class UsersPointScreens extends StatefulWidget {
  @override
  UsersPointScreenState createState () => UsersPointScreenState();
}

class UsersPointScreenState extends State<UsersPointScreens>{
  String token = "";
  int id = 0;
  @override
  void initState(){
    getTokenAndId();
    super.initState();
  }
  Future<void> logout() async {
    var preferences = await SharedPreferences.getInstance();
    preferences.clear();
    Navigator.pushAndRemoveUntil(context , MaterialPageRoute(
      builder : ( context ) => LoginScreen()
    ) , (Route<dynamic> routes) => false);
  }
  void getTokenAndId() async {
    var preferences = await SharedPreferences.getInstance();
    if(this.mounted){
      print(json.decode(preferences.getString(Constant.PAYLOAD_PREFERENCES)));
      setState((){
        token = preferences.getString(Constant.TOKEN);
        id = json.decode(preferences.getString(Constant.PAYLOAD_PREFERENCES))["data"]["id"] as int;
      });
    }
  }
  Widget buildLoginButton(){
    return Container(
      padding : EdgeInsets.symmetric(vertical : 10.0),
      margin : EdgeInsets.symmetric(horizontal : 50.0),
      width : double.infinity,
      child : RaisedButton(
        elevation : 5.0,
        onPressed : () async => {
          logout()
        },
        padding : EdgeInsets.all(15.0),
        shape : RoundedRectangleBorder(
          borderRadius : BorderRadius.circular(30.0)
        ),
        color : Colors.red,
        child : Text(
          'Keluar',
          style : TextStyle(
            letterSpacing : 1.2,
            fontSize : 18.0,
            fontWeight : FontWeight.bold,
            color: Colors.white,
            fontFamily: 'OpenSans'
          )
        )
      )
    );
  }
  @override
  Widget build ( BuildContext context ){
    final provider = Provider.of<UsersPointProvider>(context);
    if(token.isNotEmpty && id != 0){
      if(provider.point == 0){
        provider.getUsersPoint(token , id);
      }
    }
    return Scaffold(
      body : Container(
        width : double.infinity,
        height : double.infinity,
        child : Center(
          child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.star,
                size : 50.0,
                color : Colors.yellow
              ),
              SizedBox(height : 10),
              Text('Total Point' , style : TextStyle(
                color : Colors.black,
                fontFamily: 'OpenSans',
                fontWeight : FontWeight.bold,
                fontSize : 20.0
              )),
              Text(provider.point.toString() , style : TextStyle(
                color : Colors.yellow,
                fontFamily: 'OpenSans',
                fontWeight : FontWeight.bold,
                fontSize : 35.0
              )),
              buildLoginButton()
            ],
          )
        )
      )
    );
  }
}