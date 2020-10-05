import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:points_admin/Models/Transactions.dart';
import 'package:points_admin/Models/Users.dart';
import 'package:points_admin/Utils/Constant.dart';
import 'package:points_admin/ViewModels/TransactionsProvider.dart';
import 'package:provider/provider.dart';
import 'package:points_admin/Utils/StyleDecoration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';


class AddEditTransactionsScreen extends StatelessWidget {
  bool isEdit = false;
  int id = 0;
  AddEditTransactionsScreen({Key key , this.isEdit , this.id}) : super(key : key);
  @override
  Widget build ( BuildContext context ){
    return Scaffold(
      appBar : AppBar(
        title : Text(isEdit ? 'Ubah Transaksi' : 'Tambah Transaksi')
      ),
      body : MultiProvider(
        providers : [
          ChangeNotifierProvider(
            builder : ( context ) => TransactionsProvider()
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
  final userController = TextEditingController();
  final productNameController = TextEditingController();
  final productTotalCountController = TextEditingController();
  final productPriceController = TextEditingController();
  final productTotalPriceController = TextEditingController();
  List<Users> usersList = new List<Users>();
  String token = "";
  String selectedItems;
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
  Future<void> createTransaction() async {
    final provider = Provider.of<TransactionsProvider>(context);
    if(widget.isEdit){
      if(productNameController.text.isNotEmpty && 
        productTotalCountController.text.isNotEmpty && 
        productPriceController.text.isNotEmpty && 
        productTotalPriceController.text.isNotEmpty){
        updateTransactions(widget.id, productNameController.text, int.parse(productTotalCountController.text), int.parse(productPriceController.text), int.parse(productTotalPriceController.text));
      } else {
        SweetAlert.show(context , title : 'Perhatian !' , subtitle : 'Harap Lengkapi Semua Kolom' , style : SweetAlertStyle.confirm);
      }
    } else {
      if(selectedItems != null && productNameController.text.isNotEmpty && 
        productTotalCountController.text.isNotEmpty && 
        productPriceController.text.isNotEmpty && 
        productTotalPriceController.text.isNotEmpty){
        for(int i = 0; i < provider.getUsersList.length; i++){
          if(provider.getUsersList[i].username == selectedItems){
            createTransactions(provider.getUsersList[i].id , 
              productNameController.text,
              int.parse(productTotalCountController.text),
              int.parse(productPriceController.text),
              int.parse(productTotalPriceController.text));
            break;
          }
        }
      } else {
        SweetAlert.show(context , title : 'Perhatian !' , subtitle : 'Harap Lengkapi Semua Kolom' , style : SweetAlertStyle.confirm);
      }
    }
  }
  Future<void> createTransactions(int users_id , String product_name , int product_total_count , int product_price , int product_total_price) async {
    final provider = Provider.of<TransactionsProvider>(context);
    var preferences = await SharedPreferences.getInstance();
    String token = preferences.getString(Constant.TOKEN);
    Transactions transactions = new Transactions();
    transactions.users_id = users_id;
    transactions.product_name = product_name;
    transactions.product_total_count = product_total_count;
    transactions.product_price = product_price;
    transactions.product_total_price = product_total_price;
    transactions.transaction_point = 5;
    var responses = await provider.createTransactions(token , transactions);
    print(responses);
    if(responses["server_message"].toString().toLowerCase().contains("created")){
      Map<String , dynamic> callback = responses["callback"];
      Map response = {
        "status_code" : 200,
        "id" : callback["id"] as int,
        "transaction_id" : callback["transaction_id"] as String,
        "users_id" : callback["users_id"] as int,
        "product_name" : callback["product_name"] as String,
        "product_total_count" : callback["product_total_count"] as int,
        "product_price" : callback["product_price"] as int,
        "product_total_price" : callback["product_total_price"] as int,
        "transaction_point" : callback["transaction_point"]
      };
      Navigator.pop(context , response);
    } else {
      SweetAlert.show(context , title : "Attention" , subtitle : "Gagal Menambahkan Hadiah");
    }
  }
  Future<void> getTransactionById(int id) async {
    final provider = Provider.of<TransactionsProvider>(context);
    var preferences = await SharedPreferences.getInstance();
    String token = preferences.getString(Constant.TOKEN);
    var response = await provider.getTransactionsById(id , token);
    if(response != null){
      var decode = json.decode(response);
      print(decode);
      if(provider.getUsersList != null){
        for(int i = 0; i < provider.getUsersList.length; i++){
          if(provider.getUsersList[i].id == decode['users_id']){
            userController.text = provider.getUsersList[i].username;
            break;
          }
        }
        productNameController.text = decode['product_name'];
        productTotalCountController.text = decode['product_total_count'].toString();
        productPriceController.text = decode['product_price'].toString();
        productTotalPriceController.text = decode['product_total_price'].toString();
      }
    } 
  }
  Future<void> updateTransactions(int id , String product_name , int product_total_count , int product_price , int product_total_price) async {
    final provider = Provider.of<TransactionsProvider>(context);
    var preferences = await SharedPreferences.getInstance();
    String token = preferences.getString(Constant.TOKEN);
    Transactions transactions = new Transactions();
    transactions.id = id;
    transactions.product_name = product_name;
    transactions.product_total_count = product_total_count;
    transactions.product_price = product_price;
    transactions.product_total_price = product_total_price;
    var responses = await provider.updateTransactions(token , transactions);
    print(responses);
    if(responses != null){
      if(responses["server_message"].toString().toLowerCase().contains("updated")){
        Map response = {
          "status_code" : 200,
          "id" : widget.id,
          "product_name" : productNameController.text,
          "product_total_count" : int.parse(productTotalCountController.text),
          "product_price" : int.parse(productPriceController.text),
          "product_total_price" : int.parse(productTotalPriceController.text)
        };
        Navigator.pop(context , response);
      } else {
        SweetAlert.show(context , title : 'Perhatian !' , subtitle : 'Gagal Memperbarui Data' , style : SweetAlertStyle.error);
      }
    } else {
        SweetAlert.show(context , title : 'Perhatian !' , subtitle : 'Gagal Memperbarui Data' , style : SweetAlertStyle.error);
    }
  }
  Widget buildUserTextField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'User',
          style : labelStyle
        ),
        SizedBox(height : 10),
        Container(
          alignment : Alignment.centerLeft,
          decoration : boxDecorationStyle,
          height : 60.0,
          child : TextFormField(
            readOnly: true,
            controller : userController,
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
              hintStyle : hintTextStyle
            )
          )
        )
      ],
    );
  }
  Widget buildProductTextField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Product Name',
          style : labelStyle
        ),
        SizedBox(height : 10),
        Container(
          alignment : Alignment.centerLeft,
          decoration : boxDecorationStyle,
          height : 60.0,
          child : TextFormField(
            controller : productNameController,
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
              hintText : 'Enter your product name',
              hintStyle : hintTextStyle
            )
          )
        )
      ],
    );
  }
  Widget buildProductCountTextField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Jumlah Produk',
          style : labelStyle
        ),
        SizedBox(height : 10),
        Container(
          alignment : Alignment.centerLeft,
          decoration : boxDecorationStyle,
          height : 60.0,
          child : TextFormField(
            controller : productTotalCountController,
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
              hintText : 'Enter your total product',
              hintStyle : hintTextStyle
            )
          )
        )
      ],
    );
  }
  Widget buildProductPriceTextField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Harga Produk',
          style : labelStyle
        ),
        SizedBox(height : 10),
        Container(
          alignment : Alignment.centerLeft,
          decoration : boxDecorationStyle,
          height : 60.0,
          child : TextFormField(
            controller : productPriceController,
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
              hintText : 'Enter your price',
              hintStyle : hintTextStyle
            )
          )
        )
      ],
    );
  }
  Widget buildProductTotalPriceTextField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Total Harga',
          style : labelStyle
        ),
        SizedBox(height : 10),
        Container(
          alignment : Alignment.centerLeft,
          decoration : boxDecorationStyle,
          height : 60.0,
          child : TextFormField(
            controller : productTotalPriceController,
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
              hintText : 'Enter your total price',
              hintStyle : hintTextStyle
            )
          )
        )
      ],
    );
  }
  
  @override
  Widget build ( BuildContext context ){
    final provider = Provider.of<TransactionsProvider>(context);
    if(token.isNotEmpty){
      if(provider.getUsersList == null){
        provider.getAllUsersList(token);
      }
    }
    if(widget.isEdit){
      getTransactionById(widget.id);
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Pilih User',
                            style : labelStyle
                          ),
                        ],
                      ),
                      SizedBox(height : 20.0),
                      widget.isEdit ? buildUserTextField() : 
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
                            hint : Text('Silahkan pilih user'),
                            items : provider.dropdownUserList.map((value){
                              return DropdownMenuItem(
                                value : value,
                                child : Text(value , style : TextStyle(
                                  color : Colors.black,
                                  fontFamily : 'OpenSans'
                                )), 
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
                      buildProductTextField(),
                      SizedBox(height : 20.0),
                      buildProductCountTextField(),
                      SizedBox(height : 20.0),
                      buildProductPriceTextField(),
                      SizedBox(height : 20.0),
                      buildProductTotalPriceTextField(),
                      SizedBox(height : 30.0),
                      isLoading ? CircularProgressIndicator() : 
                      Container(
                        padding : EdgeInsets.symmetric(vertical : 10.0),
                        width : double.infinity,
                        child : RaisedButton(
                          elevation : 5.0,
                          onPressed: () async => {
                            createTransaction()
                          },
                          padding : EdgeInsets.all(15.0),
                          shape : RoundedRectangleBorder(
                            borderRadius : BorderRadius.circular(30.0)
                          ),
                          color : Colors.white,
                          child : Text(
                            widget.isEdit ? 'Perbarui Transaksi' : 'Buat Transaksi',
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