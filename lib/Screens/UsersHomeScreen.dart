import 'package:flutter/material.dart';
import 'package:points_admin/Screens/UsersPointScreen.dart';
import 'package:points_admin/Screens/UsersRewardsScreen.dart';

class UsersHomeScreen extends StatefulWidget {
  @override
  UsersHomeScreenState createState () => UsersHomeScreenState();
}

class UsersHomeScreenState extends State<UsersHomeScreen>{
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    UsersPointScreen(),
    UsersRewardsScreen(),
  ];
  @override
  Widget build ( BuildContext context ){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page User'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.star , color : Colors.yellow),
            title : Text("Poin")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard , color : Colors.green),
            title : Text("Daftar Hadiah")
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}