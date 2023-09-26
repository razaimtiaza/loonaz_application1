import 'dart:convert';
import 'dart:io';

import '../Models/dps_wallpaper_model.dart';
import '../src/constants/config.dart';
import 'package:http/http.dart' as http;

import '../src/features/models/dps_model/dps_model.dart';

class DpsWallPaperRepo {
  Future<DpsWallPaper> getDpWallPaper(int page) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://loonaz.com/api/list/?port=dp&page=$page&per_page=10&query=new'),
      );
      if (response.statusCode == Constants.successCode) {
        // If the server did return a 200 OK response, parse the response body
        print("getAllCategories Response:${response.body.toString()}");
        // json = jsonDecode(response.body);
        return DpsWallPaper.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response, throw an error.
        // ToastComponent.showDialog(jsonDecode(response.body)['message']);
        throw Exception(jsonDecode(response.body)['message']);
      }
    } on SocketException {
      // ToastComponent.showDialog('No Internet Connection');
      throw Exception("No Internet Connection");
    }
  }
}
