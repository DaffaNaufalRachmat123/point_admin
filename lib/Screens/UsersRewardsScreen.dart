import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:points_admin/Utils/Constant.dart';
import 'package:points_admin/ViewModels/UsersPointProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersRewardsScreen extends StatelessWidget {
  @override
  Widget build ( BuildContext context ){
    return MultiProvider(
      providers : [
        ChangeNotifierProvider(
          builder : ( context ) => UsersPointProvider()
        )
      ],
      child : UsersRewardsScreens()
    );
  }
}

class UsersRewardsScreens extends StatefulWidget {
  @override
  UsersRewardsScreenState createState () => UsersRewardsScreenState();
}

class UsersRewardsScreenState extends State<UsersRewardsScreens>{
  String token = "";
  int id = 0;
  @override
  void initState(){
    getTokenAndId();
    super.initState();
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
  @override
  Widget build ( BuildContext context){
    final provider = Provider.of<UsersPointProvider>(context);
    if(token.isNotEmpty && id != 0){
      if(provider.getRewardsList == null){
        provider.getAllRewardsList(token, id);
      }
    }
    return Scaffold(
      body : Container(
        width : double.infinity,
        height : double.infinity,
        child : provider.getFetching ? Center(
                child : CircularProgressIndicator()
              ) : provider.getRewardsList == null ? Center(child : Text('Tidak Ada Data')) : provider.getRewardsList.length > 0 ? 
              RewardsList() : Center(child : Text('Tidak Ada Data'))
      ),
    );
  }
}
class RewardsList extends StatelessWidget {
  @override
  Widget build ( BuildContext context ){
    return Consumer<UsersPointProvider>(
      builder : ( context , provider , child ){
        return Column(
          children: <Widget>[
            Container(
              child : ListView.builder(
                itemCount : provider.getRewardsList.length,
                shrinkWrap : true,
                physics : NeverScrollableScrollPhysics(),
                itemBuilder : ( context , int index ){
                  var data = provider.getRewardsList[index];
                  return GestureDetector(
                    child : Container(
                      margin : EdgeInsets.all(10.0),
                      width : MediaQuery.of(context).size.width,
                      decoration : BoxDecoration(
                        color : Colors.white,
                        borderRadius : BorderRadius.circular(10.0),
                        boxShadow : [
                          BoxShadow(
                            blurRadius : 6.0,
                            color : Colors.black26,
                            offset : Offset( 0 ,2)
                          )
                        ]
                      ),
                      child : Row(
                        children: <Widget>[
                          Container(
                            width : 70,
                            height : 70,
                            margin : EdgeInsets.all(8.0),
                            decoration : BoxDecoration(
                              color : Colors.blue,
                              borderRadius : BorderRadius.circular(200)
                            ),
                            child : Center(
                              child : Text(data.rewards.substring(0 , 2).toUpperCase() , style : TextStyle(
                                color : Colors.white,
                                fontFamily : 'OpenSans',
                                fontSize : 22.0
                              ))
                            )
                          ),
                          Column(
                            crossAxisAlignment : CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(data.rewards , style : TextStyle(
                                color : Colors.black,
                                fontSize : 19.0,
                                fontWeight : FontWeight.bold,
                                fontFamily : 'OpenSans'
                              )),
                              Row(
                                mainAxisAlignment : MainAxisAlignment.start,
                                children: <Widget>[
                                  Text('Poin : ' , style : TextStyle(
                                    color : Colors.amber,
                                    fontFamily: 'OpenSans',
                                    fontSize : 15.0
                                  )),
                                  SizedBox(width : 5.0),
                                  Text(data.users_point.toString() , style : TextStyle(
                                    color : Colors.black,
                                    fontFamily : 'OpenSans',
                                    fontSize : 15.0
                                  ))
                                ],
                              )
                            ],
                          ),
                          Expanded(
                            child : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                GestureDetector(
                                  onTap : () async {
                                  },
                                  child : Icon(
                                    Icons.delete,
                                    size : 25.0,
                                    color : Colors.red
                                  )
                                ),
                                SizedBox(width : 10.0)
                              ],
                            )
                          )
                        ],
                      )
                    )
                  );
                }
              )
            )
          ],
        );
      }
    );
  }
}