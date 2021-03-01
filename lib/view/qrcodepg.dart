import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:help_desk_app/view/dashboardpg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class GrievancePage extends StatefulWidget {
  @override
  _GrievancePageState createState() => _GrievancePageState();
}

class _GrievancePageState extends State<GrievancePage> {
  List<DropdownMenuItem<String>> _dropDownItems = [];
  String count,value = "";
  String _selected;
  String complaint;
  File image;
  checkPermissions() async{
    var cameraStatus = await Permission.camera.status;
    var storageStatus = await Permission.storage.status;
    if(!cameraStatus.isGranted ){
      await Permission.camera.request();
    }else{

    }
    if(!storageStatus.isGranted ){
      await Permission.storage.request();
    }else{

    }
  }

  List<DropdownMenuItem<String>> _dropDownComplaintItems = [];
  List<String> data = [
    'Data 1',
    'Data 2',
    'Data 3',
    'Data 4',
    'Data 5',
  ];
  List<String> complaints = [
    'Complaint 1',
    'Complaint 2',
    'Complaint 3',
    'Complaint 4',
    'Complaint 5'
  ];
  @override
  void initState() {
    checkPermissions();
    for (String i in data) {
      _dropDownItems.add(DropdownMenuItem(
          value: i,
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Text(i),
            ],
          )));
    }
    for (String i in complaints) {
      _dropDownComplaintItems.add(DropdownMenuItem(
        value: i,
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Text(i),
          ],
        ),
      ));
    }

    _selected = _dropDownItems[0].value;
    complaint = _dropDownComplaintItems[0].value;
    // TODO: implement initState
    super.initState();
  }

  pickAnImage() async{
    File imageFromCamera = await ImagePicker.pickImage(source: ImageSource.camera);
    if(imageFromCamera!=null){
      image = imageFromCamera;
      setState(() {
        
      });
    }
  }

  Future incrementCounter() async{
    count = await FlutterBarcodeScanner.scanBarcode('#004297', 'cancel', true, ScanMode.QR);
    setState(() {
      value = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: IconButton(
                              icon:Icon(Icons.arrow_back,
                              color: Colors.white,),
                              onPressed: (){
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DashboardPage()));
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              incrementCounter();
                            },
                            child: Center(
                              child: Column(
                                children: [
                                  Container(
                                    child: Column(
                                        children: [
                                      Icon(Icons.qr_code_scanner,
                                      color: Colors.white,
                                      size: 70,),
                                      SizedBox(height: 5,),
                                          Text('Tap to Scan',style: TextStyle(color: Colors.white),)
                                    ]),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                Expanded(
                    flex: 8,
                    child: Column(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            margin: EdgeInsets.all(15),
                            padding: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child:Row(
                              children: [
                                Icon(
                                  Icons.qr_code,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 20,),
                                Text(value,style: TextStyle(color: Colors.black54),)
                              ],
                            )

                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton(
                            hint: Text('Select items'),
                            underline: Container(),
                            isExpanded: true,
                            value: _selected,
                            items: _dropDownItems,
                            onChanged: onChangeDropMenuItem,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton(
                            hint: Text('Select items'),
                            underline: Container(),
                            isExpanded: true,
                            value: complaint,
                            items: _dropDownComplaintItems,
                            onChanged: onChangeComplaintItem,
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            print('Working...');
                            pickAnImage();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            margin: EdgeInsets.all(15),
                            padding: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)
                            ),
                            child:Row(
                              children: [
                                Icon(Icons.cloud_upload_outlined,color: Colors.grey,),
                                SizedBox(width: 20,),
                                image==null?Text(''):
                                Image.file(image),
                              ],
                            )

                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(15.0),
                          child: TextField(
                            maxLines: 4,
                            style: TextStyle(color: Colors.black54),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 1)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1),
                              ),
                              hintText: "Description",
                            ),
                          ),
                        ),
                        Center(
                          child: FloatingActionButton(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.blue,
                            ),
                            onPressed: () async {
                              // List<int>imageBytes = image.readAsBytesSync();
                              // print(imageBytes);
                              // String base64Image = await base64Encode(imageBytes);
                              // print(base64Image);
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DashboardPage()));
                            },
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  onChangeDropMenuItem(String val) {
    setState(() {
      _selected = val;
    });
  }

  onChangeComplaintItem(String val) {
    setState(() {
      complaint = val;
    });
  }
}
