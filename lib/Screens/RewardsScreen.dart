import 'package:flutter/material.dart';
import 'package:points_admin/Models/Rewards.dart';
import 'package:points_admin/Screens/AddEditRewardsScreen.dart';
import 'package:points_admin/Utils/Constant.dart';
import 'package:points_admin/ViewModels/RewardsProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';

class RewardsScreen extends StatelessWidget {
  @override
  Widget build ( BuildContext context ){
    return MultiProvider(
      providers : [
        ChangeNotifierProvider(
          builder : ( context ) => RewardsProvider()
        )
      ],
      child : RewardsScreens()
    );
  }
}

class RewardsScreens extends StatefulWidget {
  @override
  RewardsScreenState createState () => RewardsScreenState();
}

class RewardsScreenState extends State<RewardsScreens>{
  String token = "";
  void getToken() async {
    var preferences = await SharedPreferences.getInstance();
    setState((){
      token = preferences.getString(Constant.TOKEN);
    });
  }
  @override
  void initState(){
    getToken();
    super.initState();
  }
  @override
  Widget build ( BuildContext context ){
    final provider = Provider.of<RewardsProvider>(context);
    if(token.isNotEmpty){
      if(provider.getRewardsList == null){
        provider.getAllRewardsList(token);
      }
    }
    return Scaffold(
      appBar : AppBar(
        title : Text('Manajemen Hadiah')
      ),
      body : Container(
        width : double.infinity,
        height : double.infinity,
        child : provider.getFetching ? Center(
                child : CircularProgressIndicator()
              ) : provider.getRewardsList.length > 0 ? 
              RewardsList() : Center(child : Text('Tidak Ada Data'))
      ),
      floatingActionButton : FloatingActionButton(
        onPressed : () async {
          var result = await Navigator.push(context , MaterialPageRoute(
            builder : ( context ) => AddEditRewardsScreen(isEdit : false , id : 0)
          ));
          if(result != null){
            if(result["status_code"] == 200){
              final provider = Provider.of<RewardsProvider>(context);
              Rewards rewards = new Rewards();
              rewards.id = result['id'];
              rewards.rewards = result['rewards'];
              rewards.users_point = result['users_point'];
              provider.addNewRewards(rewards);
            } 
          }//
        },
        child : Icon(
          Icons.add,
          color : Colors.white
        )
      )
    );
  }
}

class RewardsList extends StatelessWidget {
  Future<void> deleteRewards(int id , int index , BuildContext context) async {
    final provider = Provider.of<RewardsProvider>(context);
    var preferences = await SharedPreferences.getInstance();
    var token = preferences.getString(Constant.TOKEN);
    var response = await provider.deleteRewards(token , id);
    if(response != null){
      provider.removeRewards(index);
      SweetAlert.show(context , title: 'Status' , subtitle: 'Berhasil Menghapus Data' , style : SweetAlertStyle.success);
    } else {
      SweetAlert.show(context , title : 'Perhatian' , subtitle : 'Gagal Meghapus Data' , style : SweetAlertStyle.error);
    }
  }
  @override
  Widget build ( BuildContext context ){
    return Consumer<RewardsProvider>(
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
                    onTap : () async {
                      var result = await Navigator.push(context , MaterialPageRoute(
                        builder : ( context ) => AddEditRewardsScreen(isEdit : true , id : data.id)
                      ));
                      if(result != null){
                        if(result["status_code"] == 200){
                          final prov = Provider.of<RewardsProvider>(context);
                          Rewards rewards = new Rewards();
                          rewards.id = result['id'] as int;
                          rewards.rewards = result['rewards'] as String;
                          rewards.users_point = result['users_point'] as int;
                          prov.changeUpdate(rewards , index);
                        }
                      }
                    },
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
                                    SweetAlert.show(context , title : 'Perhatian' , subtitle : 'Yakin ingin menghapus item ini?' , style : SweetAlertStyle.confirm,
                                      showCancelButton : true , onPress : (bool isConfirm){
                                        if(isConfirm){
                                          deleteRewards(data.id , index , context);
                                          return true;
                                        }
                                      });
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