import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:points_admin/Models/Rewards.dart';
import 'package:points_admin/Utils/Constant.dart';
import 'package:points_admin/ViewModels/RewardsProvider.dart';
import 'package:provider/provider.dart';
import 'package:points_admin/Utils/StyleDecoration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';


class AddEditRewardsScreen extends StatelessWidget {
  bool isEdit = false;
  int id = 0;
  AddEditRewardsScreen({Key key , this.isEdit , this.id}) : super(key : key);
  @override
  Widget build ( BuildContext context ){
    return Scaffold(
      appBar : AppBar(
        title : Text(isEdit ? 'Ubah Hadiah' : 'Tambah Hadiah')
      ),
      body : MultiProvider(
        providers : [
          ChangeNotifierProvider(
            builder : ( context ) => RewardsProvider()
          )
        ],
        child : AddEditRewardsScreens(this.isEdit , this.id)
      )
    );
  }
}

class AddEditRewardsScreens extends StatefulWidget {
  bool isEdit = false;
  int id = 0;
  AddEditRewardsScreens(this.isEdit , this.id);
  @override
  AddEditRewardsScreenState createState () => AddEditRewardsScreenState();
}

class AddEditRewardsScreenState extends State<AddEditRewardsScreens>{
  bool isLoading = false;
  final pointController = TextEditingController();
  final rewardController = TextEditingController();
  Future<void> createRewards(String rewards , int point) async {
    final provider = Provider.of<RewardsProvider>(context);
    var preferences = await SharedPreferences.getInstance();
    String token = preferences.getString(Constant.TOKEN);
    Rewards rewards = new Rewards();
    rewards.rewards = rewardController.text.toString();
    rewards.users_point = int.parse(pointController.text.toString());
    var responses = await provider.createRewards(token , rewards);
    print(responses);
    if(responses["server_message"].toString().toLowerCase().contains("created")){
      Map<String , dynamic> callback = responses["callback"];
      Map response = {
        "status_code" : 200,
        "id" : callback["id"] as int,
        "rewards" : callback["rewards"] as String,
        "users_point" : callback["users_point"] as int
      };
      Navigator.pop(context , response);
    } else {
      SweetAlert.show(context , title : "Attention" , subtitle : "Gagal Menambahkan Hadiah");
    }
  }
  Future<void> getRewardsById(int id) async {
    final provider = Provider.of<RewardsProvider>(context);
    var preferences = await SharedPreferences.getInstance();
    String token = preferences.getString(Constant.TOKEN);
    var response = await provider.getRewardsById(id , token);
    if(response != null){
      var decode = json.decode(response);
      print(decode);
      rewardController.text = decode['rewards'];
      pointController.text = decode['users_point'].toString();
    } 
  }
  Future<void> updateRewards(String rewards , int point) async {
    final provider = Provider.of<RewardsProvider>(context);
    var preferences = await SharedPreferences.getInstance();
    String token = preferences.getString(Constant.TOKEN);
    Rewards reward = new Rewards();
    reward.id = widget.id;
    reward.rewards = rewards;
    reward.users_point = point;
    var responses = await provider.updateRewards(token , reward);
    print(responses);
    if(responses != null){
      if(responses["server_message"].toString().toLowerCase().contains("updated")){
        Map response = {
          "status_code" : 200,
          "id" : widget.id,
          "rewards" : rewardController.text.toString(),
          "users_point" : int.parse(pointController.text.toString())
        };
        Navigator.pop(context , response);
      } else {

      }
    } else {

    }
  }
  Widget buildUsernameTextField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Nama Hadiah',
          style : labelStyle
        ),
        SizedBox(height : 10),
        Container(
          alignment : Alignment.centerLeft,
          decoration : boxDecorationStyle,
          height : 60.0,
          child : TextFormField(
            controller : rewardController,
            keyboardType : TextInputType.text,
            style : TextStyle(
              color : Colors.white,
              fontFamily : 'OpenSans'
            ),
            decoration : InputDecoration(
              border : InputBorder.none,
              contentPadding : EdgeInsets.only(top : 14.0),
              prefixIcon : Icon(
                Icons.card_giftcard,
                color : Colors.white
              ),
              hintText : 'Enter your reward',
              hintStyle : hintTextStyle
            )
          )
        )
      ],
    );
  }
  Widget buildPointTextField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Jumlah Poin',
          style : labelStyle
        ),
        SizedBox(height : 10),
        Container(
          alignment : Alignment.centerLeft,
          decoration : boxDecorationStyle,
          height : 60.0,
          child : TextFormField(
            controller : pointController,
            keyboardType : TextInputType.number,
            style : TextStyle(
              color : Colors.white,
              fontFamily : 'OpenSans'
            ),
            decoration : InputDecoration(
              border : InputBorder.none,
              contentPadding : EdgeInsets.only(top : 14.0),
              prefixIcon : Icon(
                Icons.card_giftcard,
                color : Colors.white
              ),
              hintText : 'Enter your point',
              hintStyle : hintTextStyle
            )
          )
        )
      ],
    );
  }
  @override
  Widget build ( BuildContext context ){
    if(widget.isEdit){
      getRewardsById(widget.id);
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
                      buildPointTextField(),
                      SizedBox(height : 20.0),
                      SizedBox(height : 30.0),
                      isLoading ? CircularProgressIndicator() : 
                      Container(
                        padding : EdgeInsets.symmetric(vertical : 10.0),
                        width : double.infinity,
                        child : RaisedButton(
                          elevation : 5.0,
                          onPressed: () async => {
                            if(rewardController.text.toString().isNotEmpty && pointController.text.toString().isNotEmpty){
                              if(widget.isEdit){
                                updateRewards(rewardController.text.toString() , int.parse(pointController.text.toString()))
                              } else {
                                createRewards(rewardController.text.toString() , int.parse(pointController.text.toString()))
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
                            widget.isEdit ? 'Perbarui Hadiah' : 'Buat Hadiah',
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