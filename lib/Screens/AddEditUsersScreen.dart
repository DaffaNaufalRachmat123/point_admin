import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:points_admin/Models/Users.dart';
import 'package:points_admin/Utils/Constant.dart';
import 'package:points_admin/ViewModels/UsersProvider.dart';
import 'package:provider/provider.dart';
import 'package:points_admin/Utils/StyleDecoration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';

class AddEditUsersScreen extends StatelessWidget {
  bool isEdit = false;
  int id = 0;
  AddEditUsersScreen({Key key , this.isEdit , this.id}) : super(key : key);
  @override
  Widget build ( BuildContext context ){
    return Scaffold(
      appBar : AppBar(
        title : Text(isEdit ? 'Ubah User' : 'Tambah User')
      ),
      body : MultiProvider(
        providers : [
          ChangeNotifierProvider(
            builder : ( context ) => UsersProvider()
          )
        ],
        child : AddEditUsersScreens(this.isEdit , this.id)
      )
    );
  }
}

class AddEditUsersScreens extends StatefulWidget {
  bool isEdit;
  int id;
  AddEditUsersScreens(this.isEdit , this.id);
  @override
  AddEditUsersScreenState createState () => AddEditUsersScreenState();
}

class AddEditUsersScreenState extends State<AddEditUsersScreens>{
  bool isPasswordVisible = false;
  String selectedItems = "User";
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  Future<void> getUsersById(int id) async {
    final provider = Provider.of<UsersProvider>(context);
    var preferences = await SharedPreferences.getInstance();
    String token = preferences.getString(Constant.TOKEN);
    var response = await provider.getUserById(token , id);
    if(response != null){
      var decode = json.decode(response);
      print(decode);
      usernameController.text = decode['username'];
      emailController.text = decode['email'];
      if(this.mounted){
        setState((){
          selectedItems = decode['is_user_admin'].toString()[0].toUpperCase() + decode['is_user_admin'].toString().substring(1);
        });
      }
      print(selectedItems);
    }
  }
  Future<void> updateUser(String username , String email  , String is_user_admin) async {
    final provider = Provider.of<UsersProvider>(context);
    var preferences = await SharedPreferences.getInstance();
    String token = preferences.getString(Constant.TOKEN);
    Users users = new Users();
    users.id = widget.id;
    users.username = username;
    users.email = email;
    users.password = '';
    users.is_user_admin = is_user_admin;
    var response = await provider.updateUser(token , users);
    if(response["server_message"].toString().toLowerCase() == 'users updated'){
      Map response = {
        "username" : usernameController.text.toString(),
        "email" : emailController.text.toString(),
        "is_user_admin" : selectedItems
      };
      Navigator.pop(context , response);
    } else if(response["server_message"].toString().toLowerCase().contains("exist")) {
      SweetAlert.show(context , title : "Attention" , subtitle : "Email or username is exist");
    }
  }
  Future<void> createUser(String username , String email , String password , String is_user_admin) async {
    final provider = Provider.of<UsersProvider>(context);
    var preferences = await SharedPreferences.getInstance();
    String token = preferences.getString(Constant.TOKEN);
    var responses = await provider.createUser(token , username , email , password , is_user_admin);
    if(responses["server_message"].toString().toLowerCase() == 'user created'){
      Map<String , dynamic> callback = responses["callback"];
      Map response = {
        "status_code" : 200,
        "id" : callback["id"] as int,
        "username" : callback["username"] as String,
        "email" : callback["email"] as String,
        "password" : callback["password"] as String,
        "is_user_admin" : callback["is_user_admin"] as String,
        "transactions_count" : callback["transactions_count"] as int,
        "users_point" : callback["users_point"]
      };
      Navigator.pop(context , response);
    } else if(responses["server_message"].toString().toLowerCase().contains('registered')) {
      SweetAlert.show(context , 
                  title : 'Attention',
                  subtitle : 'Username or Email is used');
    }
  }
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
  Widget buildEmailTextField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style : labelStyle
        ),
        SizedBox(height : 10),
        Container(
          alignment : Alignment.centerLeft,
          decoration : boxDecorationStyle,
          height : 60.0,
          child : TextFormField(
            controller : emailController ,
            keyboardType : TextInputType.emailAddress,
            style : TextStyle(
              color : Colors.white,
              fontFamily : 'OpenSans'
            ),
            decoration : InputDecoration(
              border : InputBorder.none,
              contentPadding : EdgeInsets.only(top : 14.0),
              prefixIcon : Icon(
                Icons.email,
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
  @override
  Widget build ( BuildContext context ){
    final provider = Provider.of<UsersProvider>(context);
    if(widget.isEdit){
      getUsersById(widget.id);
    }
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
                  child : Column(
                    mainAxisAlignment : MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height : 30.0),
                      buildUsernameTextField(),
                      SizedBox(height : 20.0),
                      buildEmailTextField(),
                      SizedBox(height : 20.0),
                      widget.isEdit ? Column() : 
                      Column(
                        children: <Widget>[
                          buildPasswordTextField(),
                        ],
                      ),
                      SizedBox(height : 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Pilih Level Pengguna',
                            style : labelStyle
                          ),
                        ],
                      ),
                      SizedBox(height : 10),
                      Container(
                        padding : const EdgeInsets.only(left : 10.0 , right : 10.0),
                        decoration : BoxDecoration(
                          borderRadius : BorderRadius.circular(10.0),
                          color : Colors.blue
                        ),
                        child : DropdownButtonHideUnderline(
                          child : DropdownButton(
                            isExpanded : true,
                            value : selectedItems,
                            items : ["User" , "Admin"].map((value){
                              return DropdownMenuItem(
                                child : Text(value , style : TextStyle(
                                  color : Colors.black,
                                  fontFamily : 'OpenSans'
                                )), 
                                value : value
                              );
                            }).toList(),
                            onChanged : (value){
                              setState((){
                                selectedItems = value;
                              });
                            }
                          )
                        )
                      ),
                      SizedBox(height : 30.0),
                      provider.getFetching ? CircularProgressIndicator() : 
                      Container(
                        padding : EdgeInsets.symmetric(vertical : 10.0),
                        width : double.infinity,
                        child : RaisedButton(
                          elevation : 5.0,
                          onPressed: () async => {
                            if(usernameController.text.toString().isNotEmpty &&
                                emailController.text.toString().isNotEmpty){
                                  if(widget.isEdit){
                                    updateUser(usernameController.text.toString() , emailController.text.toString() , 
                                                selectedItems)
                                  } else {
                                    createUser(usernameController.text.toString() , emailController.text.toString() ,
                                                passwordController.text.toString() , selectedItems)
                                  }
                            } else {
                              SweetAlert.show(context , title : 'Perhatian !' , subtitle : 'Harap isi semua kolom' , style : SweetAlertStyle.confirm)
                            }
                          },
                          padding : EdgeInsets.all(15.0),
                          shape : RoundedRectangleBorder(
                            borderRadius : BorderRadius.circular(30.0)
                          ),
                          color : Colors.white,
                          child : Text(
                            widget.isEdit ? 'Perbarui User' : 'Buat User',
                            style : TextStyle(
                              color : Color(0xFF527DAA),
                              fontFamily : 'OpenSans',
                              letterSpacing : 1.2,
                              fontWeight : FontWeight.bold,
                              fontSize : 17.0
                            )
                          )
                        )
                      )
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