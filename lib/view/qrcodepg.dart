import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:help_desk_app/api/apiurls.dart';
import 'package:help_desk_app/data/sharedpreffunctions.dart';
import 'package:help_desk_app/view/dashboardpg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:http_parser/http_parser.dart';
class GrievancePage extends StatefulWidget {
  @override
  _GrievancePageState createState() => _GrievancePageState();
}

class _GrievancePageState extends State<GrievancePage> {
  String count,assetValue = "";

  String complaint;
  int assetIdData;
  int typeOfComplaintId;
  String typeOfComplaintValue;
  int complaintId;
  String assetComplaintsUrl;
  String typeOfComplaintUrl;
  String availableComplaintsUrl;

  File image;
  List data=[];
  List complaintsData=[];

  TextEditingController descController = TextEditingController();
  Dio dio = Dio();

  @override
  void initState() {
    checkPermissions();
    fetchData();
    super.initState();
  }

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

  fetchData()async{
    typeOfComplaintUrl = ApiUrls.BASEURL+ApiUrls.COMPLAINTTYPE;
    var result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){
      var response = await http.get(typeOfComplaintUrl);
      if(response.statusCode == 200){
        print('Response.......');
        print(response.body);
        var convertToJson = json.decode(response.body);
        setState(() {
          data = convertToJson['details'];
        });

      }
    }else{
      Toast.show("No Internet Connection", context);
    }
  }

  showAlertDialog(BuildContext context, List<dynamic> dialogData) {

    AlertDialog alert = AlertDialog(
      title: Text("Select type of Complaint"),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: Flex(
          direction: Axis.vertical,
          mainAxisSize:MainAxisSize.min,
          children:[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(15),
                child: Scrollbar(
                  child: ListView.builder(
                      itemCount: dialogData.length,
                      itemBuilder: (context,i){
                        return ListTile(
                          title: Text(dialogData[i]['itemText'],style: TextStyle(color: Colors.black54),),
                          onTap: (){
//                            print(dialogData[i]['itemValue']);
                          setState(() {
                            typeOfComplaintValue = dialogData[i]['itemText'];
                            typeOfComplaintId = dialogData[i]['itemValue'];
                          });

                            Navigator.pop(context);
                          },
                        );
                      }),
                ),
              ),
            ),
          ]
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

  }

  pickAnImage() async{
    File imageFromCamera = await ImagePicker.pickImage(source: ImageSource.camera);
    if(imageFromCamera!=null){
      image = imageFromCamera;
      setState(() {
        
      });
    }
  }

   incrementCounter() async{
    count = await FlutterBarcodeScanner.scanBarcode('#004297', 'cancel', true, ScanMode.QR);
    //count = 'BB27AD5C-A9CC-4ACA-905B-20550D10484B';
    count = '13237312-F7AF-4BC6-A3E3-B8E03944E0EF';
    assetComplaintsUrl = ApiUrls.BASEURL+ApiUrls.GETASSETID+"?AssetKey="+count;
    var response = await http.get(assetComplaintsUrl);
    if(response.statusCode == 200){
      var convertToJson = json.decode(response.body);
      setState(() {
        assetIdData = convertToJson['details']['assetId'];
        assetValue = count;
        print('Asset id is $assetIdData');
      });
      openComplaints();
    }
  }

  openComplaints() async{

    availableComplaintsUrl = ApiUrls.BASEURL+ApiUrls.COMPLAINTSAPI+"?AssetId="+assetIdData.toString();
    var result = await Connectivity().checkConnectivity();
    if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){
      var response = await http.get(availableComplaintsUrl);
      if(response.statusCode == 200){
        print('Complaints Available');
        print(response.body);
        var convertToJson = json.decode(response.body);
        setState(() {
          complaintsData = convertToJson['details'];
        });
      }
    }else{
      Toast.show("No Internet Connection", context);
    }

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
                                Text(assetValue,style: TextStyle(color: Colors.black54),)
                              ],
                            )

                        ),
                        GestureDetector(
                          onTap: (){
                            showAlertDialog(context,data);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            margin: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child:typeOfComplaintId!=null ?Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(typeOfComplaintValue,style: TextStyle(fontSize: 16),),
                                  Align(alignment: Alignment.centerRight,child: Icon(Icons.keyboard_arrow_down_rounded,color: Colors.red,),)
                                ],
                              ),
                            ):Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Select Type Of Complaint',style: TextStyle(fontSize: 16),),
                                  Align(alignment: Alignment.centerRight,child: Icon(Icons.keyboard_arrow_down_rounded,color: Colors.red,),)
                                ],
                              ),
                            )
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            if(assetIdData==null){
                              Toast.show("Scan the asset first", context);
                            }else{
                              if(complaintsData!=null && complaintsData.length ==0){
                                Toast.show("No data available", context);
                              }else{
                                showComplaintDialog(context,complaintsData);
                              }
                            }
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              margin: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child:((complaintsData!=null&&complaintsData.length>0)&&(complaint!=null))?Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(complaint,style: TextStyle(fontSize: 16),),
                                    Align(alignment: Alignment.centerRight,child: Icon(Icons.keyboard_arrow_down_rounded,color: Colors.red,),)
                                  ],
                                ),
                              ):Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Select Complaint',style: TextStyle(fontSize: 16),),
                                    Align(alignment: Alignment.centerRight,child: Icon(Icons.keyboard_arrow_down_rounded,color: Colors.red,),)
                                  ],
                                ),
                              )
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
                            controller: descController,
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
                              int id =  await HelpFunctions.getIntSharedPref(HelpFunctions.sharedPrefUserId);
                              String descData = descController.text;
                              print('User id is $id');
                              print('Asset key is $assetValue');
                              print('Type of Complaint is $typeOfComplaintId');
                              print('Complaint id is $complaintId');
                              print('Desc is $descData');

                              // List<int>imageBytes = image.readAsBytesSync();
                              // print(imageBytes);
                              // String base64Image = await base64Encode(imageBytes);
                              // print(base64Image);

                              if(image.exists() != null && assetValue!=null && typeOfComplaintId!=null &&
                                  complaintId!=null && descController.text!=null){
                                // Uri addressUri = Uri.parse('http://apitest.dbzapps.com/api/RequesterTicketAPI/InsertRequesterTicket');
                                // final mimeTypeData = lookupMimeType(image.path,headerBytes: [0xFF,0xD8]).split('/');
                                // final imageUploadRequest = http.MultipartRequest('POST',addressUri);
                                // final file = await http.MultipartFile('file',image.readAsBytes().asStream(),image.lengthSync(),filename: 'ComplaintImage',
                                // contentType: MediaType('image','jpeg'));
                                // print(image.path);
                                // print(file);
                                // imageUploadRequest.files.add(file);
                                // imageUploadRequest.fields.addAll({
                                //   'UserId':HelpFunctions.getIntSharedPref(HelpFunctions.sharedPrefUserId).toString(),
                                //   'AssetKey':assetValue,
                                //   'ComplaintTypeId':typeOfComplaintId.toString(),
                                //   'ComplaintId':complaintId.toString(),
                                //   'Description':descController.text,
                                //   'TenantId':'0',
                                //   'TenantUserId':'0'
                                // });

                                String fileName = 'file '+DateTime.now().toIso8601String();
                                FormData formData = FormData.fromMap({
                                  'UserId':HelpFunctions.getIntSharedPref(HelpFunctions.sharedPrefUserId).toString(),
                                  'AssetKey':assetValue,
                                  'ComplaintTypeId':typeOfComplaintId.toString(),
                                  'ComplaintId':complaintId.toString(),
                                  'Description':descController.text,
                                  'TenantId':'0',
                                  'TenantUserId':'0',
                                  'ComplaintImage':await MultipartFile.fromFile(image.path,filename: fileName,contentType: MediaType("image", "jpeg"))
                                });
                                Response response = await dio.post("http://apitest.dbzapps.com/api/RequesterTicketAPI/InsertRequesterTicket",data: formData);
                                if(response.statusCode == 200){
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DashboardPage()));
                                }else{
                                  print(response.statusCode);
                                  print('status message');
                                  print(response.statusMessage);
                                }


                                //  imageUploadRequest.fields['UserId'] = await HelpFunctions.getIntSharedPref(HelpFunctions.sharedPrefUserId).toString();
                                //  imageUploadRequest.fields['AssetKey'] = assetValue;
                                //  imageUploadRequest.fields['ComplaintTypeId'] = typeOfComplaintId.toString();
                                //  imageUploadRequest.fields['ComplaintId'] = complaintId.toString();
                                //  imageUploadRequest.fields['Description'] = descController.text;
                                //  imageUploadRequest.fields['TenantId'] = '0';
                                //  imageUploadRequest.fields['TenantUserId'] = '0';

                                //
                                // try{
                                //   final streamResponse = await imageUploadRequest.send();
                                //   print(streamResponse.reasonPhrase);
                                //   print('Stream Response...');
                                //   print(streamResponse.toString());
                                //   final response = await http.Response.fromStream(streamResponse);
                                //   if(response.statusCode==200){
                                //     final Map<String,dynamic> responseData = json.decode(response.body);
                                //     print(responseData);
                                //     Navigator.of(context).pop();
                                //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DashboardPage()));
                                //   }else{
                                //     print(response.statusCode);
                                //   }
                                // }catch(e){
                                //   print(e.toString());
                                // }
                              }








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


  showComplaintDialog(BuildContext context, List complaintsData) {
    AlertDialog alert = AlertDialog(
      title: Text("Select Complaint"),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: Flex(
            direction: Axis.vertical,
            mainAxisSize:MainAxisSize.min,
            children:[
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Scrollbar(
                    child: ListView.builder(
                        itemCount: complaintsData.length,
                        itemBuilder: (context,i){
                          return ListTile(
                            title: Text(complaintsData[i]['itemText'],style: TextStyle(color: Colors.black54),),
                            onTap: (){
//                            print(dialogData[i]['itemValue']);
                              setState(() {
                                complaint = complaintsData[i]['itemText'];
                                complaintId = complaintsData[i]['itemValue'];
                              });

                              Navigator.pop(context);
                            },
                          );
                        }),
                  ),
                ),
              ),
            ]
        ),
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
