import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelpFunctions{

  static String sharedPrefUserId = "USERID";
  static String sharedPrefUserKey = "USERKEY";
  static String sharedPrefFacilityId = "FACILITYID";
  static String sharedPrefUserFirstName = "USERFIRSTNAME";
  static String sharedPrefUserMiddleName = "USERMIDDLENAME";
  static String sharedPrefUserLastName = "USERLASTNAME";
  static String sharedPrefUserAddress = "USERADDRESS";
  static String sharedPrefUserMailId = "USERMAILID";
  static String sharedPrefUserContact = "USERCONTACT";
  static String sharedPrefUserPhotoPath = "USERPHOTOPATH";
  static String sharedPrefClientRoleId = "CLIENTROLEID";
  static String sharedPrefIsTechnician = "ISTECHNICIAN";
  static String sharedPrefIsSuperAdmin = "ISSUPERADMIN";
  static String sharedPrefIsAdmin = "ISADMIN";
  static String sharedPrefIsTenant = "ISTENANT";
  static String sharedPrefTenantId = "TENANTID";


  static Future<void> saveIntoSharedPreference(String key,String val) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(key,val);
  }


  static Future<void> insertIntoSharedPreference(String key,int val) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setInt(key,val);
  }

  static Future<String> getStringSharedPref(String key) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(key);
  }
  static Future<int> getIntSharedPref(String key) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getInt(key);
  }

}