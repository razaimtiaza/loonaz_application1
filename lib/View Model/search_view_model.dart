import 'package:flutter/cupertino.dart';
import 'package:loonaz_application/repositries/wallpaper_repo.dart';

import '../src/features/models/dashboard/wallpaper/wallpaper_model.dart';

class SearchViewModel extends ChangeNotifier{


  List<Data> _searchResults = [];
  bool _isLoading = false;

 int page =  1;
HomeRepo repo= HomeRepo();
  List<Data> get searchResults => _searchResults;
  bool get isLoading => _isLoading;

  Future<void> searchWallpapers(String query) async {
    if (query.isEmpty) {
      _searchResults.clear();
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final value = await repo.getBySingleCategory(page, query);
      if (value != null && value.data != null) {
        _searchResults.clear();
        for (List<Data> innerData in value.data!) {
          _searchResults.addAll(innerData);
        }
        page++;
      }
    } catch (error) {
      print(error.toString());
    }

    _isLoading = false;
    notifyListeners();
  }
}