import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:loonaz_application/Models/live_wallpaper_model.dart';
import 'package:loonaz_application/repositries/live_wallpaper_repo.dart';

class LiveWallPaperViewModel extends ChangeNotifier{
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  final List<LiveWallPaperData> _wallPapers = [];
  bool get loading => _loading;

  List<LiveWallPaperData> get wallPapers => _wallPapers;
  bool _loading = false;

  LiveWallPaperRepo repo = LiveWallPaperRepo();
  int page = 1;
  Future<void> getAllWallPapers() async {
    setLoading(true);
    repo.getLiveWallPaper(page).then((value) async {
      if (value != null && value.data != null) {
        // _wallPapers.clear();
        for (List<LiveWallPaperData> innerData in value.data!) {
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