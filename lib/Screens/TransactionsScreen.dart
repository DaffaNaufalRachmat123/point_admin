import 'package:flutter/material.dart';
import 'package:points_admin/Models/Transactions.dart';
import 'package:points_admin/Screens/AddEditTransactionsScreen.dart';
import 'package:points_admin/Utils/Constant.dart';
import 'package:points_admin/ViewModels/TransactionsProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';

class TransactionsScreen extends StatelessWidget {
  @override
  Widget build ( BuildContext context ){
    return MultiProvider(
      providers : [
        ChangeNotifierProvider(
          builder : ( context ) => TransactionsProvider()
        )
      ],
      child : TransactionsScreens()
    );
  }
}

class TransactionsScreens extends StatefulWidget {
  @override
  TransactionsScreenState createState () => TransactionsScreenState();
}

class TransactionsScreenState extends State<TransactionsScreens>{
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
    final provider = Provider.of<TransactionsProvider>(context);
    if(token.isNotEmpty){
      if(provider.getTransactionsList== null){
        print("TOKEN DAF : " + token);
        provider.getAllTransactionsList(token);
      }
    }
    return Scaffold(
      appBar : AppBar(
        title : Text('Manajemen Transaksi')
      ),
      body : Container(
        width : double.infinity,
        height : double.infinity,
        child : provider.getFetching ? Center(
                child : CircularProgressIndicator()
              ) : provider.getTransactionsList.length > 0 ? 
              TransactionsList() : Center(child : Text('Tidak Ada Data'))
      ),
      floatingActionButton : FloatingActionButton(
        onPressed : () async {
          var result = await Navigator.push(context , MaterialPageRoute(
            builder : ( context ) => AddEditTransactionsScreen(isEdit : false , id : 0)
          ));
          if(result != null){
            if(result["status_code"] == 200){
              final provider = Provider.of<TransactionsProvider>(context);
              Transactions transactions = new Transactions();
              transactions.id = result['id'];
              transactions.users_id = result['users_id'];
              transactions.transaction_id = result['transaction_id'];
              transactions.product_name = result['product_name'];
              transactions.product_total_count = result['product_total_count'];
              transactions.product_price = result['product_price'];
              transactions.product_total_price = result['product_total_price'];
              transactions.transaction_point = result['transaction_point'];
              provider.addNewTransactions(transactions);
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

class TransactionsList extends StatelessWidget {
  Future<void> removeTransactions(int id , int index , BuildContext context) async {
    final provider = Provider.of<TransactionsProvider>(context);
    var pref = await SharedPreferences.getInstance();
    String token = pref.getString(Constant.TOKEN);
    var response = provider.deleteTransactions(token , id);
    if(response != null){
      provider.removeTransactions(index);
      SweetAlert.show(context , title : 'Status' , subtitle : 'Berhasil Menghapus Data' , style : SweetAlertStyle.success);
    } else {
      SweetAlert.show(context , title : 'Perhatian !' , subtitle : 'Gagal Menghapus Data' , style : SweetAlertStyle.error);
    }
  }
  @override
  Widget build ( BuildContext context ){
    return Consumer<TransactionsProvider>(
      builder : ( context , provider , child ){
        final prov = Provider.of<TransactionsProvider>(context);
        return Column(
          children: <Widget>[
            Container(
              child : ListView.builder(
                itemCount : provider.getTransactionsList.length,
                shrinkWrap : true,
                physics : NeverScrollableScrollPhysics(),
                itemBuilder : ( context , int index ){
                  var data = provider.getTransactionsList[index];
                  return GestureDetector(
                    onTap : () async {
                      var result = await Navigator.push(context , MaterialPageRoute(
                        builder : ( context ) => AddEditTransactionsScreen(isEdit : true , id : data.id)
                      ));
                      if(result != null){
                        print(result);
                        Transactions transactions = new Transactions();
                        transactions.product_name = result['product_name'];
                        transactions.product_total_count = result['product_total_count'];
                        transactions.product_price = result['product_price'];
                        transactions.product_total_price = result['product_total_price'];
                        provider.changeUpdate(transactions , index);
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
                              child : Text(data.product_name.substring(0 , 2).toUpperCase() , style : TextStyle(
                                color : Colors.white,
                                fontFamily : 'OpenSans',
                                fontSize : 22.0
                              ))
                            )
                          ),
                          Column(
                            crossAxisAlignment : CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(data.product_name , style : TextStyle(
                                color : Colors.black,
                                fontSize : 19.0,
                                fontWeight : FontWeight.bold,
                                fontFamily : 'OpenSans'
                              )),
                              Row(
                                mainAxisAlignment : MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(
                                    Icons.attach_money,
                                    size : 20.0,
                                    color : Colors.green
                                  ),
                                  SizedBox(width : 5.0),
                                  Text(data.product_total_price.toString() , style : TextStyle(
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
                                          removeTransactions(data.id , index , context);
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