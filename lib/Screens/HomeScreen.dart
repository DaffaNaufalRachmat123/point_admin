import 'package:flutter/material.dart';
import 'package:points_admin/Screens/LoginScreen.dart';
import 'package:points_admin/Screens/RewardsScreen.dart';
import 'package:points_admin/Screens/TransactionsScreen.dart';
import 'package:points_admin/Screens/UsersScreen.dart';
import 'package:points_admin/ViewModels/RewardsProvider.dart';
import 'package:points_admin/ViewModels/TransactionsProvider.dart';
import 'package:points_admin/ViewModels/UsersProvider.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build ( BuildContext context ){
    return Scaffold(
      appBar : AppBar(
        backgroundColor : Colors.blueGrey,
        title : Text('Point Admin')
      ),
      body : MultiProvider(
        providers : [
          ChangeNotifierProvider(
            builder : ( context ) => UsersProvider()
          ),
          ChangeNotifierProvider(
            builder : ( context ) => TransactionsProvider()
          ),
          ChangeNotifierProvider(
            builder : ( context ) => RewardsProvider()
          )
        ],
        child : HomeScreens()
      )
    );
  }
}

class HomeScreens extends StatefulWidget {
  @override
  HomeScreenState createState () => HomeScreenState();
}

class HomeScreenState extends State<HomeScreens> {
  List<LineChartBarData> linesBarData1() {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: [
        FlSpot(1, 1),
        FlSpot(3, 1.5),
        FlSpot(5, 1.4),
        FlSpot(7, 3.4),
        FlSpot(10, 2),
        FlSpot(12, 2.2),
        FlSpot(13, 1.8),
        FlSpot(14 , 1.9)
      ],
      isCurved: true,
      colors: [
        const Color(0xff4af699),
      ],
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarData1
    ];
  }
  LineChartData sampleData1() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'SEPT';
              case 7:
                return 'OCT';
              case 12:
                return 'DEC';
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '1m';
              case 2:
                return '2m';
              case 3:
                return '3m';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: 14,
      maxY: 4,
      minY: 0,
      lineBarsData: linesBarData1(),
    );
  }
  @override
  Widget build ( BuildContext context ){
    return SingleChildScrollView(
      child : SafeArea(
        child : Column(
          children: <Widget>[
            ResponsiveGridRow(
              children : [
                ResponsiveGridCol(
                  lg : 12,
                  child : GestureDetector(
                    onTap: (){
                      Navigator.push(context , MaterialPageRoute(
                        builder : ( context ) => UsersScreen()
                      ));
                    },
                    child : Container(
                      height : 150,
                      alignment : Alignment(0 , 0),
                      margin : EdgeInsets.all(10.0),
                      decoration : BoxDecoration(
                        color : Colors.white,
                        borderRadius : BorderRadius.circular(10.0),
                        boxShadow : [
                          BoxShadow(
                            color : Colors.black12,
                            blurRadius : 5.0,
                            offset : Offset( 0 , 2)
                          )
                        ]
                      ),
                      child : Expanded(
                        child : Row(
                          mainAxisAlignment : MainAxisAlignment.start,
                          crossAxisAlignment : CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width : 10.0),
                            Container(
                              height : 100.0,
                              child : Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.person_pin,
                                    color : Colors.blue,
                                    size : 100.0
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text('Manajemen User' , style : TextStyle(
                                        color : Colors.black,
                                        fontWeight : FontWeight.bold,
                                        fontSize : 22.0,
                                        fontFamily : 'OpenSans'
                                      )),
                                    ],
                                  )
                                ],
                              )
                            )
                          ],
                        )
                      )
                    ),
                  )
                ),
                ResponsiveGridCol(
                  xs : 6,
                  md : 3,
                  child : GestureDetector(
                    onTap : () {
                      Navigator.push(context , MaterialPageRoute(
                        builder : ( context ) => TransactionsScreen()
                      ));
                    },
                    child : Container(
                      height : 150,
                      margin : EdgeInsets.only(left : 10.0 , bottom : 10.0 , right : 5.0),
                      alignment: Alignment(0 , 0),
                      decoration : BoxDecoration(
                        color : Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow : [
                          BoxShadow(
                            blurRadius : 5.0,
                            color : Colors.black12,
                            offset : Offset( 0 , 2)
                          )
                        ]
                      ),//
                      child : Expanded(
                        child : Column(
                          crossAxisAlignment : CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height : 20.0),
                            Icon(
                              Icons.monetization_on,
                              size : 60.0,
                              color : Colors.blue
                            ),
                            Text('Transaksi' , style : TextStyle(
                              color : Colors.black,
                              fontSize : 22.0,
                              fontWeight : FontWeight.bold,
                              fontFamily: 'OpenSans'
                            )),
                          ],
                        )
                      )
                    )
                  )
                ),
                ResponsiveGridCol(
                  xs : 6,
                  md : 3,
                  child : GestureDetector(
                    onTap : () {
                      Navigator.push(context , MaterialPageRoute(
                        builder : ( context ) => RewardsScreen()
                      ));
                    },
                    child : Container(
                      alignment : Alignment( 0 , 0 ),
                      height : 150,
                      margin : EdgeInsets.only(left : 5.0 , bottom : 10.0 , right : 10.0),
                      decoration : BoxDecoration(
                        color : Colors.white,
                        borderRadius : BorderRadius.circular(10.0),
                        boxShadow : [
                          BoxShadow(
                            blurRadius : 5.0,
                            color : Colors.black12,
                            offset : Offset( 0 , 2)
                          )
                        ]
                      ),
                      child : Expanded(
                        child : Column(
                          crossAxisAlignment : CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height : 20.0),
                            Icon(
                              Icons.card_giftcard,
                              size : 60.0,
                              color : Colors.blue
                            ),
                            Text('Hadiah' , style : TextStyle(
                              color : Colors.black,
                              fontSize : 22.0,
                              fontWeight : FontWeight.bold,
                              fontFamily: 'OpenSans'
                            )),
                          ],
                        )
                      )
                    )
                  )
                ),
                ResponsiveGridCol(
                  lg : 12,
                  child : GestureDetector(
                    onTap : () async {
                      var preferences = await SharedPreferences.getInstance();
                      preferences.clear();
                      Navigator.pushAndRemoveUntil(context , MaterialPageRoute(
                        builder : ( context ) => LoginScreen()
                      ) , (Route<dynamic> routes) => false);
                    },
                    child : Container(
                      alignment : Alignment( 0 , 0),
                      height : 150.0,
                      margin : EdgeInsets.only(top : 10.0 , left : 10.0 , right : 10.0 , bottom : 10.0),
                      decoration : BoxDecoration(
                        color : Colors.red,
                        borderRadius : BorderRadius.circular(10.0),
                        boxShadow : [
                          BoxShadow(
                            blurRadius : 5.0,
                            color : Colors.black12,
                            offset : Offset( 0 , 2)
                          )
                        ]
                      ),
                      child : Center(
                        child : Row(
                          mainAxisAlignment : MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.arrow_forward,
                              size : 60.0,
                              color : Colors.white
                            ),
                            SizedBox(width : 10.0),
                            Text('Keluar' , style : TextStyle(
                              color : Colors.white,
                              fontSize : 24.0,
                              fontWeight : FontWeight.bold,
                              fontFamily: 'OpenSans'
                            ))
                          ],
                        )
                      )
                    )
                  )
                )
              ]
            )
          ],
        )
      )
    );
  }
}