import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isSplashCompleted = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible;

  @override
  void initState() {
    // TODO: implement initState
    _passwordVisible = false;
    super.initState();
    checkPermissions();

  }

  checkPermissions() async{
    var cameraStatus = await Permission.camera.status;
    var storageStatus = await Permission.storage.status;
    if(!cameraStatus.isGranted && !storageStatus.isGranted){


    }else{
    }
  }

  @override
  Widget build(BuildContext context) {
    return containerPg();
  }

  Widget containerPg()  {
    if (isSplashCompleted) {
      return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.blue[600],
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.live_help,
                    color: Colors.white,
                    size: 55,
                  ),
                  Text(
                    'Grievance',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  Text(
                    'Redress',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: TextField(
                      controller: _emailController,
                      enableInteractiveSelection: false,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: Colors.white, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: Colors.white, width: 1.0),
                          ),
                          hintText: 'Username',
                          hintStyle: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w800)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      enableInteractiveSelection: false,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: Colors.white, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: Colors.white, width: 1.0),
                          ),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w800)),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      print(_emailController.text);
                      print(_passwordController.text);
                    },
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.blue,
                    ),
                    backgroundColor: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else {

      Future.delayed(Duration(milliseconds: 3000), () {
        setState(() {
          isSplashCompleted = true;
        });
      });
      return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.blue[900],
        body: SingleChildScrollView(
            child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.live_help,
                size: 60,
                color: Colors.white,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Grievance',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              Text(
                'Redress',
                style: TextStyle(color: Colors.white, fontSize: 25),
              )
            ],
          ),
        )),
      );
    }
  }
}
