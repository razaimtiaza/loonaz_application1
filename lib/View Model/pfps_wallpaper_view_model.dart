import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:loonaz_application/src/features/models/pfps_model/pfps_model.dart';

import '../Models/pfps_mdoel.dart';
import '../repositries/pfp_repo.dart';

class PfPsWallPaperViewModel extends ChangeNotifier{
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  final List<PfpWallPaperData> _wallPapers = [];
  bool get loading => _loading;

  List<PfpWallPaperData> get wallPapers => _wallPapers;
  bool _loading = false;

  PfPsWallPaperRepo repo = PfPsWallPaperRepo();
  int page = 1;
  Future<void> getPfPsWallpaper() async {
    setLoading(true);
    repo.getPfpWallPaper(page).then((value) async {
      if (value != null && value.data != null) {
        // _wallPapers.clear();
        for (List<PfpWallPaperData> innerData in value.data!) {
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