import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:loonaz_application/repositries/wallpaper_repo.dart';
import 'package:loonaz_application/src/features/models/dashboard/wallpaper/wallpaper_model.dart';

import 'package:http/http.dart' as http;

import '../src/constants/config.dart';

class WallPaperViewModel extends ChangeNotifier {
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  final List<Data> _wallPapers = [];
  final List<Data> _category = [];
  bool get loading => _loading;

  List<Data> get wallPapers => _wallPapers;
  List<Data> get category => _category;
  bool _loading = false;

  HomeRepo repo = HomeRepo();
  int page = 1;
  int catPage = 1;

  Future<void> getAllWallPapers() async {
    setLoading(true);
    repo.getAllWallPapers(page).then((value) async {
      if (value != null && value.data != null) {
        // _wallPapers.clear();
        for (List<Data> innerData in value.data!) {
            _wallPapers.addAll(innerData);
          // for (Data currentData in innerData) {
          //   _wallPapers.add(currentData);
          //   // Now you can access currentData and its properties
          //   print('zain');
          //   print(wallPapers[0].file_high);
          // }
        }
        page++;
      }
      setLoading(false);
    }).onError((error, stackTrace) {
      setLoading(false);
      // ToastComponent.showDialog(error.toString());
      if (kDebugMode) {
        print(stackTrace.toString());
      }
    });
  }
  Future<void> getAllCategories() async {
    setLoading(true);
    repo.getAllCategories(catPage).then((value) async {
      if (value != null && value.data != null) {
        // _wallPapers.clear();
        for (List<Data> innerData in value.data!) {
          _category.addAll(innerData);
          // for (Data currentData in innerData) {
          //   _wallPapers.add(currentData);
          //   // Now you can access currentData and its properties
          //   print('zain');
          //   print(wallPapers[0].file_high);
          // }
        }
        catPage++;
      }
      setLoading(false);
    }).onError((error, stackTrace) {
      setLoading(false);
      // ToastComponent.showDialog(error.toString());
      if (kDebugMode) {
        print(stackTrace.toString());
      }
    });
  }

// Future<Wallpaper> fetchwallData() async {
//   String url =
//       "https://loonaz.com/api/list/?port=wallpaper&page=3&per_page=10&query=new";
//   try {
//     final response = await http.get(Uri.parse(url));
//
//     print("API Response Code: ${response.statusCode}");
//     print("API Response Body: ${response.body}");
//
//     if (response.statusCode == 200) {
//       final body = jsonDecode(response.body);
//       return Wallpaper.fromJson(body);
//     } else {
//       throw Exception(
//           "API request failed with status code: ${response.statusCode}");
//     }
//   } catch (error) {
//     print("Error fetching data: $error");
//     throw Exception("Error fetching data: $error");
//   }
// }
}
