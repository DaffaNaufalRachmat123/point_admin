import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:points_admin/Models/Users.dart';
import 'package:points_admin/Screens/HomeScreen.dart';
import 'package:points_admin/Screens/UsersHomeScreen.dart';
import 'package:points_admin/Utils/Constant.dart';
import 'package:points_admin/Utils/StyleDecoration.dart';
import 'package:points_admin/ViewModels/UsersProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build ( BuildContext context ){
    return Scaffold(
      body : MultiProvider(
        providers : [
          ChangeNotifierProvider(
            builder : ( context ) => UsersProvider()
          )
        ],
        child : LoginScreens()
      )
    );
  }
}

class LoginScreens extends StatefulWidget {
  @override
  LoginScreenState createState () => LoginScreenState();
}

class LoginScreenState extends State<LoginScreens>{
  bool rememberMe = false;
  bool isPasswordVisible = false;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  Widget buildUsernameTextField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Username',
          style : labelStyle
        ),
        SizedBox(height : 10),
        Container(
          alignment : Alignment.centerLeft,
          decoration : boxDecorationStyle,
          height : 60.0,
          child : TextFormField(
            controller : usernameController,
            keyboardType : TextInputType.emailAddress,
            style : TextStyle(
              color : Colors.white,
              fontFamily : 'OpenSans'
            ),
            decoration : InputDecoration(
              border : InputBorder.none,
              contentPadding : EdgeInsets.only(top : 14.0),
              prefixIcon : Icon(
                Icons.person,
                color : Colors.white
              ),
              hintText : 'Enter your email',
              hintStyle : hintTextStyle
            )
          )
        )
      ],
    );
  }
  Widget buildPasswordTextField(){
    return Column(
      crossAxisAlignment : CrossAxisAlignment.start,
      children: <Widget>[
        Text('Password' , 
        style : labelStyle),
        SizedBox(height : 10),
        Container(
          alignment : Alignment.centerLeft,
          decoration : boxDecorationStyle,
          height : 60.0,
          child : TextFormField(
            controller : passwordController,
            obscureText : !isPasswordVisible,
            keyboardType : TextInputType.text,
            style : TextStyle(
              fontFamily : 'OpenSans',
              color : Colors.white
            ),
            decoration : InputDecoration(
              border : InputBorder.none,
              contentPadding : EdgeInsets.only(top : 14.0),
              prefixIcon : IconButton(
                icon : Icon(Icons.lock , color : Colors.white)
              ),
              suffixIcon : IconButton(
                icon : Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color : Colors.white
                ),
                onPressed : (){
                  setState((){
                    isPasswordVisible = !isPasswordVisible;
                  });
                }
              ),
              hintText : 'Password',
              hintStyle : hintTextStyle
            )
          )
        )
      ],
    );
  }
  Widget buildRememberMeCheckBox(){
    return Container(
      height : 20.0,
      child : Row(
        children: <Widget>[
          Theme(
            data : ThemeData(unselectedWidgetColor : Colors.white),
            child : Checkbox(
              value : rememberMe,
              checkColor : Colors.green,
              activeColor : Colors.white,
              onChanged : (value){
                setState((){
                  rememberMe = value;
                });
              }
            )
          ),
          Text(
            'Remember Me',
            style : labelStyle
          )
        ],
      )
    );
  }
  @override
  void initState(){
    getAuthenticationLogin();
    super.initState();
  }
  Future<void> getAuthenticationLogin() async {
    var preferences = await SharedPreferences.getInstance();
    String data = preferences.getString(Constant.PAYLOAD_PREFERENCES);
    if(data != null){
      var payload_json = json.decode(data);
      if(payload_json["is_logged_in"] == true){
        if(payload_json["data"]["is_user_admin"].toString().toLowerCase() == "user"){
          Navigator.pushAndRemoveUntil(context , MaterialPageRoute(
            builder : ( context ) => UsersHomeScreen()
          ) , (Route<dynamic> routes) => false);
        } else if(payload_json["data"]["is_user_admin"].toString().toLowerCase() == "admin"){
          Navigator.pushAndRemoveUntil(context , MaterialPageRoute(
            builder : ( context ) => HomeScreen()
          ) , (Route<dynamic> routes) => false);
        }
      }
    }
  }
  Future<void> loginUser(String username , String password) async {
    final provider = Provider.of<UsersProvider>(context);
    var preferences = await SharedPreferences.getInstance();
    var response = await provider.loginUser(username , password);
    String message = response['server_message'].toString().toLowerCase();
    if(message == "login successful"){
      Map payload_preferences = {
        "is_logged_in" : true,
        "data" : {
          "id" : response["data"]["id"],
          "username" : response["data"]["username"],
          "email" : response["data"]["email"],
          "is_user_admin" : response["data"]["is_user_admin"]
        }
      };
      print('TOKENS : ' + response['token']);
      var payloads = json.encode(payload_preferences);
      preferences.setString(Constant.PAYLOAD_PREFERENCES , payloads.toString());
      preferences.setString(Constant.TOKEN , response["token"]);
      if(response["data"]["is_user_admin"].toString().toLowerCase() == "user"){
        Navigator.pushAndRemoveUntil(context , MaterialPageRoute(
          builder : ( context ) => UsersHomeScreen()
        ) , (Route<dynamic> routes) => false);
      } else if(response["data"]["is_user_admin"].toString().toLowerCase() == "admin"){
        Navigator.pushAndRemoveUntil(context , MaterialPageRoute(
          builder : ( context ) => HomeScreen()
        ) , (Route<dynamic> routes) => false);
      }
    } else if(message == "user not found"){
      
    } else if(message == "password didnt match"){

    }
  }
  Widget buildLoginButton(){
    return Container(
      padding : EdgeInsets.symmetric(vertical : 25.0),
      width : double.infinity,
      child : RaisedButton(
        elevation : 5.0,
        onPressed : () async => {
          if(usernameController.text.toString().isNotEmpty && 
            passwordController.text.toString().isNotEmpty){
              loginUser(usernameController.text.toString() , passwordController.text.toString())
            } else {
              SweetAlert.show(context , title : 'Attention' , subtitle : 'Please fill username and password' , style : SweetAlertStyle.confirm)
            }
        },
        padding : EdgeInsets.all(15.0),
        shape : RoundedRectangleBorder(
          borderRadius : BorderRadius.circular(30.0)
        ),
        color : Colors.white,
        child : Text(
          'Login',
          style : TextStyle(
            letterSpacing : 1.2,
            fontSize : 18.0,
            fontWeight : FontWeight.bold,
            color: Color(0xFF527DAA),
            fontFamily: 'OpenSans'
          )
        )
      )
    );
  }
  @override
  Widget build ( BuildContext context ){
    return Scaffold(
      body : AnnotatedRegion<SystemUiOverlayStyle>(
        value : SystemUiOverlayStyle.light,
        child : GestureDetector(
          onTap : () => FocusScope.of(context).unfocus(),
          child : Stack(
            children: <Widget>[
              Container(
                height : double.infinity,
                width : double.infinity,
                decoration : BoxDecoration(
                  gradient : LinearGradient(
                    begin : Alignment.topCenter,
                    end : Alignment.bottomCenter,
                    colors : [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops : [0.1 , 0.4 , 0.7 , 0.9]
                  )
                )
              ),
              Container(
                height : double.infinity,
                padding : EdgeInsets.only(left : 20.0 , right : 20.0),
                child : SingleChildScrollView(
                  physics : AlwaysScrollableScrollPhysics(),
                  padding : EdgeInsets.symmetric(
                    horizontal : 4.0,
                    vertical : 120.0
                  ),
                  child : Column(
                    mainAxisAlignment : MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Point Admin',
                        style : TextStyle(
                          color : Colors.white,
                          fontFamily : 'OpenSans',
                          fontSize : 30.0,
                          fontWeight : FontWeight.bold
                        )
                      ),
                      Text(
                        'Sign In',
                        style : TextStyle(
                          color : Colors.white,
                          fontFamily : 'OpenSans',
                          fontSize : 25.0
                        )
                      ),
                      SizedBox(height : 30.0),
                      buildUsernameTextField(),
                      SizedBox(height : 20.0),
                      buildPasswordTextField(),
                      SizedBox(height : 25.0),
                      buildLoginButton()
                    ],
                  )
                )
              )
            ],
          )
        )
      )
    );
  }
}