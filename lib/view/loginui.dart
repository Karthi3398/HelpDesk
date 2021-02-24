import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:help_desk_app/Animation/FadeAnimation.dart';
import 'package:help_desk_app/api/apiurls.dart';
import 'package:help_desk_app/data/sharedpreffunctions.dart';
import 'package:help_desk_app/view/dashboardpg.dart';
import 'package:help_desk_app/view/splashscreenpg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _passwordVisible;
  SharedPreferences sharedPreferences;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isAlreadyLoggedIn;
  int userId;

  @override
  void initState() {
    // TODO: implement initState
    _passwordVisible = false;
    super.initState();
    getLoggedInInfo();
  }
  @override
  Widget build(BuildContext context) {
    return userId!=null ?
    DashboardPage():Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Color(0xff21254A),
        body: SafeArea(
          child: Container(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 200,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                            child: FadeAnimation(
                              1,
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage("assets/1.png"),
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeAnimation(
                          1,
                          Text(
                            "Grievance Redress, \nwelcome back",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        FadeAnimation(
                          1.5,
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.transparent,
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: TextField(
                                    controller: emailController,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 1)),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide:
                                        BorderSide(color: Colors.white, width: 1),
                                      ),
                                      hintText: "User ID",
                                      hintStyle: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  child: TextField(
                                    controller: passwordController,
                                    style: TextStyle(color: Colors.white),
                                    obscureText: !_passwordVisible,
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide:
                                          BorderSide(color: Colors.white, width: 1),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _passwordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Colors.white,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _passwordVisible = !_passwordVisible;
                                            });
                                          },
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide:
                                          BorderSide(color: Colors.white, width: 1),
                                        ),
                                        hintText: "Password",
                                        hintStyle: TextStyle(color: Colors.white)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        FadeAnimation(
                          1,
                          GestureDetector(
                            onTap: () async {
                              print('DATA');
                              String deviceId = await PlatformDeviceId.getDeviceId;
                              print(deviceId);
                              final String url = ApiUrls.BASEURL+ApiUrls.LOGIN;
                              final response = await http.post(url,body: {
                                "user":emailController.text.trim(),
                                "password":passwordController.text.trim(),
                                "sessionaccess":"0",
                                "devicetype":"1",
                                "devicetoken":"54a5b2be-74fe-45eb-a9b3-98ef166043dc"
                              });
                              if(response.statusCode == 200){
                                print(response.body);
                                final body = json.decode(response.body);
                                saveAll(body);
                                Toast.show(body['message'], context);
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DashboardPage()));
                              }else{
                                final body = json.decode(response.body);
                                Toast.show(body['message'], context);
                              }
                            },
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 60),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(color: Color(0xff21254A),fontWeight: FontWeight.bold,fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  )
                ],
              )
          ),
        )
    );
  }
    getLoggedInInfo() async {
    int id = await HelpFunctions.getIntSharedPref(HelpFunctions.sharedPrefUserId);
    setState((){
      userId = id;
    });
    }

    saveAll(body){
    HelpFunctions.insertIntoSharedPreference(HelpFunctions.sharedPrefUserId,body['details']['userId']);
    HelpFunctions.saveIntoSharedPreference(HelpFunctions.sharedPrefUserKey, body['details']['userKey']);
    HelpFunctions.insertIntoSharedPreference(HelpFunctions.sharedPrefFacilityId,body['details']['facilityId']);
    HelpFunctions.saveIntoSharedPreference(HelpFunctions.sharedPrefUserFirstName, body['details']['userFirstName']);
    HelpFunctions.saveIntoSharedPreference(HelpFunctions.sharedPrefUserMiddleName, body['details']['userMiddleName']);
    HelpFunctions.saveIntoSharedPreference(HelpFunctions.sharedPrefUserLastName, body['details']['userLastName']);
    HelpFunctions.saveIntoSharedPreference(HelpFunctions.sharedPrefUserAddress, body['details']['userAddress']);
    HelpFunctions.saveIntoSharedPreference(HelpFunctions.sharedPrefUserMailId, body['details']['userMailId']);
    HelpFunctions.saveIntoSharedPreference(HelpFunctions.sharedPrefUserContact, body['details']['userContact']);
    HelpFunctions.saveIntoSharedPreference(HelpFunctions.sharedPrefUserPhotoPath, body['details']['userPhotoPath']);
    HelpFunctions.insertIntoSharedPreference(HelpFunctions.sharedPrefClientRoleId,body['details']['clientRoleId']);
    HelpFunctions.insertIntoSharedPreference(HelpFunctions.sharedPrefIsTechnician,body['details']['isTechnician']);
    HelpFunctions.insertIntoSharedPreference(HelpFunctions.sharedPrefIsSuperAdmin,body['details']['isSuperAdmin']);
    HelpFunctions.insertIntoSharedPreference(HelpFunctions.sharedPrefIsAdmin,body['details']['isAdmin']);
    HelpFunctions.insertIntoSharedPreference(HelpFunctions.sharedPrefIsTenant,body['details']['isTenant']);
    HelpFunctions.insertIntoSharedPreference(HelpFunctions.sharedPrefTenantId,body['details']['tenantId']);

    }

}
