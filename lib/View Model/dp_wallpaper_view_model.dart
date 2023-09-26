import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:loonaz_application/Models/dps_wallpaper_model.dart';
import 'package:loonaz_application/repositries/dp_reop.dart';

class DpsWallPaperViewModel extends ChangeNotifier{
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  final List<Data> _wallPapers = [];
  bool get loading => _loading;

  List<Data> get wallPapers => _wallPapers;
  bool _loading = false;

  DpsWallPaperRepo repo = DpsWallPaperRepo();
  int page = 1;
  Future<void> getAllWallPapers() async {
    setLoading(true);
    repo.getDpWallPaper(page).then((value) async {
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