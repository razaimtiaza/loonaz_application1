import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:loonaz_application/repositries/ringtone_repo.dart';

import '../Models/ringtones_model.dart';

class RingToneViewModel extends ChangeNotifier {
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final List<Item> _ringTones = [];
  final List<Item> _popular = [];

  bool get loading => _loading;

  List<Item> get ringTones => _ringTones;
  List<Item> get popularRing => _popular;
  bool _loading = false;

  RingTonesRepo repo = RingTonesRepo();
  int page = 1;

  Future<void> getAllRingtones() async {
    setLoading(true);
    repo.getAllRingTones(page).then((value) async {
      if (value != null && value.data != null) {
        for (List<Item> innerData in value.data) {
          _ringTones.addAll(innerData);
        }
        page++;
      }
      setLoading(false);
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(stackTrace.toString());
      }
    });
  }
 int popular = 1;
  Future<void> getAllPopular() async {
    setLoading(true);
    repo.getAllPopularTones(popular).then((value) async {
      if (value != null && value.data != null) {
        for (List<Item> innerData in value.data) {
          _popular.addAll(innerData);
        }
        popular++;
      }
      setLoading(false);
    }).onError((error, stackTrace) {
      setLoading(false);
      if (kDebugMode) {
        print(stackTrace.toString());
      }
    });
  }
}
