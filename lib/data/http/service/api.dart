import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '../interface/api.dart';

class ApiService implements ApiInterface{

  @override
  Future<Map?> getData(String url) async{
    try{
      var response = await get(Uri.parse(url));
      if(response.statusCode == 200){
        final data = await jsonDecode(response.body);
        return data;
      } else{
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return null;
    }
  }

  @override
  Future<Map?> sendData(List body, String url) async{
    try{
      var responseBody = json.encode(body);
      var response = await post(Uri.parse(url), body: responseBody, headers: {'Content-Type': 'application/json'});
      if(response.statusCode == 200){
        var jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      return null;
    }
  }
  
}