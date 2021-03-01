import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:help_desk_app/api/apiurls.dart';
import 'package:help_desk_app/data/sharedpreffunctions.dart';
import 'package:help_desk_app/view/loginui.dart';
import 'package:help_desk_app/view/qrcodepg.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'dart:convert';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  final formatter = DateFormat('MM-dd-yyyy');
  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();
  String url;
  List data;
  String photoPath;
  String userName;
  String phoneNumber;


  void retrieveData() async {
    userName = await HelpFunctions.getStringSharedPref(HelpFunctions.sharedPrefUserFirstName);
    phoneNumber = await HelpFunctions.getStringSharedPref(HelpFunctions.sharedPrefUserContact);
    photoPath = await HelpFunctions.getStringSharedPref(HelpFunctions.sharedPrefUserPhotoPath);
  }

  Future<Null> _selectFromDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedFromDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedFromDate)
      setState(() {
        selectedFromDate = picked;
      });
  }

  Future<Null> _selectToDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedToDate,
        firstDate:DateTime(2015, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedToDate)
      setState(() {
        selectedToDate = picked;
      });
  }

   fetchData() async {
    data = null;
    String deviceId = await HelpFunctions.getStringSharedPref(HelpFunctions.deviceToken);
    print('Device token detection');
    print(deviceId);
    int idValue = await HelpFunctions.getIntSharedPref(HelpFunctions.sharedPrefUserId);
    String startDate = formatter.format(selectedFromDate);
    String endDate = formatter.format(selectedToDate);
    url = ApiUrls.BASEURL+ApiUrls.DASHBOARD+"?FromDate="+startDate+"&ToDate="+endDate+"&UserId="+idValue.toString();
    var result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){
      var response = await http.get(url);
      print(response.body);
      var convertToJson = json.decode(response.body);
      setState(() {
        data = convertToJson['details'];
      });
    }else{
      Toast.show("No Internet Connection", context);
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveData();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    String fromDate = formatter.format(selectedFromDate);
    String toDate = formatter.format(selectedToDate);
    return Scaffold(
        appBar: AppBar(
          title: Text('Grievance Redress'),
          actions: [
            IconButton(icon: Icon(Icons.refresh),onPressed: (){
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DashboardPage()));
            },)
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(userName!=null? userName:'User'),
                accountEmail: Text(phoneNumber!=null ? phoneNumber:'No Contact Found'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      photoPath!=null?photoPath:'https://cdn.pixabay.com/photo/2015/06/19/21/24/the-road-815297__340.jpg'),
                ),
              ),
              ListTile(
                title: Text('Dashboard'),
                leading: Icon(Icons.dashboard),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => DashboardPage()));
                },
              ),
              ListTile(
                title: Text('Logout'),
                leading: Icon(Icons.logout),
                onTap: () {
                  HelpFunctions.insertIntoSharedPreference(HelpFunctions.sharedPrefUserId, null);
                  Navigator.of(context).pop();
                  HelpFunctions.isSplashScreenShowing = true;
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
              ),
            ],
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: GestureDetector(
                              onTap: (){
                                _selectFromDate(context);
                              },
                              child: Center(child: Text(fromDate,style: TextStyle(color: Colors.white),)),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.green,
                              borderRadius: BorderRadius.circular(10)
                            ),
                    ),
                        )),
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: GestureDetector(
                              onTap: (){
                                _selectToDate(context);
                              },
                              child: Center(child: Text(toDate,style: TextStyle(color: Colors.white),)),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                              borderRadius: BorderRadius.circular(10)
                            ),
                    ),
                        )),
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                fetchData();
                              });

                            },
                            child: Container(
                              child: Center(child: Text('Go',style: TextStyle(color:Colors.white),)),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                borderRadius: BorderRadius.circular(10)
                              ),
                    ),
                          ),
                        )),
                  ],
                ),
              ),
              Expanded(
                flex: 9,
              child:(data!=null && data.length>0)?GridView.builder(
                            itemCount: data.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                            itemBuilder:(context,i) {
                              String val = data[i]['colorCode'];
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Color(int.parse("0xFF"+val.substring(1))),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),

                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        Text(data[i]['workingStatus'],
                                          style: TextStyle(color: Colors.white,
                                              fontSize: 23,
                                              fontWeight: FontWeight.bold),),
                                        SizedBox(height: 20,),
                                        Text(data[i]['count'].toString(),
                                          style: TextStyle(color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                                ):Center(child: CircularProgressIndicator(),),
              )
            ],
          ),
        ),
    floatingActionButton: FloatingActionButton(
      onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GrievancePage()));
      },
      backgroundColor: Colors.red,
      child: Icon(Icons.add_rounded,color: Colors.white,),
    ),);
  }
}
