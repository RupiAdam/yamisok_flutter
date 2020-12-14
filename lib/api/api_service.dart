import 'package:yamisok/model/profile_model.dart';
import 'package:yamisok/model/comunity_model.dart';
import 'package:http/http.dart' show Client;
import 'package:yamisok/component/globals.dart' as global;
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'api_master.dart';
import 'package:yamisok/component/keyStore.dart'; 


Client client = Client();


class ApiService {
    Future<Tesprofile> fetchPost() async {
    // final token = await keyStore.getToken();
    final token = "ifkMGpe6M0pnPzyDVTNPlyrEjBnjiAuNZlkCfiNVmcFaYzGp21rb09v5TAyq";
     Map data2 = {
      'token': token,
      'player_id':'17698'
    };
    //encode Map to JSON 18776 fauzan
    var body = json.encode(data2);

    print('profile body : $body');
    final response = await client.post(
      "$apibase/users/detail",
      headers: {"content-type": "application/json"},
      body: body,
    );
    // final response = await client.get("$baseUrl3/posts/1");
     final datates = json.decode(response.body);
    Tesprofile newtes = new Tesprofile.fromJson(datates);
    Map bodyresult = json.decode(response.body);
    
    // print('lihat profile $bodyresult');
    
    if (newtes.status == 200) {
     return Tesprofile.fromJson(json.decode(response.body));
    } else {
      return null;
    }

  }
 
}

// class ApiServiceComunity {
//     Future<Community> fetchPost() async {
//      Map data2 = {
//       'token': 'iyHUbwbJk7zsF0B3sY5TWNWqHjwWpd5bu8KMDj52pDrjZ72vxnqj66lTWgHX',
//       'player_id':'17698',
//       'offset': 0,
//       'limit': 15,
//       'game_group_id':'all',
//       'country_id':1
//     };
//     //encode Map to JSON 18776 fauzan
//     var body = json.encode(data2);


//     final response = await client.post(
//       "$apibase/communities",
//       headers: {"content-type": "application/json"},
//       body: body,
//     );
//     // final response = await client.get("$baseUrl3/posts/1");
//     final datates = json.decode(response.body);
//     Community newtes = new Community.fromJson(datates);
//     Map bodyresult = json.decode(response.body);
    
//     // print('lihat profile $bodyresult');

//   //  final statusapi = newtes.status;
//      print('lihat comunity status $bodyresult ' );
//     if (newtes.status == 200) {
//      return compute(parseData, response.body);
//     } else {
//       return null;
//     }

//   }
//   List<Community> parseData(String responseBody) {
//   final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

//   List<Community> list =
//       parsed.map<Community>((json) => new Community.fromJson(json)).toList();
//   return list;
//   }
 
// }
  
// class ApiServiceBackup {

//   Future<List<Profile>> getProfiles() async {
//     final response = await client.get("$baseUrl/profile");
//     if (response.statusCode == 200) {
//       return profileFromJson(response.body);
//     } else {
//       return null;
//     }
//   }

//  Future<List<Profile>> getProfiles2() async {
//     final response = await client.post(
//         "$baseUrl2/users/detail",
//         headers: {"content-type": "application/json"},
//         body: {"token": "iyHUbwbJk7zsF0B3sY5TWNWqHjwWpd5bu8KMDj52pDrjZ72vxnqj66lTWgHX",
//                 "player_id": "17698" 
//               },
//         );
//     if (response.statusCode == 200) {
//       return profileFromJson(response.body);
//       print(response);
//     } else {
//       return null;
//     }
//   }
  
//   Future<bool> createProfile(Profile data) async {
//     final response = await client.post(
//       "$baseUrl/profile",
//       headers: {"content-type": "application/json"},
//       body: profileToJson(data),
//     );
//     if (response.statusCode == 201) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future<bool> updateProfile(Profile data) async {
//     final response = await client.put(
//       "$baseUrl/profile/${data.id}",
//       headers: {"content-type": "application/json"},
//       body: profileToJson(data),
//     );
//     if (response.statusCode == 200) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future<bool> deleteProfile(int id) async {
//     final response = await client.delete(
//       "$baseUrl/profile/$id",
//       headers: {"content-type": "application/json"},
//     );
//     if (response.statusCode == 200) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//      Future<bool> getProfiles3(Profile data) async {
//     Map data2 = {
//       'token': 'mVI6uIsWeT3tqtHwJ1auDPGq7HXYpDKK2hQdezvZkfhezhNjWBSDZTmrOgyu',
//       'player_id':'17698'
//     };
//     //encode Map to JSON
//     var body = json.encode(data2);


//     final response = await client.post(
//       "$baseUrl2/users/login",
//       headers: {"content-type": "application/json"},
//       body: body,
//     );
//      print(response);
//     if (response.statusCode == 201) {
//       return true;
//     } else {
//       return false;
//     }
//   }
// }


