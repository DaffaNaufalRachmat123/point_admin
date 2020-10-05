import 'package:flutter/material.dart';
import 'package:points_admin/Models/Users.dart';
import 'package:points_admin/Screens/AddEditUsersScreen.dart';
import 'package:points_admin/Utils/Constant.dart';
import 'package:points_admin/ViewModels/UsersProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';

class UsersScreen extends StatelessWidget {
  @override
  Widget build ( BuildContext context ){
    return MultiProvider(
      providers : [
        ChangeNotifierProvider(
          builder : ( context ) => UsersProvider()
        )
      ],
      child : HomeScreen()
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState () => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>{
  String token = "";
  @override
  void initState(){
    getToken();
    super.initState();
  }
  void getToken() async {
    var preferences = await SharedPreferences.getInstance();
    setState((){
      token = preferences.getString(Constant.TOKEN);
      print('WOY TOKEN : ' + token);
    });
  }
  @override
  Widget build ( BuildContext context ){
    final provider = Provider.of<UsersProvider>(context);
    if(token.isNotEmpty){
      if(provider.getUsersList == null){
        print("TOKEN DAF : " + token);
        provider.getAllUsersList(token);
      }
    }
    return Scaffold(
      appBar : AppBar(
        title : Text('Manajemen User')
      ),
      body : Container(
        width : double.infinity,
        height : double.infinity,
        child : provider.getFetching ? Center(
                child : CircularProgressIndicator()
              ) : provider.getUsersList.length > 0 ? 
              UsersList() : Center(child : Text('Tidak Ada Data'))
      ),
      floatingActionButton : FloatingActionButton(
        onPressed : () async {
          var result = await Navigator.push(context , MaterialPageRoute(
            builder : ( context ) => AddEditUsersScreen(isEdit : false , id : 0)
          ));
          if(result != null){
            if(result["status_code"] == 200){
              final provider = Provider.of<UsersProvider>(context);
              Users users = new Users();
              users.id = result['id'] as int;
              users.username = result['username'] as String;
              users.email = result['email'] as String;
              users.password = result['password'] as String;
              users.transactions_count = result['transactions_count'] as int;
              users.users_point = result['users_point'] as int;
              users.is_user_admin = result['is_user_admin'] as String;
              provider.addNewUser(users);
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

class UsersList extends StatelessWidget {
  Future<void> removeUsers(int id , int index , BuildContext context) async {
    final provider = Provider.of<UsersProvider>(context);
    var pref = await SharedPreferences.getInstance();
    String token = pref.getString(Constant.TOKEN);
    var responses = await provider.removeUsers(token , id);
    if(responses != null){
      provider.deleteUsers(index);
    } else {
      SweetAlert.show(context , title : 'Perhatian !' , subtitle : 'Gagal Menghapus Data' , style : SweetAlertStyle.error);
    }
  }
  @override
  Widget build ( BuildContext context ){
    return Consumer<UsersProvider>(
      builder : ( context , provider , child ){
        final prov = Provider.of<UsersProvider>(context);
        return Column(
          children: <Widget>[
            Container(
              child : ListView.builder(
                itemCount : provider.getUsersList.length,
                shrinkWrap : true,
                physics : NeverScrollableScrollPhysics(),
                itemBuilder : ( context , int index ){
                  var data = provider.getUsersList[index];
                  return GestureDetector(
                    onTap : () async {
                      var result = await Navigator.push(context , MaterialPageRoute(
                        builder : ( context ) => AddEditUsersScreen(isEdit : true , id : data.id)
                      ));
                      if(result != null){
                        print(result);
                        Users users = new Users();                     
                        users.username = result['username'];
                        users.email = result['email'];
                        users.is_user_admin = result['is_user_admin'];
                        prov.changeUpdate(users , index);
                      }
                    },
                    child : Container(
                      margin : EdgeInsets.all(10.0),
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
                              child : Text(data.username.substring(0 , 2).toUpperCase() , style : TextStyle(
                                color : Colors.white,
                                fontFamily : 'OpenSans',
                                fontSize : 22.0
                              ))
                            )
                          ),
                          Column(
                            crossAxisAlignment : CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(data.username , style : TextStyle(
                                color : Colors.black,
                                fontSize : 19.0,
                                fontWeight : FontWeight.bold,
                                fontFamily : 'OpenSans'
                              )),
                              Row(
                                mainAxisAlignment : MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.star,
                                    size : 20.0,
                                    color : Colors.yellow
                                  ),
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
                                          removeUsers(data.id , index , context);
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