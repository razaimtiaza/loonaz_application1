import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../repositries/wallpaper_repo.dart';
import '../src/features/models/dashboard/wallpaper/wallpaper_model.dart';

class SingleCategoryViewModel extends ChangeNotifier{
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  final List<Data> _wallPapers = [];
  bool get loading => _loading;

  List<Data> get wallPapers => _wallPapers;
  bool _loading = false;

  HomeRepo repo = HomeRepo();
  int page = 1;
  Future<void> getAllWallPapers(String query) async {
    setLoading(true);
    repo.getBySingleCategory(page,query).then((value) async {
      if (value != null && value.data != null) {
        // _wallPapers.clear();
        for (List<Data> innerData in value.data!) {
          _wallPapers.addAll(innerData);
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
}